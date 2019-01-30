//
//  ShowErrorAlert.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/6.
//  Copyright © 2018年 li que. All rights reserved.
//

/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

#import <Foundation/Foundation.h>

@interface ShowErrorAlert : NSObject

typedef void(^finishBlock)();

/**
 *  系统的alert模态出的弹出框
 */
+ (void) showErrorNumber:(NSString *)errorNum withViewController:(UIViewController *)vc finish:(finishBlock)block;

/**
 *  系统的alert模态出的弹出框
 */
+ (void) showErrorMeg:(NSString *)meg withViewController:(UIViewController *)vc finish:(finishBlock)block;

/**
 *  系统的alert模态出的弹出框
 */
+ (void) showSuccessWithMsg:(NSString *)str withViewController:(UIViewController *)vc finish:(finishBlock)block;





@end
