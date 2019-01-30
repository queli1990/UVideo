//
//  ChannelsCollectionViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ChannelsCollectionViewCell.h"

@implementation ChannelsCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.sumimageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-35)/2.0, (frame.size.height-35-10-20)/2.0, 35, 35)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sumimageView.frame)+10, frame.size.width, 20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        
        [self.contentView addSubview:_sumimageView];
        [self.contentView addSubview:_titleLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(GenresModel *)model {
    _model = model;
    NSURL *imgURL = [NSURL URLWithString:model.image_focus];
    [_sumimageView sd_setImageWithURL:imgURL];
    
    self.titleLabel.text = model.name;
}

@end
