//
//  XJALertView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import "XJALertView.h"

@interface XJALertView ()
@property (nonatomic, strong) UIView *btnBack;
@property (nonatomic, strong) NSArray *storageArray;
@property (nonatomic,assign) CGFloat totalHeight;
@end


@implementation XJALertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addElement];
    }
    return self;
}

- (void)addElement {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.3;
    
    _btnBack = [[UIView alloc]init];
    _btnBack.backgroundColor = [UIColor whiteColor];
}

- (void) setupArrayView:(NSArray *)array {
    if (self.storageArray.count > 0) return;
    self.storageArray = array;
    // 去除hls的源
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:array];
    for (int i = 0; i < tempArray.count; i++) {
        if ([[tempArray[i] objectForKey:@"quality"] isEqualToString:@"hls"]) {
            [tempArray removeObject:tempArray[i]];
        }
    }
    // 布局button
    CGFloat totalHeight = tempArray.count * 52 + 6 + 52;
    _totalHeight = totalHeight;
    for (NSInteger i = 0; i < tempArray.count; i++) {
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contentBtn.frame = CGRectMake(0, 52*i, ScreenWidth, 52);
        [contentBtn setTitle:[NSString stringWithFormat:@"%@",[tempArray[i] objectForKey:@"height"]] forState:UIControlStateNormal];
        contentBtn.tag = 1000 + i;
        [contentBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (_currentIndex == i) {
            [contentBtn setTitleColor:UIColorFromRGB(0x0BBF06, 1.0) forState:UIControlStateNormal];
        } else {
            [contentBtn setTitleColor:UIColorFromRGB(0x4A4A4A, 1.0) forState:UIControlStateNormal];
        }
        [_btnBack addSubview:contentBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 51*i, ScreenWidth-30, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
        [_btnBack addSubview:lineView];
    }
    
    UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-52-6, ScreenWidth, 6)];
    garyView.backgroundColor = UIColorFromRGB(0xF4F4F4, 1.0);
    [_btnBack addSubview:garyView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, totalHeight-52, ScreenWidth, 52);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addSubview:cancleBtn];
}

- (void)showAlert {
    if (_currentIndex) {
        for (id obj in _btnBack.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                if (btn.tag == _currentIndex) {
                    [btn setTitleColor:UIColorFromRGB(0x0BBF06, 1.0) forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:UIColorFromRGB(0x4A4A4A, 1.0) forState:UIControlStateNormal];
                }
            }
        }
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [window addSubview:_btnBack];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(_totalHeight);
    }];
    
    self.btnBack.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBack.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
    
}

- (void)dismissAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBack.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
        self.btnBack.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.btnBack removeFromSuperview];
    }];
}

- (void) click:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(selectedBtn:)]) {
        [self.delegate selectedBtn:btn];
    }
}



@end
