//
//  HomeViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeHeadCollectionReusableView.h"
#import "HomeHead_title_CollectionReusableView.h"
#import "HomeFootCollectionReusableView.h"
#import "HomeHorizontalCollectionViewCell.h"
#import "ListTabViewController.h"
#import "ListViewController.h"
#import "HomeRequest.h"
#import "PlayerViewController.h"
#import "StorageHelper.h"
#import "Mobile_YoYoTV-Swift.h"
#import "LoginViewController.h"


@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomeCirculationScrollViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *storageArray;
@property (nonatomic,strong) NSArray *headArray;
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *titlesForList;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NoWiFiView *noWifiView;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SearchHistory"];
    [self.view addSubview:self.noWifiView];
    _noWifiView.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestDataWithDictionary:nil];
}

- (void) requestDataWithDictionary:(NSDictionary *)dic {
    _noWifiView.hidden = YES;
    self.loaderHUD.activityIndicatorView.frame = CGRectMake((ScreenWidth-50)*0.5, (ScreenHeight-64-90-70-50)*0.5, 50, 50);
    [self.loaderHUD showLoader];
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    HomeRequest *requet = [[HomeRequest alloc] init];
    requet.currentIndex = self.currentIndex;
    [requet requestData:dic andBlock:^(HomeRequest *responseData) {
        self.headArray = responseData.responseHeadArray.count > 8 ? [responseData.responseHeadArray subarrayWithRange:NSMakeRange(0, 8)] : responseData.responseHeadArray;
        self.storageArray = responseData.responseHeadArray;//存储推荐列表的数组，以防详情页面没有推荐内容
        self.contentArray = responseData.responseDataArray;
        self.titleArray = responseData.titleArray;
        self.titlesForList = responseData.title_passed;
        [self addStorageHelper];
        //此处应该dismiss掉菊花，但是要先initCollection，要不会有一段时间的空白
        if (self.contentArray.count > 0) {
            [self initCollectionView];
        } else {
            if (_currentIndex) {
                NoResultView *noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
                [self.view addSubview:noResultView];
//                [SVProgressHUD dismiss];
                [self.loaderHUD dismissLoader];
            }
        }
        
    } andFailureBlock:^(HomeRequest *responseData) {
//        [SVProgressHUD dismiss];
        [self.loaderHUD dismissLoader];
        _noWifiView.hidden = NO;
    }];
}

