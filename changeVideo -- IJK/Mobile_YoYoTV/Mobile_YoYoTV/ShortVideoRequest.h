//
//  ShortVideoRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortVideoGenreModel.h"
#import "GetBaseHttpRequest.h"
#import "ShortVideoModel.h"


@interface ShortVideoRequest : GetBaseHttpRequest

typedef void(^ShortVideoRequestBlock)(ShortVideoRequest *responseData);

@property (nonatomic,strong) NSError *responseError;
@property (nonatomic,strong) NSArray *responseData;
@property (nonatomic,assign) NSNumber *totalCount;

/**短视频页面，请求顶部导航分类**/
- (id) requestData:(NSDictionary *)params SuccessBlock:(ShortVideoRequestBlock)block failureBlcok:(ShortVideoRequestBlock)failureBlock;

/**请求vimeo的短视频接口**/
- (id) requestVimeo:(NSDictionary *)params SuccessBlock:(ShortVideoRequestBlock)block failureBlock:(ShortVideoRequestBlock)failureBlock;

@end


