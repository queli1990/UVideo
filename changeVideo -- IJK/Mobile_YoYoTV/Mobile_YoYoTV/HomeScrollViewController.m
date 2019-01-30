//
//  HomeScrollViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/17.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeScrollViewController.h"
#import "ZJScrollPageView.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "HomeRequest.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "ChannelsView.h"
#import "UIButton+BottomLineButton.h"
#import "PlayHistoryViewController.h"
#import "LoginViewController.h"
#import "UserActionRequest.h"

@interface HomeScrollViewController () <TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,didShowNavDelegate,selectNavIndexDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray *genreModels;
@property (strong, nonatomic) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic,strong) UIView *animatedView;
@property (nonatomic,strong) UIView *underNavScrollView;
@property (nonatomic) BOOL isNavHidden;
@property (nonatomic,strong) UIView *allChannelsView;
@property (nonatomic,strong) ChannelsView *channelsView;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger lastIndex;
@property (nonatomic,strong) NoWiFiView *noWifiView;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@end

@implementation HomeScrollViewController

//防止某些手势返回时，底部的tabbar不显示
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.noWifiView];
    _noWifiView.hidden = YES;
    [self requestData];
    [self liveness]; //post活跃度
}

- (void) liveness {
    [UserActionRequest postOnceUserDevice];
    NSString *url = @"http://pv.sohu.com/cityjson?ie=utf-8";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSRange range = [str rangeOfString:@"=" options:NSRegularExpressionSearch];
        NSString *xx = [str substringFromIndex:range.location+1];
        NSString *xxx = [xx substringToIndex:xx.length-1];
        NSData *data = [xxx dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *IP = dic[@"cip"];
        [[NSUserDefaults standardUserDefaults] setObject:IP forKey:@"IP"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求IP失败----%@",error);
    }];
}

- (void) requestData {
    _noWifiView.hidden = YES;
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [self.loaderHUD showLoader];
    [[[HomeRequest alloc] init] requestData:nil andBlock:^(HomeRequest *responseData) {
        self.genreModels = [[NSArray alloc] initWithArray:responseData.genresArray];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<_genreModels.count; i++) {
            GenresModel *model = _genreModels[i];
            [tempArray addObject:model.name];
        }
        self.titles = (NSArray *)tempArray;
        [self setupView];
//        [SVProgressHUD dismiss];
        [self.loaderHUD dismissLoader];
    } andFailureBlock:^(HomeRequest *responseData) {
//        [SVProgressHUD dismiss];
        [self.loaderHUD dismissLoader];
        _noWifiView.hidden = NO;
    }];
}

- (void) setupView {
//    [[[CAGradientLayer alloc] init] addLayerWithY:20+50 andHeight:70 withAddedView:self.view];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 20+50, ScreenWidth, 70);
    layer.backgroundColor = [UIColorFromRGB(0x2F2D30, 1.0) CGColor];
    [self.view.layer addSublayer:layer];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    
    self.underNavScrollView = [[UIView alloc] init];
    
    if (self.genreModels.count >= 7) {
        //增加右边的按钮
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(ScreenWidth-50, 0, 50, 44);
        [button1 setImage:[UIImage imageNamed:@"showall"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(showAllChannel:) forControlEvents:UIControlEventTouchUpInside];
        [_underNavScrollView addSubview:button1];
    }
    
    [_underNavScrollView addSubview:tabBar];
    [self.view addSubview:_underNavScrollView];
    _tabBar = tabBar;
    
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
    [self reloadData];
    
    [self setupNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToIndex:) name:@"passIndex" object:nil];
}

- (void) scrollToIndex:(NSNotification *)noti {
    NSInteger index = [[[noti userInfo] objectForKey:@"index"] integerValue];
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setupNav {
    [[[CAGradientLayer alloc] init] addLayerWithY:0 andHeight:70 withAddedView:self.view];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, ScreenWidth, 70);
    layer.backgroundColor = [UIColorFromRGB(0x2F2D30, 1.0) CGColor];
    [self.view.layer addSublayer:layer];
    
    self.animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 50)];
    
    
    UIImageView *rectangleView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (50-32)/2, ScreenWidth-60, 32)];
    rectangleView.image = [UIImage imageNamed:@"Rectangle"];
    rectangleView.userInteractionEnabled = YES;
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, (32-20)/2, 20, 20)];
    searchImg.image = [UIImage imageNamed:@"search"];
    UILabel *searchTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame)+16, 0, 200, 32)];
    searchTitle.text = @"搜索您喜欢的影片";
    searchTitle.textAlignment = NSTextAlignmentLeft;
    searchTitle.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    searchTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [rectangleView addSubview:searchImg];
    [rectangleView addSubview:searchTitle];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSearch:)];
    [rectangleView addGestureRecognizer:tap];
    [_animatedView addSubview:rectangleView];
    
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(ScreenWidth-15-20, (50-20)/2, 20, 20);
    [historyBtn setImage:[UIImage imageNamed:@"playhistory"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(goPlayHistory:) forControlEvents:UIControlEventTouchUpInside];
    
//    [_animatedView addSubview:leftImg];
//    [_animatedView addSubview:searchBtn];
    [_animatedView addSubview:historyBtn];
    [self.view addSubview:_animatedView];
}

