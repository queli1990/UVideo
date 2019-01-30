//
//  PlayHistoryRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayHistoryRequest.h"
#import "NSString+encrypto.h"

@interface PlayHistoryRequest()
@property (nonatomic,strong) NSDictionary *allParams;
@end


@implementation PlayHistoryRequest

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock) failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://accountcdn.chinesetvall.com/app/member/doPlayHistory.do" parameters:self.allParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self jsonArray:responseObject];
        block(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _responseError = error;
        failureBlock(self);
    }];
    return self;
}

- (NSDictionary *) allParams {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = userInfo[@"token"];
    NSString *platform = @"mobile-ios";
    NSString *channel = @"uu100";
    NSString *language = @"cn";
    NSString *combinStr = [NSString stringWithFormat:@"%@%@%@%@",token,platform,channel,language];
    NSString *mdStr = [combinStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:channel forKey:@"channel"];
    [params setObject:language forKey:@"language"];
    [params setObject:mdStr forKey:@"sign"];
    return params;
}

- (void) jsonArray:(id)responseObject {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *historyList = dic[@"historyList"];
    self.responseArray = [PlayHistoryModel modelsWithArray:historyList];
}

@end
