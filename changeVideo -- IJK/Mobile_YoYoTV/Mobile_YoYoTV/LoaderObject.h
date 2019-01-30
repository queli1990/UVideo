//
//  LoaderObject.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/8.
//  Copyright © 2019 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGActivityIndicatorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoaderObject : UIView

@property (nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;

- (instancetype) initWithFatherView:(UIView *)fatherView;

- (void) showLoader;

- (void) dismissLoader;

@end

NS_ASSUME_NONNULL_END
