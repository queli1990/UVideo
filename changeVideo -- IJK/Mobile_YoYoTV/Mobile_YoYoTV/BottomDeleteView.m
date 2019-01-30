//
//  BottomDeleteView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/30.
//  Copyright © 2018 li que. All rights reserved.
//

#import "BottomDeleteView.h"

@implementation BottomDeleteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.allSelBtn];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.lineView];
        
        [self.allSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(self);
            make.width.width.mas_equalTo(ScreenWidth*0.5);
            make.top.mas_equalTo(0);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(self);
            make.width.width.mas_equalTo(ScreenWidth*0.5);
            make.top.mas_equalTo(0);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth*0.5);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(29);
            make.width.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return _lineView;
}

- (UIButton *)allSelBtn {
    if (!_allSelBtn) {
        _allSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#2f9cd4"]] forState:UIControlStateHighlighted];
        [_allSelBtn setTitleColor:[UIColor colorWithHexString:@"#2f9ad2"] forState:UIControlStateNormal];
        [_allSelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return _allSelBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#2f9cd4"]] forState:UIControlStateHighlighted];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#2f9ad2"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return _deleteBtn;
}


@end
