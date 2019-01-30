//
//  DownloadFinishTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadFinishTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *sizeLabel;
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) NSDictionary *modelDic;

@property (nonatomic,strong) HWDownloadModel *model;

+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
