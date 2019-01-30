//
//  HomeHead_title_CollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeHead_title_CollectionReusableView.h"


@implementation HomeHead_title_CollectionReusableView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //总共高42  横线6，其余36
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6)];
        bgView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        [self addSubview:bgView];
        
        self.greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 6+(36-20)/2, 3, 20)];
        _greenView.backgroundColor = UIColorFromRGB(0x0BBF06, 1.0);
        _greenView.userInteractionEnabled = YES;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6+(36-20)/2, 135, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, 6+(36-16)/2, 8, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"ArrowRight"];
        
//        self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-8-5-40, 10, 40, 20)];
//        _moreLabel.textAlignment = NSTextAlignmentRight;
//        _moreLabel.font = [UIFont systemFontOfSize:14];
//        _moreLabel.textColor = [UIColor grayColor];
//        _moreLabel.text = @"更多";
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _categoryBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
        
        [_categoryBtn addSubview:_greenView];
        [_categoryBtn addSubview:_titleLabel];
        [_categoryBtn addSubview:_arrowImageView];
        [_categoryBtn addSubview:_moreLabel];
        
        [self addSubview:_categoryBtn];
    }
    return  self;
}
@end
