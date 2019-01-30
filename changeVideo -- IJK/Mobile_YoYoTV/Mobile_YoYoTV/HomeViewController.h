//
//  HomeViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
//#import "ZJScrollPageView.h"
#import "TYPagerController.h"

@protocol didShowNavDelegate <NSObject>
- (void) didShowNav:(UIScrollView *)scrollView;
@end

@interface HomeViewController : TYPagerController
@property (nonatomic,weak) id<didShowNavDelegate> showNavDelegate;
@property (nonatomic,strong) UIView *customView;
@property (nonatomic,strong) NSNumber *currentIndex;
@property (nonatomic, copy) NSString *currentGenreTitle;
@end
