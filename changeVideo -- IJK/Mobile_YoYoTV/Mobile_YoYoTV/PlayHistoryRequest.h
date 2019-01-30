//
//  PlayHistoryRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "PlayHistoryModel.h"

@interface PlayHistoryRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(PlayHistoryRequest *responseData);

@property (nonatomic,strong) NSArray *responseArray;
@property (nonatomic,strong) NSError *responseError;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock) failureBlock;


@end
