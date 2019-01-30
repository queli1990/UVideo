//
//  PlayerRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/25.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerRequest.h"

@interface PlayerRequest()
@property (nonatomic,strong) NSMutableArray *bigArray;
@property (nonatomic) int requestPage;
@end

@implementation PlayerRequest

- (id) requestRelatedData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock {
    NSString *urlSuffix_str = [NSString stringWithFormat:@"/related/%@/?format=json",self.ID];
    
    [self baseGetRequest:params andTransactionSuffix:urlSuffix_str andBlock:^(GetBaseHttpRequest *responseData) {
        [self jsonArray:responseData._data];
        block(self);
    } andFailure:^(GetBaseHttpRequest *responseData) {
        self.responseError = responseData.error;
        failureBlock(self);
    }];
    return self;
}

- (void) jsonArray:(id)responseObject {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *carouselArray = dic[@"data"];
    self.responseData = [HomeModel modelsWithArray:carouselArray];
}


- (void) requestVimeoPlayurl:(vimeoResponseBlock)block andFailureBlock:(vimeoResponseBlock)failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //不设置会报-1016或者会有编码问题
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //不设置会报 error 3840
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/vnd.vimeo.video+json", nil];
    //创建你得请求url、设置请求头
    NSString *urlString;
    if (self.genre_id.integerValue == 3) { //电影
        urlString = [NSString stringWithFormat:@"https://api.vimeo.com/videos/%@",self.vimeo_id];
    } else {
        urlString = [NSString stringWithFormat:@"https://api.vimeo.com/me/albums/%@/videos?direction=desc&page=1&per_page=100&sort=alphabetical&fields=name,files,download,pictures",self.vimeo_id];
    }
    NSString *token = [NSString stringWithFormat:@"Bearer %@",self.vimeo_token];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/vnd.vimeo.*+json;version=3.1" forHTTPHeaderField:@"Accept"];
    //[request addValue:你需要的user-agent forHTTPHeaderField:@"User-Agent"];
    //发起请求
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (self.genre_id.integerValue == 3) { //电影
//                [self.bigArray addObject:dic];
                [self jsonUrlArray:dic];
                block(self);
            } else {
                [self.bigArray addObjectsFromArray:dic[@"data"]];
                _requestPage = 1;
                self.totalEpisode = dic[@"total"];
                [self requestNextPage:dic andCallBack:block];
            }
        } else {
            failureBlock(self);
        }
    }] resume];
}

//处理数据，如果100条以上的数据，则在此处递归请求。
- (void) requestNextPage:(NSDictionary *)dic andCallBack:(vimeoResponseBlock)block{
    long remainCount = [dic[@"total"] integerValue] - _requestPage*100;
    if (remainCount > 0) {
        _requestPage += 1;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //                //不设置会报-1016或者会有编码问题
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //                //不设置会报 error 3840
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/vnd.vimeo.video+json", nil];
        //创建你得请求url、设置请求头
        NSString *url = [NSString stringWithFormat:@"https://api.vimeo.com/me/albums/%@/videos?direction=desc&page=%d&per_page=100&sort=alphabetical",self.vimeo_id,_requestPage];
        NSString *token = [NSString stringWithFormat:@"Bearer %@",self.vimeo_token];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
        [request addValue:token forHTTPHeaderField:@"Authorization"];
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //递归
            [self.bigArray addObjectsFromArray:dic2[@"data"]];
            [self requestNextPage:dic2 andCallBack:block];
        }] resume];
    } else {
        NSDictionary *jsonDic = @{@"data":self.bigArray};
        [self jsonUrlArray:jsonDic];
        _requestPage = 1;
        block(self);
    }
}


- (void) jsonUrlArray:(NSDictionary *)dic {
    if (self.genre_id.integerValue == 3) {
        self.vimeo_responseDataDic = dic;
    }else {
        //self.vimeo_responseDataArray = dic[@"data"];
        //传入数据，排序,请求接口加入sort=alphabetical字段后就不用自己排序了
//        [self orderArray:dic[@"data"]];
        if (!(self.genre_id.integerValue == 3)) { //
            if (self.genre_id.integerValue == 4) {// 3是电影，4是综艺,其他的是电影或者其他
                self.vimeo_responseDataArray = dic[@"data"];
            } else {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                // 倒序
                self.vimeo_responseDataArray = [[tempArr reverseObjectEnumerator] allObjects];
            }
        }
        
    }
}

/**
 此方法作废，vimeo新增了排序接口，不需要再自己排序
 */
- (void) orderArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    if (self.genre_id.integerValue == 4) {// 如果是综艺类别，去除大标题，只保留期数
        for (int i = 0; i<array.count; i++) {
            NSMutableDictionary *dic = array[i];
            int i = [self addIndex:dic[@"name"]];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
            //将综艺的name替换
            NSString *pattern = [NSString stringWithFormat:@"%@\\s*",_regexName];
            NSRange range = [dic[@"name"] rangeOfString:pattern options:NSRegularExpressionSearch];
            NSString *name = [dic[@"name"] substringFromIndex:range.length];
            [dic setObject:name forKey:@"name"];
            [tempArray addObject:dic];
        }
    } else {
        for (int i = 0; i<array.count; i++) {
            NSMutableDictionary *dic = array[i];
            int i = [self addIndex:dic[@"name"]];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
            [tempArray addObject:dic];
        }
    }
    
    [tempArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
     {
         if (self.genre_id.integerValue == 4) {
             //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列
             if ([obj1[@"index"] integerValue] < [obj2[@"index"] integerValue]){
                 return NSOrderedDescending;
             } else {
                 return NSOrderedAscending;
             }
         } else {
             //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列
             if ([obj1[@"index"] integerValue] > [obj2[@"index"] integerValue]){
                 return NSOrderedDescending;
             } else {
                 return NSOrderedAscending;
             }
         }
     }];
    self.vimeo_responseDataArray = tempArray;
}

- (int) addIndex:(NSString *)currentVideoName {
    NSString *pattern = [NSString stringWithFormat:@"(?<=%@)\\s{0,}\\d{1,4}(?=丨)|(?<=第).*\\d{1,4}.*(?=集)|(?<=%@_?)\\d{1,4}|(?<=%@)\\s{0,}\\d{1,4}|(?<=[a-zA-Z]\\s)\\d{1,4}(?=$)",_regexName,_regexName,_regexName];
    NSString *str = currentVideoName;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    int number = 0;
    if (result) {
        for (int i = 0; i<result.count; i++) {
            NSTextCheckingResult *res = result[i];
            NSString *strNum = [str substringWithRange:res.range];
            number = strNum.intValue;
        }
    }else{
//        NSLog(@"error == %@",error.description);
        number = 0;
    }
    return number;
}

- (NSMutableArray *)bigArray {
    if (_bigArray == nil) {
        _bigArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bigArray;
}



@end
