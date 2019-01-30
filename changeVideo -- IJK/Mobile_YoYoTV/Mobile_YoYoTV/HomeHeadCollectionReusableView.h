//
//  HomeHeadCollectionReusableView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInfiniteScrollView.h"
#import "HomeModel.h"

@protocol HomeCirculationScrollViewDelegate <NSObject>
- (void) didSecectedHomeCirculationScrollViewAnIndex:(NSInteger)currentpage;
@end

@interface HomeHeadCollectionReusableView : UICollectionReusableView <BHInfiniteScrollViewDelegate>
@property (nonatomic,weak) id <HomeCirculationScrollViewDelegate> delegate;
@property (nonatomic,strong) HomeModel *model;

@property (nonatomic,strong) UIView *greenView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moreLabel;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UIButton *categoryBtn;

- (void) detailArray:(NSArray *)bigModels;
- (void) addCirculationScrollView:(NSArray *)imageArray andTitleArray:(NSArray *)titleArray;

@end
