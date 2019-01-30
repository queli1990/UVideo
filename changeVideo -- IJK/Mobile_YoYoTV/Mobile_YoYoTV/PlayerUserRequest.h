//
//  PlayerUserRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "UserBaseRequest.h"

@interface PlayerUserRequest : UserBaseRequest

typedef void (^userResponseBlock)(PlayerUserRequest *responseData);

@property (nonatomic,strong) NSError *responseError;
//第一个请求返回的数据
@property (nonatomic,strong) NSDictionary *playHistory;
@property (nonatomic) BOOL isCollected;
@property (nonatomic,copy) NSString *status;

/**获取是否收藏和播放时长**/
- (id) requestUserVideoInfoWithID:(NSString *) ID andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock;

/**上传用户播放进度**/
- (void) postUserRecoreWithTitle:(NSString *)title albumID:(NSNumber *)ID albumImg:(NSString *)imageName currentIndex:(NSInteger )index watchedTime:(CGFloat)time pay:(BOOL)ispay;

/**取消收藏**/
- (id) cancleCollectionWithID:(NSNumber *)ID andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock;

/**收藏**/
- (id) collectionWithID:(NSNumber *)ID title:(NSString *)title image:(NSString *)img pay:(BOOL)isPay andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock;

/** 弃用 **/
/**上传播放时长**/
//- (void) postPlayTimeWithVersion:(NSString *)version albumId:(NSString *)albumId albumTitle:(NSString *)albumTitle watchTime:(int)watchTime isCollection:(NSString*)isCollection startTime:(NSString *)startTime endTime:(NSString *)endTime;
@end
