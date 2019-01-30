//
//  MainHeadView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeadView : UIView

@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *vipTimeLabel;

- (void) setupViewByIslogin:(BOOL)isLogin;

@end
