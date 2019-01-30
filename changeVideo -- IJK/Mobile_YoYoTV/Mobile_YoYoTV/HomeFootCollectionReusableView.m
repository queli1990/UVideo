//
//  HomeFootCollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeFootCollectionReusableView.h"

@implementation HomeFootCollectionReusableView

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *viewForFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        viewForFoot.backgroundColor = [UIColor yellowColor];
        [self addSubview:viewForFoot];
    }
    return self;
}

@end
