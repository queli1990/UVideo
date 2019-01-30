//
//  CollectionRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "CollectionRequest.h"
#define urlSuffix_str @"/app/member/doMyCollection.do"

@implementation CollectionRequest

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock) failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://accountcdn.chinesetvall.com/app/member/doMyCollection.do" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self jsonArray:responseObject];
        block(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _responseError = error;
        failureBlock(self);
    }];
    return self;
}

- (void) jsonArray:(id)responseObject {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *collectionList = dic[@"collectionList"];
    self.responseArray = [CollectionModel modelsWithArray:collectionList];
}



@end
