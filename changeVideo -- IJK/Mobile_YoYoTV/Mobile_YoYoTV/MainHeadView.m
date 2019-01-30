//
//  MainHeadView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "MainHeadView.h"

@interface MainHeadView()
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation MainHeadView

- (void) setupViewByIslogin:(BOOL)isLogin {
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 165)];
    _bgImageView.image = [UIImage imageNamed:@"bgLogin"];
    [self addSubview:_bgImageView];
    self.headImgView = [[UIImageView alloc] init];
    _headImgView.frame = CGRectMake((ScreenWidth-64)/2, 32, 64, 64);
    [_bgImageView addSubview:_headImgView];
    [self addSubview:_bgImageView];
    isLogin ? [self loginView] : [self notLoginView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 165, ScreenWidth, 3)];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2, 1.0);
    [self addSubview:line];
}

- (void) loginView {
    _headImgView.image = [UIImage imageNamed:@"hasLogin"];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, ScreenWidth, 21)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    _titleLabel.text = userInfo[@"userName"];
    [_bgImageView addSubview:_titleLabel];
    
}

- (void) notLoginView {
    _headImgView.image = [UIImage imageNamed:@"notLogin"];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, ScreenWidth, 21)];
    _titleLabel.text = @"点击登录/注册";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _titleLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    [_bgImageView addSubview:_titleLabel];
    
    self.vipTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+4, ScreenWidth, 16)];
    _vipTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    _vipTimeLabel.textAlignment = NSTextAlignmentCenter;
    _vipTimeLabel.text = @"登录可同步收藏 / 播放记录";
    _vipTimeLabel.textColor = UIColorFromRGB(0x000000, 1.0);
    [_bgImageView addSubview:_vipTimeLabel];
}

@end
