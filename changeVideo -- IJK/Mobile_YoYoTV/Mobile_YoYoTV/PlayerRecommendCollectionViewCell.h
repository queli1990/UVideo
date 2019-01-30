//
//  PlayerRecommendCollectionViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/1/16.
//  Copyright © 2018年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface PlayerRecommendCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *sumImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) HomeModel *model;
@property (nonatomic,strong) UIImageView *vipImgView;

@end
