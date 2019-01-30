//
//  ExitView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/1.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ExitView.h"

@implementation ExitView

- (instancetype) init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, 84);
        self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake(0, 40, ScreenWidth, 44);
        _exitBtn.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        BOOL isLogin = userInfo;
        isLogin ? [_exitBtn setTitle:@"退出" forState:UIControlStateNormal] :[_exitBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_exitBtn];
        self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    return self;
}

@end
