//
//  CollectionRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "CollectionModel.h"

@interface CollectionRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(CollectionRequest *responseData);

@property (nonatomic,strong) NSArray *responseArray;
@property (nonatomic,strong) NSError *responseError;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock) failureBlock;

@end
