//
//  ShowToast.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/5.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowToast : NSObject


/**
 *  弹出框在顶部的模态视图
 */
+ (void) showToastWithString:(NSString *)title withBackgroundColor:(UIColor *)bgColor withTextFont:(int)textFontSize;

@end
