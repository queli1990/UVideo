//
//  PlayerNativeAdsView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/1.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ZFPlayer.h"


@interface PlayerNativeAdsView : UIViewController <GADUnifiedNativeAdLoaderDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdDelegate,GADAdLoaderDelegate>

- (void) showNativeAds:(UIViewController *)rootVC andContentView:(ZFPlayerView *)playerView;

@end

