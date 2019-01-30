//
//  ListRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ListRequest.h"
//#define urlSuffix_str @"/genres/42/?format=json&platform=mobile"

@implementation ListRequest

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock {
    
    NSString *urlSuffix_str = [NSString stringWithFormat:@"/albums2/?genre=%@&format=json&platform=mobile&page=%d&page_size=20",self.ID,self.currentPage];
    
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
    self.totalCount = [dic[@"count"] intValue];
    NSArray *carouselArray = dic[@"results"];
    self.responseData = [HomeModel modelsWithArray:carouselArray];
}


@end
