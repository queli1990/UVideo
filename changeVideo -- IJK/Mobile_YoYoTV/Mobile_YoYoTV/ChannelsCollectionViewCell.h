//
//  ChannelsCollectionViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenresModel.h"

@interface ChannelsCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *sumimageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) GenresModel *model;

@end
