//
//  PlayerUserRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerUserRequest.h"
#import "NSString+encrypto.h"

#define doObtainHistoryOrCollect @"/doObtainHistoryOrCollect.do"
#define doSaveHistory @"/doSaveHistory.do"
#define doCancelCollection @"/doCancelCollection.do"
#define doSaveCollection @"/doSaveCollection.do"
#define doVideoStatistics @"/doVideoStatistics.do"


@interface PlayerUserRequest()
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *platform;
@property (nonatomic,copy) NSString *channel;
@property (nonatomic,copy) NSString *language;
@end

@implementation PlayerUserRequest

/**
 参数：影片名称，视频ID，图片url，当前的index，已经播放的时长，是否支付
 返回：status，0、服务端异常 1、用户token失效 2、保存成功 3、保存失败
 **/
- (void) postUserRecoreWithTitle:(NSString *)title albumID:(NSNumber *)ID albumImg:(NSString *)imageName currentIndex:(NSInteger )index watchedTime:(CGFloat)time pay:(BOOL)ispay{
    [self setDefaultValue];
    NSString *token = self.token;
    NSString *albumId = [NSString stringWithFormat:@"%@",ID];
    NSString *albumTitle = title;
    NSString *albumImg = imageName;
    NSString *episodes = [NSString stringWithFormat:@"%ld",index];
    NSString *playbackProgress = [NSString stringWithFormat:@"%f",time];
    NSString *pay = [NSString stringWithFormat:@"%i",ispay];
    NSString *combineStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",token,albumId,albumTitle,albumImg,episodes,playbackProgress,pay,_platform,_channel,_language];
    NSString *md5Str = [combineStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:albumId forKey:@"albumId"];
    [params setObject:albumTitle forKey:@"albumTitle"];
    [params setObject:albumImg forKey:@"albumImg"];
    [params setObject:episodes forKey:@"episodes"];
    [params setObject:playbackProgress forKey:@"playbackProgress"];
    [params setObject:pay forKey:@"pay"];
    [params setObject:_platform forKey:@"platform"];
    [params setObject:_channel forKey:@"channel"];
    [params setObject:_language forKey:@"language"];
    [params setObject:md5Str forKey:@"sign"];
    [self getUserRequest:params andTransactionSuffix:doSaveHistory andBlock:^(UserBaseRequest *responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"2"]) {
            NSLog(@"上传播放历史成功");
        }
        if ([status isEqualToString:@"1"]) {
            NSLog(@"token失效，请重新登录");
        }
    } andFailure:^(UserBaseRequest *responseData) {
        NSLog(@"上传播放历史失败");
    }];
}


/**
 上传用户播放进度
 参数：ID
 返回：用户是否收藏和播放时长
 **/
- (id) requestUserVideoInfoWithID:(NSString *) ID andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock {
    [self setDefaultValue];//设置默认值
    NSString *token = self.token;
    NSString *albumId = [NSString stringWithFormat:@"%@",ID];
    NSString *combineStr = [NSString stringWithFormat:@"%@%@%@%@%@",token,albumId,_platform,_channel,_language];
    NSString *md5Str = [combineStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:albumId forKey:@"albumId"];
    [params setObject:_platform forKey:@"platform"];
    [params setObject:_channel forKey:@"channel"];
    [params setObject:_language forKey:@"language"];
    [params setObject:md5Str forKey:@"sign"];
    
    [self getUserRequest:params andTransactionSuffix:doObtainHistoryOrCollect andBlock:^(UserBaseRequest *responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        self.isCollected = [dic[@"isCollect"] boolValue];
        self.playHistory = dic[@"playHistory"];
        block(self);
    } andFailure:^(UserBaseRequest *responseData) {
        _responseError = responseData.error;
        failureBlock(self);
    }];
    return self;
}

//取消收藏
- (id) cancleCollectionWithID:(NSNumber *)ID andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock {
    [self setDefaultValue];
    NSString *albumId = [NSString stringWithFormat:@"%@",ID];
    NSString *combinStr = [NSString stringWithFormat:@"%@%@%@%@%@",_token,albumId,_platform,_channel,_language];
    NSString *mdStr = [combinStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_token forKey:@"token"];
    [params setObject:albumId forKey:@"albumId"];
    [params setObject:_platform forKey:@"platform"];
    [params setObject:_channel forKey:@"channel"];
    [params setObject:_language forKey:@"language"];
    [params setObject:mdStr forKey:@"sign"];
    
    [self getUserRequest:params andTransactionSuffix:doCancelCollection andBlock:^(UserBaseRequest *responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        self.status = dic[@"status"];
        block(self);
    } andFailure:^(UserBaseRequest *responseData) {
        _responseError = responseData.error;
        failureBlock(self);
    }];
    return self;
}

//收藏
- (id) collectionWithID:(NSNumber *)ID title:(NSString *)title image:(NSString *)img pay:(BOOL)isPay andBlock:(userResponseBlock)block andFilureBlock:(userResponseBlock)failureBlock {
    [self setDefaultValue];
    NSString *albumId = [NSString stringWithFormat:@"%@",ID];
    NSString *pay = [NSString stringWithFormat:@"%i",isPay];
    NSString *combineStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_token,albumId,title,img,pay,_platform,_channel,_language];
    NSString *md5Str = [combineStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_token forKey:@"token"];
    [params setObject:albumId forKey:@"albumId"];
    [params setObject:title forKey:@"albumTitle"];
    [params setObject:img forKey:@"albumImg"];
    [params setObject:pay forKey:@"pay"];
    [params setObject:_platform forKey:@"platform"];
    [params setObject:_channel forKey:@"channel"];
    [params setObject:_language forKey:@"language"];
    [params setObject:md5Str forKey:@"sign"];
    
    [self getUserRequest:params andTransactionSuffix:doSaveCollection andBlock:^(UserBaseRequest *responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        self.status = dic[@"status"];
        block(self);
    } andFailure:^(UserBaseRequest *responseData) {
        _responseError = responseData.error;
        failureBlock(self);
    }];
    return self;
}

//设置默认值
- (void) setDefaultValue {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    self.token = userInfo[@"token"];
    self.platform = @"mobile-ios";
    self.channel = @"uu100";
    self.language = @"cn";
}




@end
