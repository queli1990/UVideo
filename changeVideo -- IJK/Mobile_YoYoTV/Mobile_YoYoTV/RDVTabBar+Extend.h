//
//  RDVTabBar+Extend.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/17.
//  Copyright © 2019 li que. All rights reserved.
//

#import "RDVTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDVTabBar (Extend)

- (void)showBadgeOnItemIndex:(NSInteger)index; // 显示小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index; // 隐藏小红点

@end

NS_ASSUME_NONNULL_END
