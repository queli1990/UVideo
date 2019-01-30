//
//  AppDelegate.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/2.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "RDVTabBar.h"
#import "HomeViewController.h"
#import "HomeScrollViewController.h"
//#import "MainViewController.h"
#import "SearchViewController.h"
#import "ChannelsViewController.h"
#import "MianViewController.h"
#import "ShortVideoBarViewController.h"
#import "MyNavigationViewController.h"
#import "RDVTabBar+Extend.h"
@import GoogleMobileAds;

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import "ChatModel.h"

@interface AppDelegate ()<AppsFlyerTrackerDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];  //设置TabBar
    [self.window setRootViewController:self.viewController];
    
    [self.window makeKeyAndVisible];
    
    // AppFlyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"HZrCXHRnwbogR2pijXLCxF";
    [AppsFlyerTracker sharedTracker].appleAppID = @"1435558135";
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    //谷歌广告
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-7468136908049062~4919863732"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 一次性代码
    [self projectOnceCode];
    
    // 开启网络监听
    [[HWNetworkReachabilityManager shareManager] monitorNetworkStatus];
    
    // 开启等待下载的任务
    [[HWDownloadManager shareManager] openDownloadTask];
    
    return YES;
}

#pragma mark - Methods - tabBar
- (void)setupViewControllers {
    //第1个控制器
    UIViewController *firstViewController = [[HomeScrollViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    [firstNavigationController.navigationBar setHidden:YES];
    //第2个控制器
    ShortVideoBarViewController *secondViewController = [[ShortVideoBarViewController alloc] init];
    MyNavigationViewController *secondNavigationController = [[MyNavigationViewController alloc] initWithRootViewController:secondViewController];
//    [secondNavigationController.navigationBar setHidden:YES];
    //第3个控制器
    SearchViewController *thirdViewController = [[SearchViewController alloc] init];
    thirdViewController.isTabPage = YES;
    UINavigationController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    [thirdNavigationController.navigationBar setHidden:YES];
    //第4个控制器
    UIViewController *fourthController = [[MianViewController alloc] init];
    UINavigationController *fourthNavController = [[UINavigationController alloc] initWithRootViewController:fourthController];
    [fourthNavController.navigationBar setHidden:YES];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,thirdNavigationController,fourthNavController]];
    
    RDVTabBar *tabBar = tabBarController.tabBar;
    [self isHaveSysMsg:tabBar];
//        tabBar.backgroundView.backgroundColor = [UIColor redColor];//tabBar的整体背景颜色
    self.viewController = tabBarController;
    [self customizeTabBarForController:tabBarController];
}

- (void) isHaveSysMsg:(RDVTabBar *)tabBar {
    ChatModel *model = [ChatModel  new];
    @weakify(tabBar);
    [model hasNewMsg:^(BOOL isHave) {
        @strongify(tabBar);
        if (isHave) {
            // 设置未读标记
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kUnReadNotiCount];
            [tabBar showBadgeOnItemIndex:4];
        }
    }];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];//改变选中后的item的背景色或者图片
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third", @"fourth"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        if (index == 0) item.title = @"首页";
        if (index == 1) item.title = @"发现";
        if (index == 2) item.title = @"搜索";
        if (index == 3) item.title = @"我的";
//        [item setBackgroundSelectedImage:nil withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url options:(NSDictionary *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    // Add any custom logic here.
    
     return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 实现如下代码，才能使程序处于后台时被杀死，调用applicationWillTerminate:方法
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

// 一次性代码
- (void)projectOnceCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"HWProjectOnceKey"]) {
        // 初始化下载最大并发数为1
        [defaults setInteger:1 forKey:HWDownloadMaxConcurrentCountKey];
        // 初始化不允许蜂窝网络下载
        [defaults setBool:NO forKey:HWDownloadAllowsCellularAccessKey];
        [defaults setBool:YES forKey:@"HWProjectOnceKey"];
    }
}

// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    _backgroundSessionCompletionHandler = completionHandler;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[HWDownloadManager shareManager] updateDownloadingTaskState];
}


@end
