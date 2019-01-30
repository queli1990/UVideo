//
//  ShowErrorAlert.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/6.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "ShowErrorAlert.h"

@implementation ShowErrorAlert

+ (void) showErrorNumber:(NSString *)errorNum withViewController:(UIViewController *)vc finish:(finishBlock)block {
    NSString *error ;
    if ([errorNum isEqualToString:@"-101"]) {
        error = @"该手机号已注册";
    } else if ([errorNum isEqualToString:@"-108"]) {
        error = @"用户不存在";
    } else if ([errorNum isEqualToString:@"-109"]) {
        error = @"用户密码不正确";
    } else if ([errorNum isEqualToString:@"-300"]) {
        error = @"今日短信已达上限";
    } else if ([errorNum isEqualToString:@"-301"]) {
        error = @"短信发送失败";
    } else if ([errorNum isEqualToString:@"-302"]) {
        error = @"短信验证码不正确或失败";
    } else if ([errorNum isEqualToString:@"-102"]) {
        error = @"微信登录过期，请重新登录";
    } else {
        error = [NSString stringWithFormat:@"发生错误，错误代码:%@",errorNum];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:error preferredStyle:UIAlertControllerStyleAlert];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //        [alert dismissViewControllerAnimated:YES completion:nil];
    //    }]];
    [vc presentViewController:alert animated:YES completion:nil];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissViewControllerAnimated:YES completion:nil];
        block();
    });
}

+ (void) showErrorMeg:(NSString *)meg withViewController:(UIViewController *)vc finish:(finishBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:meg preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:YES completion:nil];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissViewControllerAnimated:YES completion:nil];
        block();
    });
}

+ (void) showSuccessWithMsg:(NSString *)str withViewController:(UIViewController *)vc finish:(finishBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:str preferredStyle:UIAlertControllerStyleActionSheet];
    [vc presentViewController:alert animated:YES completion:nil];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissViewControllerAnimated:YES completion:nil];
        block();
    });
}

@end
