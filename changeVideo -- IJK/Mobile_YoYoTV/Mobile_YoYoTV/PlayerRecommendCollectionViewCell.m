//
//  PlayerRecommendCollectionViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/1/16.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "PlayerRecommendCollectionViewCell.h"

@implementation PlayerRecommendCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        self.sumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-18, frame.size.width, 18)];
        imageView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x808080, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        [imageView addSubview:_titleLabel];
        [_sumImageView addSubview:imageView];
        [self.contentView addSubview:_sumImageView];
        
        self.vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _vipImgView.image = [UIImage imageNamed:@"VIP.png"];
        [self.contentView addSubview:_vipImgView];
    }
    return self;
}

- (void) setModel:(HomeModel *)model{
    _model = model;
    _titleLabel.text = model.name;
    if (model.pay) {
        self.vipImgView.hidden = NO;
    } else {
        self.vipImgView.hidden = YES;
    }
    //    self.sumImageView.image = [UIImage imageNamed:@"ArrowRight"];
    [self.sumImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait_poster_m] placeholderImage:[UIImage imageNamed:@"placeholder_107_152"]];
}

@end
