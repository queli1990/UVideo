//
//  HomeHeadCollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeHeadCollectionReusableView.h"

@interface HomeHeadCollectionReusableView ()
@property (nonatomic,strong) NSMutableArray *tags;
@end

@implementation HomeHeadCollectionReusableView 

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void) setModel:(HomeModel *)model {
    _model = model;
}

- (void) detailArray:(NSArray *)bigModels {
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i<bigModels.count; i++) {
        HomeModel *model = bigModels[i];
        
        NSString *imgStr = imgStr = [model.landscape_poster stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        
        [images addObject:imgStr];
        [titles addObject:model.name];
        NSString *tag;
        if (model.pay) {
            tag = @"VIP";
        } else {
            tag = model.attributes;
        }
        [self.tags addObject:tag];
    }
    
    [self addCirculationScrollView:images andTitleArray:titles];
}

- (void) addCirculationScrollView:(NSArray *)imageArray andTitleArray:(NSArray *)titleArray{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
        CGFloat viewHeight = ScreenWidth * 210/375;
        
        BHInfiniteScrollView* infinitePageView1 = [BHInfiniteScrollView
                                                   infiniteScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight) Delegate:self ImagesArray:imageArray PlageHolderImage:[UIImage imageNamed:@"placeholder_16_9"]];
        infinitePageView1.tags = self.tags;
        infinitePageView1.titlesArray = titleArray;
        infinitePageView1.dotSize = 8;
        infinitePageView1.pageControlAlignmentOffset = CGSizeMake(0, 10);
        infinitePageView1.dotSpacing = 6;
        infinitePageView1.titleView.textColor = [UIColor whiteColor];
        infinitePageView1.titleView.margin = 30;
        //下面两行代码，让pageControl靠右
        infinitePageView1.pageControlAlignmentH = BHInfiniteScrollViewPageControlAlignHorizontalRight;
        infinitePageView1.pageControlAlignmentV = BHInfiniteScrollViewPageControlAlignVerticalButtom;
        infinitePageView1.titleView.hidden = YES;
        infinitePageView1.scrollTimeInterval = 5;
        infinitePageView1.autoScrollToNextPage = YES;
        infinitePageView1.delegate = self;
        [self addSubview:infinitePageView1];
    
    self.greenView = [[UIView alloc] initWithFrame:CGRectMake(0, (32-20)/2, 3, 20)];
    _greenView.backgroundColor = UIColorFromRGB(0x0BBF06, 1.0);
    _greenView.userInteractionEnabled = YES;
    
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (32-20)/2, 135, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, (42-16)/2, 8, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"ArrowRight"];
        
    
    self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-8-5-40, (32-20)/2, 40, 20)];
    _moreLabel.textAlignment = NSTextAlignmentRight;
    _moreLabel.font = [UIFont systemFontOfSize:14];
    _moreLabel.textColor = [UIColor grayColor];
    
    self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _categoryBtn.frame = CGRectMake(0, viewHeight, ScreenWidth, 32);

    [_categoryBtn addSubview:_greenView];
    [_categoryBtn addSubview:_titleLabel];
    [_categoryBtn addSubview:_arrowImageView];
    [_categoryBtn addSubview:_moreLabel];
    
    [self addSubview:_categoryBtn];
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didSecectedHomeCirculationScrollViewAnIndex:)]) {
        [self.delegate didSecectedHomeCirculationScrollViewAnIndex:index];
    }
}

- (NSMutableArray *) tags {
    if (_tags == nil) {
        _tags = [NSMutableArray arrayWithCapacity:0];
    }
    return _tags;
}

@end
