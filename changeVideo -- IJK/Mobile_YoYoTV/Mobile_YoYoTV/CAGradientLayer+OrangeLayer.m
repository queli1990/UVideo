//
//  CAGradientLayer+OrangeLayer.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/14.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "CAGradientLayer+OrangeLayer.h"

@implementation CAGradientLayer (OrangeLayer)

- (void) addLayerWithY:(CGFloat)y andHeight:(CGFloat)height withAddedView:(UIView *)addedView{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, y, ScreenWidth, height);
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
    layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
                     (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
    //起始点
    layer.startPoint = CGPointMake(0.15, 0.5);
    //结束点
    layer.endPoint = CGPointMake(0.85, 0.5);
    [addedView.layer addSublayer:layer];
}

@end
