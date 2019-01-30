//
//  ShortVideoRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import "ShortVideoRequest.h"


@interface ShortVideoRequest ()
@property (nonatomic,strong) NSMutableArray *bigArray;
//@property (nonatomic,assign) int requestPage;

@property (nonatomic,copy) NSString *vimeoID;
@property (nonatomic,copy) NSString *vimeoToken;
@end

@implementation ShortVideoRequest

- (id) requestData:(NSDictionary *)params SuccessBlock:(ShortVideoRequestBlock)block failureBlcok:(ShortVideoRequestBlock)failureBlock {
    [self baseGetRequest:params andTransactionSuffix:@"/smallvideo?format=json" andBlock:^(GetBaseHttpRequest *responseData) {
        [self jsonArray:responseData._data];
        block(self);
    } andFailure:^(GetBaseHttpRequest *responseData) {
        failureBlock(self);
    }];
    return self;
}

- (void) jsonArray:(id)responseObject {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = dic[@"data"];
    self.responseData = [ShortVideoGenreModel modelsWithArray:array];
}

- (id) requestVimeo:(NSDictionary *)params SuccessBlock:(ShortVideoRequestBlock)block failureBlock:(ShortVideoRequestBlock)failureBlock {
    self.vimeoID = [params objectForKey:@"vimeoID"];
    self.vimeoToken = [params objectForKey:@"vimeoToken"];
    NSString *page = [params objectForKey:@"page"];
    NSString *perCount = [params objectForKey:@"perCount"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //不设置会报-1016或者会有编码问题
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //不设置会报 error 3840
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/vnd.vimeo.video+json", nil];
    //创建你得请求url、设置请求头
    NSString *urlString = [NSString stringWithFormat:@"https://api.vimeo.com/me/albums/%@/videos?direction=desc&page=%@&per_page=%@&sort=date",_vimeoID,page,perCount];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",_vimeoToken];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self.bigArray addObjectsFromArray:dic[@"data"]];
            self.totalCount = dic[@"total"];
            NSDictionary *jsonDic = @{@"data":self.bigArray};
            [self jsonUrlArray:jsonDic];
            block(self);
        } else {
            failureBlock(self);
        }
    }] resume];
    return self;
}

- (void) jsonUrlArray:(NSDictionary *)dic {
    //传入数据，排序。此处不用排序。
    [self orderArray:dic[@"data"]];
}

- (void) orderArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = array[i];
        ShortVideoModel *model = [ShortVideoModel new];
        model.title = dic[@"name"];
        model.url = [[dic[@"files"] lastObject] objectForKey:@"link"];
        model.imgURL = [[[dic[@"pictures"] objectForKey:@"sizes"] objectAtIndex:5] objectForKey:@"link"];
        [tempArray addObject:model];
    }
    _responseData = tempArray;
}

- (NSMutableArray *)bigArray {
    if (_bigArray == nil) {
        _bigArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bigArray;
}


@end
