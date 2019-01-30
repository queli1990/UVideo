//
//  ChannelsView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/17.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ChannelsView.h"
#import "UIButton+BottomLineButton.h"

@interface ChannelsView()

@end

@implementation ChannelsView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (ChannelsView *) addChannelsWithTitles:(NSArray *)array withIndex:(NSInteger)index{
    NSInteger lineNumber = 0;
    UIView *channelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    //添加layer层
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, ScreenWidth, 0);
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
//    layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
//                     (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
//    //起始点
//    layer.startPoint = CGPointMake(0.15, 0.5);
//    //结束点
//    layer.endPoint = CGPointMake(0.85, 0.5);
    layer.backgroundColor = [UIColorFromRGB(0x2F2D30, 1.0) CGColor];
    [channelView.layer addSublayer:layer];
    

    NSMutableArray *btns = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btns addObject:btn];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        btn.titleLabel.font = font;
        CGSize labelSize = [btn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        
        if (i==0) {
            btn.frame = CGRectMake(0, 10, labelSize.width+16, 30);
        }else{
            UIButton *label1 = btns[i-1];
            btn.frame = CGRectMake(CGRectGetMaxX(label1.frame), label1.frame.origin.y, labelSize.width+16, 30);
            if (CGRectGetMaxX(btn.frame) > ScreenWidth-50 && lineNumber == 0) {//说明此时需要折行
                CGRect frame = btn.frame;
                frame = CGRectMake(0, CGRectGetMaxY(label1.frame)+10, labelSize.width+16, 30);
                btn.frame = frame;
                lineNumber += 1;
            }
            if (CGRectGetMaxX(btn.frame) > ScreenWidth) {
                CGRect frame = btn.frame;
                frame = CGRectMake(0, CGRectGetMaxY(label1.frame)+10, labelSize.width+16, 30);
                btn.frame = frame;
            }
        }
        btn.tag = 1000 + i;
        [btn addLineWithButton:btn];
        btn.line.hidden = YES;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [channelView addSubview:btn];
    }
    
    CGRect frame = channelView.frame;
    UILabel *label2 = btns[btns.count-1];
    frame.size.height = CGRectGetMaxY(label2.frame)+10;
    channelView.frame = frame;
    layer.frame = channelView.bounds;
    
    UIView *_shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(channelView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(channelView.frame)-49)];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx:)];
//    [_shadowView addGestureRecognizer:tap];
    
    ChannelsView *allView = [[ChannelsView alloc] initWithFrame:CGRectMake(0, channelView.frame.origin.y, ScreenWidth, ScreenHeight-CGRectGetMaxY(channelView.frame)-49)];
    
    [allView addSubview:channelView];
    [allView addSubview:_shadowView];
    return allView;
}

- (void) xx:(UITapGestureRecognizer *)tap {
    NSLog(@"tap了");
//    if ([self.hideDelegate respondsToSelector:@selector(hideNav)]) {
//        [self.hideDelegate hideNav];
//    }
}

- (void) click:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:btn.tag];
    }
}


@end
