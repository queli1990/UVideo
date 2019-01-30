//
//  HotSearchTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/23.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HotSearchTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *indexLable;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) HomeModel *model;

@end
