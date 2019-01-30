//
//  HomeRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
//#import "NoCdnBaseHttpRequest.h"
#import "HomeModel.h"
#import "GenresModel.h"

@interface HomeRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(HomeRequest *responseData);

@property (nonatomic,strong) NSNumber *currentIndex;
@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSMutableArray *responseDataArray;
@property (nonatomic,strong) NSArray *responseHeadArray;
@property (nonatomic,strong) NSArray *genresArray;
@property (nonatomic,strong) NSArray *storageArray;

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *title_passed;

- (id) requestData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock;

@end
