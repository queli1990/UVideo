//
//  EditNavView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/4.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "EditNavView.h"

@implementation EditNavView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
        
//        CAGradientLayer *layer = [CAGradientLayer layer];
//        layer.frame = frame;
//        //颜色分配:四个一组代表一种颜色(r,g,b,a)
//        layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
//                         (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
//        //起始点
//        layer.startPoint = CGPointMake(0.15, 0.5);
//        //结束点
//        layer.endPoint = CGPointMake(0.85, 0.5);
//        [self.layer addSublayer:layer];

        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15, 20+(44-44)/2, 50, 44);
        [_backBtn setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
        CGFloat width = 22*0.8;
        CGFloat height = 36*0.8;
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake((44-height)/2, 0, (44-height)/2, 50-width);
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
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(ScreenWidth-15-50, 20+(44-40)/2, 50, 40);
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"取消" forState:UIControlStateSelected];
        [self addSubview:_editBtn];
    }
    return self;
}


@end
