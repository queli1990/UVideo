//
//  NineBoxDownloadBtn.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/5.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NineBoxDownloadBtn : UIView

@property (nonatomic,strong) HWDownloadModel *model;    // 数据模型
@property (nonatomic, assign) HWDownloadState state;   // 下载状态

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIImageView *imgView;

@property (nonatomic,strong) NSArray *downloadUrlArray;

// 剧集的ID
@property (nonatomic,copy) NSString *episodeID;

// 添加点击方法
- (void)addTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