- (void) initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 3;
    CGFloat itemWidth = (ScreenWidth-padding)/2.0;
    CGFloat itemHeight = itemWidth * (106.0/186.0)+6+20+2+17+12;
    layout.itemSize    = CGSizeMake(itemWidth, itemHeight); // 设置cell的宽高
    layout.minimumLineSpacing = 0; //行间距
    layout.minimumInteritemSpacing = 3.0; // 列间距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeHorizontalCollectionViewCell class] forCellWithReuseIdentifier:@"HomeHorizontalCollectionViewCell"];
    [_collectionView registerClass:[HomeHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeadCollectionReusableView"];
    [_collectionView registerClass:[HomeHead_title_CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHead_title_CollectionReusableView"];
    [_collectionView registerClass:[HomeFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
//    [SVProgressHUD dismiss];
    [self.loaderHUD dismissLoader];
}

#pragma mark - collectionView代理方法
//多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.contentArray.count;
}

//每个分区有多少cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_contentArray[section] count] > 8) {
        return 8;
    } else {
        long count = [_contentArray[section] count];
        count = count % 2 == 0 ? count : count - 1;
        return count;
    }
}

//每个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = _contentArray[indexPath.section][indexPath.row];
    HomeHorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeHorizontalCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            HomeHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeadCollectionReusableView" forIndexPath:indexPath];
            [headView detailArray:self.headArray];
            headView.delegate = self;
            headView.titleLabel.text = _titleArray[indexPath.section][@"name"];
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
            headView.titleLabel.font = font;
            CGSize labelSize = [headView.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
            headView.greenView.frame = CGRectMake(0, 5+6, 3, 20);
            headView.titleLabel.frame = CGRectMake(15, 5+6, labelSize.width, 20);
            headView.moreLabel.frame = CGRectMake(ScreenWidth-15-8-5-40, 5+5, 40, 20);
            headView.categoryBtn.tag = indexPath.section;
            [headView.categoryBtn addTarget:self action:@selector(pushCategoryVC:) forControlEvents:UIControlEventTouchUpInside];
            return headView;
        }
        HomeHead_title_CollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHead_title_CollectionReusableView" forIndexPath:indexPath];
        headView.titleLabel.text = _titleArray[indexPath.section][@"name"];
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        headView.titleLabel.font = font;
        CGSize labelSize = [headView.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        headView.titleLabel.frame = CGRectMake(15, 6+(36-20)/2, labelSize.width, 20);
        headView.moreLabel.frame = CGRectMake(ScreenWidth-15-8-5-40, 10+10, 40, 20);
        headView.categoryBtn.tag = indexPath.section;
        [headView.categoryBtn addTarget:self action:@selector(pushCategoryVC:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }else {
        HomeFootCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView" forIndexPath:indexPath];
        return footerView;
    }
}

- (void) pushCategoryVC:(UIButton *)btn {
    if ([_currentIndex  isEqual: @88]) {
        NSNumber *currentID = _titlesForList[btn.tag][@"id"];
        NSNumber *currentGenreID = _titlesForList[btn.tag][@"genre_id"];
        NSLog(@"点中的分类的id------%@---geneid:%@",currentID,currentGenreID);
        ListViewController *vc = [ListViewController new];
        vc.tabHeight = 0;
        vc.navHeight = 64;
        vc.titleName = [btn.subviews[1] text];
        [vc setupNav];
        vc.ID = currentID;
        [vc initMethod];
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    } else {
        ListTabViewController *vc = [[ListTabViewController alloc] init];
        NSMutableArray *subtitlesArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *genreIDs = [NSMutableArray arrayWithObject:_currentIndex];
        for (int i = 0; i < _titlesForList.count; i++) {
            NSDictionary *dic = _titlesForList[i];
            [subtitlesArray addObject:dic[@"name"]];
            [genreIDs addObject:dic[@"id"]];
        }
        [subtitlesArray insertObject:@"全部" atIndex:0];
        vc.datas = subtitlesArray;
        vc.genreIDs = genreIDs;
        vc.genreID = [NSString stringWithFormat:@"%@",_currentIndex];
        vc.currentIndex = btn.tag;
        vc.titleName = _currentGenreTitle;
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

//collectionView头视图的高度
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, ScreenWidth*210/375+32+5);
    } else {
        return CGSizeMake(0, 42);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HomeModel *model = _contentArray[indexPath.section][indexPath.row];
    [self pushWithPay:model];
}

//滚动视图的代理方法
- (void) didSecectedHomeCirculationScrollViewAnIndex:(NSInteger)currentpage{
    HomeModel *model = _headArray[currentpage];
    [self pushWithPay:model];
}

- (void) pushWithPay:(HomeModel *)model {
    BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP499"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP299"] boolValue]);
    
    if (!isPay && model.pay) {
//        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
//        BOOL isLogin = dic;
//        if (isLogin) {
//            PurchaseViewController *vc = [PurchaseViewController new];
//            vc.isHideTab = NO;
//            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//        } else {
//            LoginViewController *vc = [LoginViewController new];
//            vc.isHide = NO;
//            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//        }
        PurchaseViewController *vc = [PurchaseViewController new];
        vc.isHideTab = NO;
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    } else {
        PlayerViewController *vc = [[PlayerViewController alloc] init];
//        vc.model = model;
        vc.ID = [NSString stringWithFormat:@"%@",model.ID];
        vc.isHideTabbar = NO;
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

- (void) addStorageHelper {
    StorageHelper *sharedInstance = [StorageHelper sharedSingleClass];
    sharedInstance.storageArray = self.storageArray;
}


//- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"结束-----%f",scrollView.contentOffset.y);
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"滑动-----%f",scrollView.contentOffset.y);
    if ([self.showNavDelegate respondsToSelector:@selector(didShowNav:)]) {
        [self.showNavDelegate didShowNav:scrollView];
    }
}

- (NoWiFiView *)noWifiView {
    if (!_noWifiView) {
        _noWifiView = [[NoWiFiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
        [_noWifiView.reloadBtn addTarget:self action:@selector(reloadCurrentPageData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noWifiView;
}

- (void) reloadCurrentPageData:(UIButton *)btn {
    [self requestDataWithDictionary:nil];
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}

@end
