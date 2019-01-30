//
//  PerDownloadTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import "PerDownloadTableViewCell.h"

@implementation PerDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PerDownloadTableViewCellIdentifier";
    PerDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PerDownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.stateImgView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(52);
            make.top.mas_equalTo(14);
        }];
        [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.top.mas_equalTo(5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(21);
        }];
    }
    return self;
}

- (void) updateViewWithModel:(HWDownloadModel *)model {
    self.model = model;
}

- (void)setModel:(HWDownloadModel *)model {
    _titleLabel.text = model.fileName;
    _model = model;
    
    switch (_model.state) {
        case HWDownloadStateDownloading:
            _stateImgView.hidden = NO;
            _stateImgView.image = [UIImage imageNamed:@"com_download_ing"];
            break;
        case HWDownloadStateFinish:
            _stateImgView.hidden = NO;
            _stateImgView.image = [UIImage imageNamed:@"downloadFinishIcon"];
            break;
        case HWDownloadStateWaiting:
            _stateImgView.hidden = NO;
            _stateImgView.image = [UIImage imageNamed:@"com_download_waiting"];
            break;
        case HWDownloadStateError:
            _stateImgView.hidden = NO;
            _stateImgView.image = [UIImage imageNamed:@"com_download_error"];
        default:
//            _stateImgView.hidden = YES;
            break;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    }
    return _bgView;
}

- (UIImageView *)stateImgView {
    if (!_stateImgView) {
        _stateImgView = [[UIImageView alloc] init];
    }
    return _stateImgView;
}



@end
