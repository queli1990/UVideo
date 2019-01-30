//
//  PlayerNativeAdsView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/1.
//  Copyright © 2018 li que. All rights reserved.
//

#import "PlayerNativeAdsView.h"
#import <Masonry/Masonry.h>


static NSString *const LiveAdUnit = @"ca-app-pub-7468136908049062/2225844601";

@interface PlayerNativeAdsView()
@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@end


@implementation PlayerNativeAdsView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showNativeAds:(UIViewController *)rootVC andContentView:(ZFPlayerView *)playerView {
    NSLog(@"开始设置广告");
    self.playerView = playerView;
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:LiveAdUnit
                                       rootViewController:self
                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                  options:@[  ]];
    self.adLoader.delegate = self;
    
    [self.adLoader loadRequest:[GADRequest request]];
}


#pragma mark GADUnifiedNativeAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
//需要暂停
    //    [_playerView pause];
    NSLog(@"aaaaaaaaaaaa");
    if (!self.nativeAdView) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
        self.nativeAdView = [nibObjects firstObject];
        //        self.nativeAdView = [[PlayerNativeAdsView alloc] initWithFrame:self.playerView.frame];
        [self.playerView addSubview:_nativeAdView];
        
        UILabel *timerLabel = [[UILabel alloc] init];
        timerLabel.layer.cornerRadius = 10;
        timerLabel.backgroundColor = [UIColor grayColor];
        timerLabel.textColor = [UIColor greenColor];
        timerLabel.textAlignment = NSTextAlignmentCenter;
        timerLabel.font = [UIFont systemFontOfSize:13];
        __block int _timeout = 5;
        
        // GCD定时器
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(_timeout <= 0 ){// 倒计时结束
                // 关闭定时器
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    _nativeAdView.hidden = YES;
                    //需要暂停
//                    [_playerView play];
                });
            }else{// 倒计时中
                // 显示倒计时结果
                NSString *strTime = [NSString stringWithFormat:@"%d", _timeout];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    timerLabel.text = [NSString stringWithFormat:@"%@",strTime];
                });
                _timeout--;
            }
        });
        // 开启定时器
        dispatch_resume(_timer);
        [_nativeAdView addSubview:timerLabel];
        [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.equalTo(_nativeAdView.mas_right).offset(0);
            make.width.height.mas_equalTo(20);
        }];
    } else {
        _nativeAdView.hidden = NO;
    }
    NSLog(@"_nativeAdView-----%@",_nativeAdView);
    GADUnifiedNativeAdView *nativeAdView = self.nativeAdView;
    
    // Deactivate the height constraint that was set when the previous video ad loaded.
    
    nativeAdView.nativeAd = nativeAd;
    
    // Set ourselves as the ad delegate to be notified of native ad events.
    nativeAd.delegate = self;
    
    // Populate the native ad view with the native ad assets.
    // Some assets are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline; /// Google
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body; /// Congratulations! You have successfully implemented Rewarded Video!
    [((UIButton *)nativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                                forState:UIControlStateNormal]; /// INSTALL
    
    // Some native ads will include a video asset, while others do not. Apps can
    // use the GADVideoController's hasVideoContent property to determine if one
    // is present, and adjust their UI accordingly.
    if (nativeAd.videoController.hasVideoContent) {
        // This app uses a fixed width for the GADMediaView and changes its height
        // to match the aspect ratio of the video it displays.
        if (nativeAd.videoController.aspectRatio > 0) {
            NSLog(@"有视频");
        }
        
        // By acting as the delegate to the GADVideoController, this ViewController
        // receives messages about events in the video lifecycle.
        nativeAd.videoController.delegate = self;
        
        NSLog(@"Ad contains a video asset.");
    } else {
        NSLog(@"Ad does not contain a video .");
    }
    
    // These assets are not guaranteed to be present, and should be checked first.
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    if (nativeAd.icon != nil) {
        nativeAdView.iconView.hidden = NO;
    } else {
        nativeAdView.iconView.hidden = YES;
    }
    
    ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating]; /// 4
    if (nativeAd.starRating) {
        nativeAdView.starRatingView.hidden = NO;
    } else {
        nativeAdView.starRatingView.hidden = YES;
    }
    
    ((UILabel *)nativeAdView.storeView).text = nativeAd.store; /// App Store
    if (nativeAd.store) {
        nativeAdView.storeView.hidden = NO;
    } else {
        nativeAdView.storeView.hidden = YES;
    }
    
    ((UILabel *)nativeAdView.priceView).text = nativeAd.price; /// FREE
    if (nativeAd.price) {
        nativeAdView.priceView.hidden = NO;
    } else {
        nativeAdView.priceView.hidden = YES;
    }
    
    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    if (nativeAd.advertiser) {
        nativeAdView.advertiserView.hidden = NO;
    } else {
        nativeAdView.advertiserView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;
}

#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"Video playback has ended.");
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
    double starRating = numberOfStars.doubleValue;
    if (starRating >= 5) {
        return [UIImage imageNamed:@"stars_5"];
    } else if (starRating >= 4.5) {
        return [UIImage imageNamed:@"stars_4_5"];
    } else if (starRating >= 4) {
        return [UIImage imageNamed:@"stars_4"];
    } else if (starRating >= 3.5) {
        return [UIImage imageNamed:@"stars_3_5"];
    } else {
        return nil;
    }
}


@end
