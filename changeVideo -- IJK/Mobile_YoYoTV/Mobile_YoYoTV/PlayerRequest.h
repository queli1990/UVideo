//
//  PlayerRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/25.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
#import "PlayerModel.h"
#import "HomeModel.h"

@interface PlayerRequest : GetBaseHttpRequest

typedef void (^httpResponseBlock)(PlayerRequest *responseData);
typedef void (^vimeoResponseBlock)(PlayerRequest *responseData);

@property (nonatomic,copy) NSString *regexName;

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *genre_id;
@property (nonatomic,copy) NSString *vimeo_id;
@property (nonatomic,copy) NSString *vimeo_token;
@property (nonatomic, strong) NSNumber *totalEpisode;
@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSArray *responseData;
@property (nonatomic,strong) NSArray *playUrlArray;

@property (nonatomic,strong) NSArray *vimeo_responseDataArray;
@property (nonatomic,strong) NSDictionary *vimeo_responseDataDic;
@property (nonatomic,strong) NSArray *vimeo_responseError;

/**请求相关推荐接口**/
- (id) requestRelatedData:(NSDictionary *)params andBlock:(httpResponseBlock)block andFailureBlock:(httpResponseBlock)failureBlock;

/**请求vimeo接口**/
- (void) requestVimeoPlayurl:(vimeoResponseBlock)block andFailureBlock:(vimeoResponseBlock)failureBlock;

@end
