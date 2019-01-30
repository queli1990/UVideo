//
//  NoResultView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "NoResultView.h"

@implementation NoResultView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-64-49-130)/2, ScreenWidth, 130)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, 0, 120, 97)];
        imgView.image = [UIImage imageNamed:@"noResult"];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+13, ScreenWidth, 20)];
        titleName.text = @"对不起，没有找到您想要的...";
        titleName.textAlignment = NSTextAlignmentCenter;
        titleName.font = [UIFont systemFontOfSize:14];
        titleName.textColor = UIColorFromRGB(0xC3C3C3, 1.0);
        
        [contentView addSubview:imgView];
        [contentView addSubview:titleName];
        [self addSubview:contentView];
    }
    return self;
}


@end
