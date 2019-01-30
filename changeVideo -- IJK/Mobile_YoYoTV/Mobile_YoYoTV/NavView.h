//
//  NavView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *rightBtn;

- (void) addRightBtn;

@end
