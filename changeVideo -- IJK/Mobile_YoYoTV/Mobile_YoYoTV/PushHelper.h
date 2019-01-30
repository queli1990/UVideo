//
//  PushHelper.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVTabBarController.h"

@interface PushHelper : UIViewController

- (void) pushController:(UIViewController *)newController withOldController:(UIViewController *)oldController andSetTabBarHidden:(BOOL)hidden;
- (void) popController:(UIViewController *)oldController WithNavigationController:(UINavigationController *)navigationController andSetTabBarHidden:(BOOL)hidden;

@end
