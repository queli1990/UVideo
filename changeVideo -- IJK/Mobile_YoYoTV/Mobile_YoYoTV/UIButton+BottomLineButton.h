//
//  UIButton+BottomLineButton.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/21.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BottomLineButton)

@property (nonatomic,strong) UILabel *line;
- (UIButton *) addLineWithButton:(UIButton *)orignalBtn;

@end
