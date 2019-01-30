//
//  HomeRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeRequest.h"
//#define urlSuffix_str1 @"/index2/?format=json&platform=mobile"
//#define urlSuffix_str @"/index/?format=json"

@implementation HomeRequest

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock {
    
    NSString *urlSuffix_str ;
    if (self.currentIndex) {
        urlSuffix_str = [NSString stringWithFormat:@"/genres/%@/?format=json&platform=mobile",self.currentIndex];
    } else {
        urlSuffix_str = @"/index2/?format=json&platform=mobile";
    }
    [self baseGetRequest:params andTransactionSuffix:urlSuffix_str andBlock:^(GetBaseHttpRequest *responseData) {
        [self JsonArrayForHeadParsing:responseData._data];
        block(self);
    } andFailure:^(GetBaseHttpRequest *responseData) {
        self.responseError = responseData.error;
        failureBlock(self);
    }];
    
    return self;
}

- (void)JsonArrayForHeadParsing:(id) responseObject {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    if (dic[@"config"]) {
        [[NSUserDefaults standardUserDefaults] setObject:dic[@"config"] forKey:@"config"];
    }
    
    if (dic[@"genres"]) {
        NSArray *genres = dic[@"genres"];
        self.genresArray = [GenresModel modelsWithArray:genres];
    }
    
    self.storageArray = dic[@"carousel"];
    
    NSArray *headArray = dic[@"carousel"];
    self.responseHeadArray = [HomeModel modelsWithArray:headArray];
    
    for (int i = 0; i<[dic[@"data"] count]; i++) {
        NSArray *itemArray = dic[@"data"];
        NSDictionary *itemDic = itemArray[i];
        [self assembleData:itemDic];
//        if ([itemDic[@"data"] count] > 0) {
//            [self assembleData:itemDic];
//        }
    }
    
    for (int i = 0; i<[dic[@"data"] count]; i++) {
        NSDictionary *contentDic = dic[@"data"][i];
        if ([contentDic[@"data"] count] > 0) {
            [self.responseDataArray addObject:[HomeModel modelsWithArray:contentDic[@"data"]]];
        }
    }
}

//将传过来的数据组装成新的titleArray
- (void) assembleData:(NSDictionary *)dic {
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [newDic removeObjectForKey:@"data"];
    if ([dic[@"data"] count] > 0) {
        [self.titleArray addObject:newDic];
        [self.title_passed addObject:newDic];
    } else {
        [self.title_passed addObject:newDic];
    }
}

- (NSArray *) storageArray {
    if (_storageArray == nil) {
        _storageArray = [NSArray array];
    }
    return _storageArray;
}

- (NSArray *) genresArray {
    if (_genresArray == nil) {
        _genresArray = [NSArray array];
    }
    return _genresArray;
}

- (NSMutableArray *)responseDataArray {
    if (_responseDataArray == nil) {
        _responseDataArray = [NSMutableArray array];
    }
    return _responseDataArray;
}

- (NSMutableArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)title_passed {
    if (!_title_passed) {
        _title_passed = [NSMutableArray arrayWithCapacity:0];
    }
    return _title_passed;
}

@end
