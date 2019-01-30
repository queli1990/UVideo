//
//  LoaderObject.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/8.
//  Copyright © 2019 li que. All rights reserved.
//

#import "LoaderObject.h"

@interface LoaderObject()

@end

const CGFloat width  = 50.0;
const CGFloat height = 50.0;

@implementation LoaderObject

- (instancetype) initWithFatherView:(UIView *)fatherView {
    [fatherView addSubview:self.activityIndicatorView];
    UIView *keyView = [[UIApplication sharedApplication]keyWindow];
    self.activityIndicatorView.center = keyView.center;
    return self;
}

- (void) showLoader {
    [self.activityIndicatorView startAnimating];
}

- (void) dismissLoader {
    [self.activityIndicatorView stopAnimating];
}

- (DGActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor] size:50.0f];
        _activityIndicatorView.frame = CGRectMake((ScreenWidth-width)*0.5, (ScreenHeight-height)*0.5, width, height);
    }
    return _activityIndicatorView;
}

@end
