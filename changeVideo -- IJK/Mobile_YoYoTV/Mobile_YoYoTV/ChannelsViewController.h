//
//  ChannelsViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"

@interface ChannelsViewController : UIViewController <RDVTabBarDelegate>
@property (nonatomic,strong) RDVTabBarController *mainTabbar;
@end
