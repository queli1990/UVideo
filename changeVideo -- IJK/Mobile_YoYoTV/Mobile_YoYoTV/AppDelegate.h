//
//  AppDelegate.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/2.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIViewController *viewController;

@property (nonatomic, copy) void (^ backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调


@end

