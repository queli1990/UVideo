//
//  PlayHistoryTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayHistoryModel.h"

@interface PlayHistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *sumImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) PlayHistoryModel *model;
@property (nonatomic,strong) UIImageView *vipImgView;

@end
