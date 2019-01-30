//
//  HotSearchRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/23.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "HomeModel.h"

@interface HotSearchRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(HotSearchRequest *responseData);

@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSArray *responseData;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock;


@end
