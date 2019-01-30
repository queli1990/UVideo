//
//  DownloadTopTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadTopTableViewCell.h"

@implementation DownloadTopTableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DownloadTopTableViewCellIdentifier";
    DownloadTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DownloadTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.speedLabel];
        
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(125, 72));
            make.left.mas_equalTo(15);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(53);
        }];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(8);
            make.height.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(-15);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
            make.height.mas_equalTo(3);
            make.left.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(self.nameLable);
        }];
        [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.progressView.mas_bottom).offset(5);
            make.left.mas_equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(80, 16));
        }];
    }
    return self;
}

- (void)setModel:(HWDownloadModel *)model {
    if (model) {
        _model = model;
        self.nameLable.text = model.fileName;
        //    self.speedLabel.text = @"34KB/S";
        //    self.fileSizeLabel.text = @"587MB";
        [self updateViewWithModel:model];
    } else {
        self.speedLabel.text = @"已暂停";
    }
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
        _iconImgView.image = [UIImage imageNamed:@"download_defult"];
    }
    return _iconImgView;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"正在缓存";
    }
    return _titleLabel;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
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


@end
