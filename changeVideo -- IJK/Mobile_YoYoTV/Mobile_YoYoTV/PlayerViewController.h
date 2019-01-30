//
//  PlayerViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface PlayerViewController : UIViewController <GADUnifiedNativeAdLoaderDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdDelegate>

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,strong) HomeModel *model;
@property (nonatomic) BOOL isHideTabbar;

/** 页面访问时长 1000106001 */
@property (nonatomic,assign) NSNumber *enterPageTime;
@property (nonatomic,assign) NSNumber *leavePageTime;

/** 视频接口 1000106002 */
@property (nonatomic,assign) NSNumber *requestModelBeginTime;
@property (nonatomic,assign) NSNumber *requestModelEndTime;

/** vimeo请求时长 1000106005 */
@property (nonatomic,assign) NSNumber *requestVimeoBeginTime;
@property (nonatomic,assign) NSNumber *requestVimeoEndTime;

/** 第一次视频缓冲的接口 1000106006*/
@property (nonatomic,assign) BOOL isFirstBuffer;
@property (nonatomic,assign) NSNumber *firstBufferStartTime;
@property (nonatomic,assign) NSNumber *firstBufferEndTime;

/** 非第一次视频缓冲的接口 1000106007*/
@property (nonatomic,strong) NSMutableArray *buffersArray;
@property (nonatomic,assign) NSNumber *nextBufferStartTime;
@property (nonatomic,assign) NSNumber *nextBufferEndTime;



@end
