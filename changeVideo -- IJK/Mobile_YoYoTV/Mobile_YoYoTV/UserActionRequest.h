//
//  UserActionRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/13.
//  Copyright © 2018 li que. All rights reserved.
//

#import "PostBaseHttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserActionRequest : PostBaseHttpRequest

/** 发送用户信息 */
+ (void) postOnceUserDevice;

/**  详情页 */
+ (void) postDetailPageEvent:(NSDictionary *)params;

+ (void) postDetailPageEventCode:(NSString *)eventCode successCode:(NSNumber *)sucCode beginTime:(NSNumber *)beginTime endTime:(NSNumber *)endTime episode:(NSNumber *)episode albumId:(NSNumber *)albumId albumName:(NSString *)albumName;

/** 发送观看影片时长 */
+ (void) postVideoInfo:(NSDictionary *)params;

/** 点下了某一集的下载按钮 */
+ (void) postDownload:(NSDictionary *)params complent:(void(^)(NSDictionary *dic))complent;

/** 上传用户播放本地缓存视频 **/
+ (void) postOfflinePlayback:(NSDictionary *)params complent:(void(^)(NSDictionary *dic))complent;


@end

NS_ASSUME_NONNULL_END
