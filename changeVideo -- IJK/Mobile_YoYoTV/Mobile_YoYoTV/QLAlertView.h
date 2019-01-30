//
//  QLAlertView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/30.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QLShowAnimationStyle) {
    kAnimationDefault = 0,
    kAnimationLeftShake,
    kAnimationTopShake,
    kAnimationNO
};

typedef void (^QLAlertClickIndexBlock)(NSInteger clickIndex);



@interface QLAlertView : UIView

@property (nonatomic,copy) QLAlertClickIndexBlock clickBlock;

@property (nonatomic,assign) QLShowAnimationStyle animationStyle;

/**
 *  初始化alert方法（根据内容自适应大小，目前只支持1个按钮或2个按钮）
 *
 *  @param title         标题
 *  @param message       内容（根据内容自适应大小）
 *  @param cancelTitle   取消按钮
 *  @param otherBtnTitle 其他按钮
 *  @param block         点击事件block
 *
 *  @return 返回alert对象
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(QLAlertClickIndexBlock)block;

/**
 *  showQLAlertView
 */
-(void)showQLAlertView;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;



@end


@interface UIImage (colorful)
//a image using a color
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
