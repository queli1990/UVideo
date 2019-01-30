//
//  ListViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYPagerController.h"

@interface ListViewController : TYPagerController
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *titleName;


@property (nonatomic, assign) CGFloat navHeight;
@property (nonatomic, assign) CGFloat tabHeight;

- (void) setupNav;
- (void) initMethod;

@end
