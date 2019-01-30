//
//  LoginNav.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "LoginNav.h"

@implementation LoginNav

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15, 20+(44-20)/2, 20, 20);
        [_backBtn setImage:[UIImage imageNamed:@"login_back.png"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, 20+(44-20)/2, 200, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        //[self addSubview:lineView];
    }
    return self;
}

- (void) addRightBtn {
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(ScreenWidth-15-50, (44-40)/2, 50, 40);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:_rightBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
