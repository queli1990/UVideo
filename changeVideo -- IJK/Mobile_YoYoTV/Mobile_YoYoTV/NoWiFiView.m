//
//  NoWiFiView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/10.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "NoWiFiView.h"

@implementation NoWiFiView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContentViewWithContentHeight:frame.size.height];
    }
    return self;
}

// 设置view的总高度
- (void) setContentViewWithContentHeight:(CGFloat)contentHeight {
    // 3个控件总共高190
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-96)/2, (contentHeight-190)/2, 96, 84)];
    imgView.image = [UIImage imageNamed:@"NOWiFi"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+18, ScreenWidth, 20)];
    titleLabel.text = @"网络链接失败，请您刷新重试";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabel.textColor = UIColorFromRGB(0x808080, 1.0);
    
    self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reloadBtn.frame = CGRectMake((ScreenWidth-98)/2, CGRectGetMaxY(titleLabel.frame)+32, 98, 36);
    [_reloadBtn setBackgroundColor:UIColorFromRGB(0x0BBF06, 1.0)];
    [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [_reloadBtn setTintColor:UIColorFromRGB(0xFFFFFF, 1.0)];
    
    [self addSubview:imgView];
    [self addSubview:titleLabel];
    [self addSubview:_reloadBtn];
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
