//
//  DownloadFinishTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadFinishTableViewCell.h"

@implementation DownloadFinishTableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DownloadFinishTableViewCellIdentifier";
    DownloadFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DownloadFinishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.sizeLabel];
        [self.contentView addSubview:self.bottomLine];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(125, 72));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.iconImageView);
            make.height.mas_equalTo(40);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.bottom.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(96, 17));
        }];
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.countLabel);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(60, 17));
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 1));
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-1);
        }];
    }
    return self;
}

// 管理所有的下载完成的页面
- (void) setModel:(HWDownloadModel *)model {
    _model = model;
    
    NSString *totalSize = [HWToolBox stringFromByteCount:model.totalFileSize];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
    _titleLabel.text = model.fileName;
    _sizeLabel.text = [NSString stringWithFormat:@"%@", totalSize];
}

- (void)setModelDic:(NSDictionary *)modelDic {
    _modelDic = modelDic;
        
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:modelDic[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
    
//    _titleLabel.text = @"我是标题";
    _titleLabel.text = modelDic[@"fileName"];
    _countLabel.text = [NSString stringWithFormat:@"%@个视频",modelDic[@"finishCount"]];
//    _sizeLabel.text = @"1.8GB";
    _sizeLabel.text = modelDic[@"totalFileSize"];
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _countLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _sizeLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
        _sizeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sizeLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xEBEBEB, 1.0);
    }
    return _bottomLine;
}

@end
