//
//  UIButton+BottomLineButton.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/21.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "UIButton+BottomLineButton.h"

static const char *kLineProperty = "line";

@implementation UIButton (BottomLineButton)

- (UIButton *) addLineWithButton:(UIButton *)orignalBtn {
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(8, orignalBtn.frame.size.height-2, orignalBtn.frame.size.width-16, 2)];
    self.line.backgroundColor = UIColorFromRGB(0x0BBF06, 1.0);
    [orignalBtn addSubview:self.line];
    return orignalBtn;
}

- (UILabel *) line {
    return objc_getAssociatedObject(self, kLineProperty);
}

- (void) setLine:(UILabel *)line {
    objc_setAssociatedObject(self, kLineProperty, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
