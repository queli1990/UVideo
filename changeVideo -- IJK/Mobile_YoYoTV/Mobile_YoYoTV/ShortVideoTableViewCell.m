//
//  ShortVideoTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/19.
//  Copyright © 2018 li que. All rights reserved.
//

#import "ShortVideoTableViewCell.h"

@interface ShortVideoTableViewCell()
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation ShortVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat height = ScreenWidth*9/16;
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, height, ScreenWidth, 40)];
        tempView.backgroundColor = [UIColor whiteColor];
        //眼睛icon
        self.eyeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-12)/2, 21, 12)];
        _eyeImage.image = [UIImage imageNamed:@"eye"];
        //观看数label
        self.watchCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_eyeImage.frame)+8, (40-20)/2, 80, 20)];
        _watchCountLabel.textColor = UIColorFromRGB(0x828183, 1.0);
        _watchCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _watchCountLabel.textAlignment = NSTextAlignmentLeft;
        float x = arc4random() % 95;
        float y = x / 10 + 0.1;
        _watchCountLabel.text = [NSString stringWithFormat:@"%.1f k观看",y];
        //分享button
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(ScreenWidth-20-15, (40-20)/2, 20, 20);
        [_shareBtn setImage:[UIImage imageNamed:@"shareBtnImg"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加
        [tempView addSubview:_eyeImage];
        [tempView addSubview:_watchCountLabel];
        [tempView addSubview:_shareBtn];
        //添加
        
        [self.contentView addSubview:tempView];
        //设置默认图片
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        // 设置imageView的tag，在PlayerView中取（建议设置100以上）
        self.picView.tag = 100;
        _picView.userInteractionEnabled = YES;
        [self.contentView addSubview:_picView];
        
        // 代码添加playerBtn到imageView上
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playBtn.frame = CGRectMake((_picView.frame.size.width-50)/2, (_picView.frame.size.height-50)/2, 50, 50);
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.picView);
            make.width.height.mas_equalTo(50);
        }];
    }
    return self;
}

 - (void)setModel:(ShortVideoModel *)model {
     _model = model;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
}

- (void) shareClick:(UIButton *)btn {
    if (self.shareBlock) {
        self.shareBlock(btn);
    }
}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)showMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
