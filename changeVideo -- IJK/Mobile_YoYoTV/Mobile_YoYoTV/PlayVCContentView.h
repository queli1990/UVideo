//
//  PlayVCContentView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/26.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectedEpisodeDelegate <NSObject>

- (void) selectedEpisode:(UIButton *)selectedBtn;

@end

@interface PlayVCContentView : UIView

@property (nonatomic,weak) id<selectedEpisodeDelegate> delegate;

/*选中的集数*/
@property (nonatomic) NSInteger selectedIndex;

/**根据genre_id判断类型**/
@property (nonatomic,strong) NSNumber *genre_id;
/**播放的url数组**/
@property (nonatomic,strong) NSMutableArray *playUrlArray;

@property (nonatomic) CGFloat totalHeight;

@property (nonatomic,strong) UIView *view1;
/**影片名称**/
@property (nonatomic,strong) UILabel *videoNameLabel;
/** 下载按钮 */
@property (nonatomic,strong) UIButton *downloadBtn;
/**收藏按钮**/
@property (nonatomic,strong) UIButton *collectionBtn;
/**分享按钮**/
@property (nonatomic,strong) UIButton *shareBtn;


@property (nonatomic,strong) UIView *view2;
/**共多少集**/
@property (nonatomic,strong) UILabel *totalEpisodeLabel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat view2Height;


@property (nonatomic,strong) UIView *view3;
/**导演**/
@property (nonatomic,strong) UILabel *directorLabel;
/**演员**/
@property (nonatomic,strong) UILabel *actorLabel;
/**简介**/
@property (nonatomic,strong) UILabel *descriptionLabel;


@property (nonatomic,strong) UIView *view4;
/**展开/收起按钮**/
@property (nonatomic,strong) UIButton *showDescriptionBtn; //对应的view4

/**更多影片推荐**/
@property (nonatomic,strong) UIView *headView;
//@property (nonatomic,strong) NSDictionary *playHistory;

/**推荐视图**/
//@property (nonatomic,strong) UICollectionView *collectionView;


- (void) addContentView ;
- (void) addDescriptionView:(CGFloat)height;
- (void) addHeadViewOriginalY:(CGFloat)headOriginalY;

@end
