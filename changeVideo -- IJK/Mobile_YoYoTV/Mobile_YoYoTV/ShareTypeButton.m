//
//  ShareTypeButton.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/7.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "ShareTypeButton.h"

@implementation ShareTypeButton

//文字的绘制区域
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(contentRect.origin.x, contentRect.size.height * 0.8, contentRect.size.width, contentRect.size.height * 0.2);
    return rect;
}

//图片的绘制区域
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat width ;
    if (contentRect.size.width > 40) {
        width = 40;
    } else {
        width = contentRect.size.width;
    }
//    20 = (80-40)/2
    CGRect rect = CGRectMake(20, contentRect.size.height * 0.0, width, width);
    return rect;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
