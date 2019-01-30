//
//  SettingTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, (50-22)/2, 22, 22)];
        [self.contentView addSubview:_iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, (50-20)/2, 120, 20)];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xF2F2F2, 1.0);
        [self.contentView addSubview:lineView];
        
        self.arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-6, (50-12)/2, 6, 12)];
        _arrowImg.image = [UIImage imageNamed:@"ArrowRight"];
        [self.contentView addSubview:_arrowImg];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-6-15-80, (50-20)/2, 80, 20)];
        _subTitleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_subTitleLabel];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = UIColorFromRGB(0xF5F5F5, 1.0);
        self.selectedBackgroundView = bgView;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
