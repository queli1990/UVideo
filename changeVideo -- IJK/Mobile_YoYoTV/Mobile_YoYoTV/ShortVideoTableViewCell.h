//
//  ShortVideoTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/19.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "ShortVideoModel.h"

@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ShortVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *picView;
@property (nonatomic,strong) UIImageView *eyeImage;
@property (nonatomic,strong) UILabel *watchCountLabel;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *playBtn;

/**  分享按钮block**/
@property (nonatomic, copy  ) void(^shareBlock)(UIButton *);

@property (nonatomic,strong) ShortVideoModel *model;

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

@end

