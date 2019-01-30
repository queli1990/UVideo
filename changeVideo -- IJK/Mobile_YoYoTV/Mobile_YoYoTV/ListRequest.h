//
//  ListRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "HomeModel.h"

@interface ListRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(ListRequest *responseData);

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSArray *responseData;
@property (nonatomic) int totalCount;
@property (nonatomic) int currentPage;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock;

@end
