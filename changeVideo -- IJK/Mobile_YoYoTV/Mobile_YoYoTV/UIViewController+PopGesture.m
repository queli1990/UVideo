//
//  UIViewController+PopGesture.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/14.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "UIViewController+PopGesture.h"

@implementation UIViewController (PopGesture)

- (void) popToLastPageWithNav:(UINavigationController *)nav {
    NSArray *targets = [nav.interactivePopGestureRecognizer valueForKey:@"targets"];
    id target = [targets.firstObject valueForKey:@"target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [self.view addGestureRecognizer:pan];
}



@end
