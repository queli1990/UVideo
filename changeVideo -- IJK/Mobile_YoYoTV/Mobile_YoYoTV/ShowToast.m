//
//  ShowToast.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/5.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ShowToast.h"

@implementation ShowToast

+ (void) showToastWithString:(NSString *)title withBackgroundColor:(UIColor *)bgColor withTextFont:(int)textFontSize{
    NSDictionary *options = @{
                              kCRToastTextKey:title,
                              kCRToastTextAlignmentKey:@(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey:bgColor,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey:@(CRToastAnimationTypeLinear),
                              kCRToastAnimationInTypeKey:@(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutTypeKey:@(CRToastAnimationDirectionRight),
                              kCRToastAnimationInDirectionKey:@(0),
                              kCRToastTimeIntervalKey:@(2.0),
                              kCRToastNotificationTypeKey:@(CRToastTypeNavigationBar),
                              kCRToastFontKey:[UIFont systemFontOfSize:textFontSize]
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:^{
        NSLog(@"Completed");
    }];
}

@end
