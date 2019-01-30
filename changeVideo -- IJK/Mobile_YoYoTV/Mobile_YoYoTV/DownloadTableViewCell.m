//
//  DownloadTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/26.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DownloadTableViewCellIdentifier";
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.speedLabel];
        [self.contentView addSubview:self.fileSizeLabel];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(125, 72));
            make.left.mas_equalTo(15);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(10);
            make.height.mas_equalTo(18);
            make.right.mas_equalTo(-15);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
            make.height.mas_equalTo(3);
            make.left.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(self.titleLabel);
        }];
        [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.progressView.mas_bottom).offset(5);
            make.left.mas_equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(90, 16));
        }];
        [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110, 16));
            make.top.mas_equalTo(self.speedLabel);
            make.right.mas_equalTo(self.progressView);
        }];
    }
    return self;
}

- (void)setModel:(HWDownloadModel *)model {
    _model = model;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
    
    self.titleLabel.text = model.fileName;
//    self.speedLabel.text = @"34KB/S";
//    self.fileSizeLabel.text = @"587MB";
    [self updateViewWithModel:model];
}


// 更新视图
- (void)updateViewWithModel:(HWDownloadModel *)model
{
    _progressView.progress = model.progress;
    
    [self reloadLabelWithModel:model];
}

// 刷新标签
- (void)reloadLabelWithModel:(HWDownloadModel *)model
{
    NSString *totalSize = [HWToolBox stringFromByteCount:model.totalFileSize];
    NSString *tmpSize = [HWToolBox stringFromByteCount:model.tmpFileSize];
    
    if (model.state == HWDownloadStateFinish) {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@", totalSize];
        
    }else {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@ / %@", tmpSize, totalSize];
    }
    _fileSizeLabel.hidden = model.totalFileSize == 0;
    
    if (model.state == HWDownloadStatePaused) {
        _speedLabel.text = @"已暂停";
        _speedLabel.textColor = UIColorFromRGB(0x0BBF06, 1.0);
    } else if (model.state == HWDownloadStateError) {
        _speedLabel.text = @"下载出错，请重试";
        _speedLabel.textColor = UIColorFromRGB(0xFF561E, 1.0);
    } else if (model.state == HWDownloadStateWaiting) {
        _speedLabel.text = @"等待缓存";
        _speedLabel.textColor = UIColorFromRGB(0x808080, 1.0);
    } else if (model.speed > 0) {
        _speedLabel.text = [NSString stringWithFormat:@"%@ / s", [HWToolBox stringFromByteCount:model.speed]];
        _speedLabel.textColor = UIColorFromRGB(0x0BBF06, 1.0);
    }
//    _speedLabel.hidden = !(model.state == HWDownloadStateDownloading && model.totalFileSize > 0);
}



- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        //设置进度条颜色
        _progressView.trackTintColor = UIColorFromRGB(0xC2C2C2, 1.0);
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _progressView.progress=0.7;
        //设置进度条上进度的颜色
        _progressView.progressTintColor = UIColorFromRGB(0x0BBF06, 1.0);
        //由于pro的高度不变 使用放大的原理让其改变
//        _progressView.transform = CGAffineTransformMakeScale(1.0f, 10.0f);
        //自己设置的一个值 和进度条作比较 其实为了实现动画进度
//        _progressView.progress= 0.7;
    }
    return _progressView;
}

- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    }
    return _speedLabel;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
        _fileSizeLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
        _fileSizeLabel.textAlignment = NSTextAlignmentRight;
        _fileSizeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    }
    return _fileSizeLabel;
}


@end
