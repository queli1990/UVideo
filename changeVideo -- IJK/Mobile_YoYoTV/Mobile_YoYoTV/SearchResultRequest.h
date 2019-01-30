//
//  SearchResultRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/25.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "SearchResultModel.h"

@interface SearchResultRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(SearchResultRequest *responseData);

@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSArray *responseData;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock;


@end
