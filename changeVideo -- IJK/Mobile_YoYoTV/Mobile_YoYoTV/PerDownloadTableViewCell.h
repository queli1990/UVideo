//
//  PerDownloadTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerDownloadTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *stateImgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) HWDownloadModel *model;

+ (instancetype) cellWithTableView:(UITableView *)tableView;

// 更新视图
- (void) updateViewWithModel:(HWDownloadModel *)model;

@end

NS_ASSUME_NONNULL_END
