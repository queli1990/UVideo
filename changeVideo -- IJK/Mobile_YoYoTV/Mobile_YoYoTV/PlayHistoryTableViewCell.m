//
//  PlayHistoryTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayHistoryTableViewCell.h"

@implementation PlayHistoryTableViewCell

//自定义对勾的图片
- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (!self.editing) return;
    [super setSelected:selected animated:animated];
    if (self.isEditing && self.isSelected) {
        //这里定义了cell就改变自定义控件的颜色
        self.textLabel.backgroundColor = [UIColor clearColor];
        UIControl *control = [self.subviews lastObject];
        UIImageView * imgView = [[control subviews] objectAtIndex:0];
        imgView.image = [UIImage imageNamed:@"Main-selected"];
    }
    if (self.editing) {
        //去掉默认的选中背景色
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *backGroundView = [[UIView alloc] init];
        backGroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = backGroundView;
        
        self.timeLabel.backgroundColor = [UIColor clearColor];//去掉label的默认蓝色
        self.titleLabel.backgroundColor = [UIColor clearColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    return;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //height = 90
        CGFloat horGap = 16.0;//水平间隙
        CGFloat verGap = 6.0;//竖直间隙
        CGFloat leftGap = 15.0;//默认的最左端的间距
        CGFloat totalHeight = 90.0;//总高
        
        self.sumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, (totalHeight-72)/2, 125, 72)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sumImageView.frame)+horGap, (totalHeight-18*2-verGap)/2, ScreenWidth-CGRectGetMaxX(_sumImageView.frame)-horGap-leftGap, 18)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+verGap, _titleLabel.frame.size.width, 18)];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _timeLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
//        self.vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _vipImgView.image = [UIImage imageNamed:@"VIP"];
//        [_sumImageView addSubview:_vipImgView];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(leftGap, 89, ScreenWidth-2*leftGap, 1)];
        line.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
        
        [self.contentView addSubview:_sumImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setModel:(PlayHistoryModel *)model {
    _model = model;
    _titleLabel.text = model.albumTitle;
    _timeLabel.text = [NSString stringWithFormat:@"%@ 观看",model.watchTime];
    if (model.pay) {
        self.vipImgView.hidden = NO;
    } else {
        self.vipImgView.hidden = YES;
    }
    [self.sumImageView sd_setImageWithURL:[NSURL URLWithString:model.albumImg] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
