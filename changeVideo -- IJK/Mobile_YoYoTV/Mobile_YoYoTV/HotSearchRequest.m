//
//  HotSearchRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/23.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HotSearchRequest.h"
#define urlSuffix_str @"/hots?format=json"


@implementation HotSearchRequest 

- (id)requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock {
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
    NSArray *carouselArray = dic[@"results"];
    self.responseData = [HomeModel modelsWithArray:carouselArray];
}


@end
