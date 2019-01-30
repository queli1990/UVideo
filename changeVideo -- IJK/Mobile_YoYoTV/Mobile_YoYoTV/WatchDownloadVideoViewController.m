//
//  WatchDownloadVideoViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/28.
//  Copyright © 2018 li que. All rights reserved.
//

#import "WatchDownloadVideoViewController.h"
#import "ZFPlayer.h"
//#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "UserActionRequest.h"

@interface WatchDownloadVideoViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFIJKPlayerManager *playerManager;
@end

@implementation WatchDownloadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
    [self setupPlayer];
}

- (void) setupPlayer {
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    playerManager.assetURL = [NSURL fileURLWithPath:self.localPath];
    
    [self.controlView showTitle:self.videoName coverURLString:@"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" fullScreenMode:ZFFullScreenModeLandscape];
    
    [self.controlView.portraitControlView fullScreenButtonClickAction:self.controlView.portraitControlView.fullScreenBtn];
    [self.controlView.landScapeControlView.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 20;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if (self.player.isFullScreen) {
//        return UIInterfaceOrientationMaskLandscape;
//    }
//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscape;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (void) goBack {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSArray *episodeArray = [self.model.vid componentsSeparatedByString:@"-"];
    int watchTime = self.player.currentTime * 1000;
    NSDictionary *playedVideoInfo = @{
                                      @"episode":[NSNumber numberWithInteger:[episodeArray[1] integerValue]],
                                      @"duration":[NSNumber numberWithDouble:watchTime],
                                      };
    NSArray *infoArray = [NSArray arrayWithObject:playedVideoInfo];
    NSArray *fileNameArray = [self.model.fileName componentsSeparatedByString:@" "];
    NSDictionary *params = @{@"deviceId":[YDDevice getUQID],
                             @"albumId":episodeArray[0],
                             @"albumName":fileNameArray[0],
                             @"playDurations":infoArray,
                             @"platform":@"ios"};
    [UserActionRequest postOfflinePlayback:params complent:^(NSDictionary * _Nonnull dic) {
        
    }];
}

@end
