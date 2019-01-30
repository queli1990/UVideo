//
//  SearchHistory.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SearchHistory.h"

@implementation SearchHistory

- (void) addHistoryView:(NSArray *)historyArray {
    //historyArray = @[@"人名的名义",@"西游记",@"三国娅奴伊",@"战国记",@"神魔志",@"1223",@"ssss",@"dddd"];
    
    UIView *historyHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, (36-18)/2, 106, 18)];
    label1.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    label1.text = @"历史搜索";
    label1.font = [UIFont systemFontOfSize:13];
    self.clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearHistoryBtn.frame = CGRectMake(ScreenWidth-15-14, (36-14)/2, 14, 14);
    [_clearHistoryBtn setImage:[UIImage imageNamed:@"deleteHistory"] forState:UIControlStateNormal];
    [historyHeadView addSubview:label1];
    [historyHeadView addSubview:_clearHistoryBtn];
    [self addSubview:historyHeadView];
    
    for (int i = 0; i<historyArray.count; i++) {
        NSString *name = historyArray[i][@"title"];
        CGRect frame;
        CGFloat width = (ScreenWidth-15*3)/2;
        if (i % 2 == 0) {
             frame = CGRectMake(15, 36+(32+15)*(i/2), width, 32);
        } else {
            frame = CGRectMake(15+(width+15), 36+(32+15)*(i-1)/2, width, 32);
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn setTitle:name forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
        [btn setTitleColor:UIColorFromRGB(0x4A4A4A, 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.layer.cornerRadius = 2;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void) click:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(passKeyword:)]) {
        [self.delegate passKeyword:btn.titleLabel.text];
    }
}



@end
