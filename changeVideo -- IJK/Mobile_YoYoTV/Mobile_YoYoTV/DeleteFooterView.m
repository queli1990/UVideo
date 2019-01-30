//
//  DeleteFooterView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/4.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "DeleteFooterView.h"

@implementation DeleteFooterView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //总共高49
        //顶部灰色分割线高度1
        UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        upLine.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
        [self addSubview:upLine];
        //宽度为整体的一般
        self.allSelecteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSelecteBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 48);
        [_allSelecteBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelecteBtn setTitleColor:UIColorFromRGB(0x4A4A4A, 1.0) forState:UIControlStateNormal];
        [self addSubview:_allSelecteBtn];
        //中间的分割线
        UILabel *centerLine = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-1)/2, (49-29)/2, 1, 29)];
        centerLine.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
        [self addSubview:centerLine];
        //右边的删除按钮
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(ScreenWidth/2, 1, ScreenWidth/2, 48);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_deleteBtn];
    }
    return self;
}

@end
