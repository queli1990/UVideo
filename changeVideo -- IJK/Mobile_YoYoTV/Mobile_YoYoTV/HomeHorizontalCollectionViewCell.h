//
//  HomeHorizontalCollectionViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/14.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeHorizontalCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *sumImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) HomeModel *model;


/*右上角的小logo，VIP,1080P,720P等等*/
@property (nonatomic,strong) UILabel *attributeLabel;
/*小标题*/
@property (nonatomic,strong) UILabel *subLabel;
/*总共多少集数、第多少期、评分*/
@property (nonatomic,strong) UILabel *totalEpisodeLabel;

@end
