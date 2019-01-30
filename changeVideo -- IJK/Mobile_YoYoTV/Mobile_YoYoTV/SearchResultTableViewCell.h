//
//  SearchResultTableViewCell.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/4.
//  Copyright © 2018年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface SearchResultTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *sumImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) SearchResultModel *model;

/*右上角的小logo，VIP,1080P,720P等等*/
@property (nonatomic,strong) UILabel *attributeLabel;
/*总共多少集数、第多少期、评分*/
@property (nonatomic,strong) UILabel *totalEpisodeLabel;

@end
