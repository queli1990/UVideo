//
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import "ShortVideoBarViewController.h"
#import "NavView.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "ShortVideoViewController.h"
#import "ShortVideoRequest.h"

@interface ShortVideoBarViewController () <TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
//顶部滑动的标题数组
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@property (nonatomic,strong) NoWiFiView *noWifiView;
@end

@implementation ShortVideoBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    bgView.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.noWifiView];
    _noWifiView.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) requestData {
    _noWifiView.hidden = YES;
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [self.loaderHUD showLoader];
    ShortVideoRequest *request = [ShortVideoRequest new];
    [request requestData:nil SuccessBlock:^(ShortVideoRequest *responseData) {
        self.datas = responseData.responseData;
        for (int i = 0; i < self.datas.count; i++) {
            ShortVideoGenreModel *model = _datas[i];
            [self.titles addObject:model.name];
        }
        if (!_tabBar) {
            [self addTabPageBar];
            [self addPagerController];
        }
        [self loadData];
    } failureBlcok:^(ShortVideoRequest *responseData) {
//        [SVProgressHUD dismiss];
        [self.loaderHUD dismissLoader];
        _noWifiView.hidden = NO;
    }];
}

- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    tabBar.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 0;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void) loadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

-(BOOL)shouldAutorotate{
    return NO;
}

//设置tabbar的高度
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tabBar.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return _titles.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _titles[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _titles[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.titles.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ShortVideoViewController *vc = [[ShortVideoViewController alloc] init];
    ShortVideoGenreModel *model = _datas[index];
    vc.vimeoID = model.vimeo_id;
    vc.vimeoToken = model.vimeo_token;
    return vc;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (NoWiFiView *)noWifiView {
    if (!_noWifiView) {
        _noWifiView = [[NoWiFiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
        [_noWifiView.reloadBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noWifiView;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray arrayWithCapacity:0];
    }
    return _titles;
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}

@end
