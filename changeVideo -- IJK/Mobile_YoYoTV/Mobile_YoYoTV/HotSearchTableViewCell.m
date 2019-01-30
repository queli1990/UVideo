//
//  HotSearchTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/23.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HotSearchTableViewCell.h"

@implementation HotSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.indexLable = [[UILabel alloc] initWithFrame:CGRectMake(15, (40-22)/2, 22, 22)];
        _indexLable.textColor = [UIColor whiteColor];
        _indexLable.font = [UIFont systemFontOfSize:15];
        _indexLable.backgroundColor = UIColorFromRGB(0xE1E1E1, 1.0);
        _indexLable.textAlignment = NSTextAlignmentCenter;
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_indexLable.frame)+10, _indexLable.frame.origin.y, ScreenWidth-15-22-10-15, 22)];
        _nameLable.font = [UIFont systemFontOfSize:15];
        _nameLable.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _nameLable.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_indexLable];
        [self.contentView addSubview:_nameLable];
    }
    return self;
}

- (void) setModel:(HomeModel *)model {
    _model = model;
    _nameLable.text = model.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
