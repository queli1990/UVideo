//
//  DownloadTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/26.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic,strong) HWDownloadModel *model;

@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UILabel *speedLabel;
@property (nonatomic,strong) UILabel *fileSizeLabel;


+ (instancetype) cellWithTableView:(UITableView *)tableView;

// 更新视图
- (void) updateViewWithModel:(HWDownloadModel *)model;


@end

NS_ASSUME_NONNULL_END
