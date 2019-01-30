//
//  RDVTabBar+Extend.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/17.
//  Copyright © 2019 li que. All rights reserved.
//

#import "RDVTabBar+Extend.h"

#define kBadgeViewTag 200  // 红点起始tag值
#define kBadgeWidth  6  // 红点宽高

@implementation RDVTabBar (Extend)

//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = kBadgeViewTag + index;
    badgeView.layer.cornerRadius = kBadgeWidth / 2;
    badgeView.backgroundColor = [UIColor redColor];
    
    
    // 设置小红点的位置
    for (int i = 0; i < self.subviews.count; i++){
        UIView* subView = self.subviews[i];
        if ([subView isKindOfClass:NSClassFromString(@"RDVTabBarItem")]){
            // 找到需要加小红点的view，根据frame设置小红点的位置
            if (i == index) {
                // 数字9为向右边的偏移量，可以根据具体情况调整
                CGFloat x = subView.frame.origin.x + subView.frame.size.width / 2 + 20;
                CGFloat y = 6;
//                badgeView.frame = CGRectMake(x, y, kBadgeWidth, kBadgeWidth);
                [subView addSubview:badgeView];
                [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(0-(subView.frame.size.width/2 + 20));
                    make.top.mas_equalTo(y);
                    make.size.mas_equalTo(CGSizeMake(kBadgeWidth, kBadgeWidth));
                }];
                break;
            }
        }
    }
}

// 隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
}

// 移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    // 根据tag的值移除
    UIView *rd_VTabBarItem = self.subviews[index];
    for (UIView *subView in rd_VTabBarItem.subviews) {
        if (subView.tag == kBadgeViewTag + index) {
            [subView removeFromSuperview];
        }
    }
}


@end
