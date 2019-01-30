//
//  DownloadImgView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadImgView : UIImageView

@property (nonatomic, strong) HWDownloadModel *model;  // 数据模型
@property (nonatomic, assign) HWDownloadState state;   // 下载状态

@end

NS_ASSUME_NONNULL_END