- (void) showAllChannel:(UIButton *)btn {
    if (_channelsView == nil) {
        self.channelsView = [[[ChannelsView alloc] init] addChannelsWithTitles:self.titles withIndex:_currentIndex];
        _channelsView.delegate = self;
        _channelsView.frame = CGRectMake(0, _underNavScrollView.frame.origin.y, ScreenWidth, _channelsView.frame.size.height);
        
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(ScreenWidth-50, 0, 50, 44);
        [hiddenBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hideNav) forControlEvents:UIControlEventTouchUpInside];
        [_channelsView addSubview:hiddenBtn];
        
        UIView *shadowView = _channelsView.subviews[1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNav)];
        [shadowView addGestureRecognizer:tap];
    }
    //获取所有的button，然后对当前的button添加下划线
//    UIButton *lastBtn = [_channelsView.subviews[0] subviews][_lastIndex];
//    lastBtn.line.hidden = YES;
    for (UIButton *btn in [_channelsView.subviews[0] subviews]) {
        btn.line.hidden = YES;
    }
    UIButton *selectedBtn = [_channelsView.subviews[0] subviews][_currentIndex];
    selectedBtn.line.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view addSubview:_channelsView];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) selectedIndex:(NSInteger)index {
//    [_tabBar scrollToItemFromIndex:2 toIndex:5 animate:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [_channelsView removeFromSuperview];
    } completion:^(BOOL finished) {
        [_pagerController scrollToControllerAtIndex:index-1000 animate:YES];
    }];
}

- (void) hideNav {
    [UIView animateWithDuration:0.25 animations:^{
        [_channelsView removeFromSuperview];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _underNavScrollView.frame = CGRectMake(0, 70, ScreenWidth, 44);
    // tabBar的第一个按钮需要距离最左边边框 15个px
    _tabBar.frame = CGRectMake(15, (44-44)/2, CGRectGetWidth(self.view.frame)-50, 44);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_underNavScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_underNavScrollView.frame));
    if (self.isNavHidden) {
        self.view.frame = CGRectMake(0, -50, ScreenWidth, (ScreenHeight-49)+50);
        _animatedView.hidden = YES;
    }
}

- (void) goSearch:(UITapGestureRecognizer *)tap {
    SearchViewController *vc = [SearchViewController new];
    vc.isTabPage = NO;
    [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
}

- (void) goPlayHistory:(UIButton *)btn {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo;
    if (isLogin) {
        PlayHistoryViewController *vc = [PlayHistoryViewController new];
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    } else {
        LoginViewController *vc = [LoginViewController new];
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titles.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    if (index == 0) {
        cell.titleLabel.textColor = UIColorFromRGB(0x0BBF06, 1.0);
    } else {
        cell.titleLabel.textColor = UIColorFromRGB(0xFFFFFF, 1.0);
    }
    cell.titleLabel.text = [self.genreModels[index] name];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = [self.genreModels[index] name];
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
    HomeViewController *vc = [[HomeViewController alloc] init];
    vc.currentGenreTitle = _titles[index];
    GenresModel *model = self.genreModels[index];
    vc.currentIndex = model.ID;
    vc.showNavDelegate = self;
    return vc;
}

- (void) didShowNav:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {//向上滑动，隐藏
        if (self.view.frame.origin.y == -50) return ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, -50, ScreenWidth, (ScreenHeight-49)+50);
            _animatedView.hidden = YES;
            _isNavHidden = YES;
        }];
    } else { //下滑，显示
        if (self.view.frame.origin.y == 0) return ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight-49));
            _animatedView.hidden = NO;
            _isNavHidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    self.currentIndex = toIndex;
    self.lastIndex = fromIndex;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (NoWiFiView *)noWifiView {
    if (!_noWifiView) {
        _noWifiView = [[NoWiFiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
        [_noWifiView.reloadBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noWifiView;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}

@end
