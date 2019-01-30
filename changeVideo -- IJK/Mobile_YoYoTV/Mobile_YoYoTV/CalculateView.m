//
//  CalculateView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/12.
//  Copyright © 2018 li que. All rights reserved.
//

#import "CalculateView.h"

@implementation CalculateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 22));
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(0);
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 17));
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.topLabel.mas_bottom).offset(3);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    }
    return _lineView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _topLabel.textColor = UIColorFromRGB(0x828183, 1.0);
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _leftLabel.textColor = UIColorFromRGB(0x828183, 1.0);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}


@end
