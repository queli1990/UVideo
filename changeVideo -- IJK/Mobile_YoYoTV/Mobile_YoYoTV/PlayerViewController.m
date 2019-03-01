//
//  PlayerViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
//#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "ZFPlayerControlView.h"


#import "PlayerRequest.h"
#import "PlayVCContentView.h"
#import "StorageHelper.h"
#import "SearchResultTableViewCell.h"

#import "PlayerCollectionReusableView.h"
#import "Mobile_YoYoTV-Swift.h"
#import "LoginViewController.h"
#import "NSString+encrypto.h"
#import "PlayerUserRequest.h"
#import "ShareView.h"
#import "UserActionRequest.h"

#import "PlayerNativeAdsView.h"
#import "PerDownloadViewController.h"
#import "ZFUtilities.h"

static NSString *const LiveAdUnit = @"ca-app-pub-7468136908049062/2225844601";
static NSString *const pageCode = @"1000100006";

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface PlayerViewController ()<selectedIndexDelegate,UITableViewDelegate,UITableViewDataSource,ShareResultDelegate,SelectedConfigDelete>
/** 播放器View的父视图*/
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFIJKPlayerManager *playerManager;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
//@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong) NSArray *vimeoResponseArray;
@property (nonatomic,strong) NSDictionary *vimeoResponseDic;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic,strong) PlayVCContentView *videoInfoView;
@property (nonatomic,strong) NSArray *storageArray;
@property (nonatomic,strong) UIView *relatedView;
@property (nonatomic,strong) NSDictionary *playHistory;
@property (nonatomic) BOOL isCollected;
@property (nonatomic) BOOL isFromBtnClick;
@property (nonatomic,strong) UITableView *tableView;
/*用来做中间变量，给collectionView的headerView中影片信息部分传值*/
@property (nonatomic,strong) PlayerRequest *VimeoRequest;
@property (nonatomic) CGFloat sectionOneHeight;
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,strong) ShareView *shareView;
@property (nonatomic,assign) BOOL isLoadingData;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@property (nonatomic, strong) dispatch_source_t GCDTimer;
@property (nonatomic,strong) PlayerCollectionReusableView *headView;
//广告的view
@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic) BOOL isPop;
@property (nonatomic ,strong) UIView *deliverView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩
@property (nonatomic, strong) NSArray *urlsArray;
@end

@implementation PlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.isPlaying) {
        self.isPlaying = NO;
    }
    _enterPageTime = [Tools getTimeStamp];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    [self sendBuffer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    //设置状态栏颜色
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
    }
    _leavePageTime = [Tools getTimeStamp];
    int tempValue = [self.model.ID intValue];
    [UserActionRequest postDetailPageEventCode:@"1000106001" successCode:@1 beginTime:_enterPageTime endTime:_leavePageTime episode:[NSNumber numberWithInteger:_currentIndex] albumId:[NSNumber numberWithInt:tempValue] albumName:self.model.name];
    [self postPlayRecord];
    if (self.isPop) {
        self.player = nil;
    } else {
        [self.player.currentPlayerManager pause];
        _isPop = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstBuffer = YES;
    _isPop = YES;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 0;
    self.ID ? [self requestModel] : [self requestUserInfoData];
    [self setupPlayer];
    
    StorageHelper *instance = [StorageHelper sharedSingleClass];
    self.storageArray = instance.storageArray;
    self.beginTime = [Tools getCurrentTime];
}

- (void) requestModel {
    _requestModelBeginTime = [Tools getTimeStamp];
    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    NSString *url = [NSString stringWithFormat:@"http://videocdn.chinesetvall.com/albums/%@/?format=json",self.ID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.model = [HomeModel modelWithDictionary:dic];
        [self requestUserInfoData];
        [self postTimeWithEvent:@"1000106002" successCode:@1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self postTimeWithEvent:@"1000106002" successCode:@0];
        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

/**请求用户相关信息：是否收藏和播放记录**/
- (void) requestUserInfoData {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo ? YES : NO;
    if (!isLogin) {
        [self requestVimeoData];
        return;
    }
    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [[PlayerUserRequest new] requestUserVideoInfoWithID:[NSString stringWithFormat:@"%@",self.model.ID] andBlock:^(PlayerUserRequest *responseData) {
        self.isCollected = responseData.isCollected;
        self.playHistory = responseData.playHistory;
    } andFilureBlock:^(PlayerUserRequest *responseData) {
        [ShowErrorAlert showSuccessWithMsg:@"获取用户播放记录失败" withViewController:self finish:^{
            
        }];
        [SVProgressHUD showWithStatus:@"请检查网络"];
        [SVProgressHUD dismissWithDelay:2];
    }];
    [self requestVimeoData];
}

/**请求viemeo接口**/
- (void) requestVimeoData {
    _requestVimeoBeginTime = [Tools getTimeStamp];
    _isLoadingData = YES;
    PlayerRequest *request = [PlayerRequest new];
    request.genre_id = self.model.genre_id;
    request.ID = self.model.ID;
    request.vimeo_id = self.model.vimeo_id;
    request.vimeo_token = self.model.vimeo_token;
    request.regexName = self.model.name;
    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [request requestVimeoPlayurl:^(PlayerRequest *responseData) {
        // 发送获取vimeo接口的请求时间
        _requestVimeoEndTime = [Tools getTimeStamp];
        int tempValue = [self.model.ID intValue];
        [UserActionRequest postDetailPageEventCode:@"1000106005" successCode:@1 beginTime:_requestVimeoBeginTime endTime:_requestVimeoEndTime episode:[NSNumber numberWithInteger:_currentIndex] albumId:[NSNumber numberWithInt:tempValue] albumName:self.model.name];
        
        PlayerRequest *vimeoRequest = responseData;
        _isLoadingData = NO;
        PlayerRequest *relatedRequest = [[PlayerRequest alloc] init];
        relatedRequest.ID = self.model.ID;
        [relatedRequest requestRelatedData:nil andBlock:^(PlayerRequest *responseData) {
            if (responseData.responseData.count > 0) {
                self.storageArray = responseData.responseData;
            }
            self.VimeoRequest = vimeoRequest;
            PlayerCollectionReusableView *headView = [PlayerCollectionReusableView new];
            headView.model = self.model;
            headView.selectedIndex = _currentIndex;
            [headView dealResponseData:self.VimeoRequest];
            self.sectionOneHeight = headView.headerInfoHeight;
            self.vimeoResponseDic = headView.vimeoResponseDic;
            self.vimeoResponseArray = headView.vimeoResponseArray;
            headView.delegate = self;
            [self configTableViewDate];
//            [self configHeaderView];
            [self setNewModel];
            [SVProgressHUD dismiss];
        } andFailureBlock:^(PlayerRequest *responseData) {
            [SVProgressHUD showWithStatus:@"请求数据失败"];
            [SVProgressHUD dismissWithDelay:2];
        }];
    } andFailureBlock:^(PlayerRequest *responseData) {
        if (!_requestVimeoEndTime) _requestVimeoEndTime = [Tools getTimeStamp]; // 防错处理
        int tempValue = [self.model.ID intValue];
        [UserActionRequest postDetailPageEventCode:@"1000106005" successCode:@0 beginTime:_requestVimeoBeginTime endTime:_requestVimeoEndTime  episode:[NSNumber numberWithInteger:_currentIndex] albumId:[NSNumber numberWithInt:tempValue] albumName:self.model.name];
        _isLoadingData = NO;
        [SVProgressHUD showWithStatus:@"请求数据失败"];
        [SVProgressHUD dismissWithDelay:2];
    }];
}

/// 设置tableView的头视图
- (void) configHeaderView {
    self.headView.model = self.model;
    _headView.selectedIndex = _currentIndex;
    [_headView dealResponseData:self.VimeoRequest];
    self.sectionOneHeight = _headView.headerInfoHeight;
    self.vimeoResponseDic = _headView.vimeoResponseDic;
    self.vimeoResponseArray = _headView.vimeoResponseArray;
    self.headView.delegate = self;
}

/// 根据请求的结果，刷新、新建tableView
- (void) configTableViewDate {
    BOOL isHaveInitTableView = false;
    for ( UIView *view in self.view.subviews ) {
        NSString *className = NSStringFromClass([view class]);
        if ([className isEqualToString:@"UITableView"]) {
            isHaveInitTableView = true;
            break;
        }
    }
    isHaveInitTableView ? [_tableView reloadData] : [self initTableView];
}

/**设置播放的model**/
/**当前只考虑默认进入页面，即index=0时，如果user选集的话另做考虑**/
- (void) setNewModel {
//    BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP499"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP299"] boolValue]);
    //如果没有支付，就先不加载视频，而是去播放广告。等广告播放完毕再加载视频
//    if (!isPay) {
//        // 加载广告
//        [self setModelUrl];
//    } else {
//        [self setModelUrl];
//    }
    [self setModelUrl];
    [UIView animateWithDuration:0.3 animations:^{
        _bannerView.alpha = 1;
    }];
}

- (void) setModelUrl {
    [self clearLastPlayerConfig];
    if (self.vimeoResponseDic) { // 电影
        [self showNativeAds];
        [self jsonPlayUrl:self.vimeoResponseDic];
    }
    if (self.vimeoResponseArray.count > 0) { // 电视剧
        [self showNativeAds];
        if ([_playHistory isKindOfClass:[NSDictionary class]]) {
            NSInteger historyIndex = [_playHistory[@"episodes"] integerValue];
            _currentIndex = historyIndex;
        }
        NSDictionary *currendDic = self.vimeoResponseArray[(int)_currentIndex];
        [self jsonPlayUrl:currendDic];
    }
    // 如果数组和dic都为空，说明发生了错误，返回
    if (self.vimeoResponseArray.count < 1 && !self.vimeoResponseDic) {
        [ShowErrorAlert showErrorMeg:@"加载视频发生错误" withViewController:self finish:^{
            [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:_isHideTabbar];
        }];
    }
    //判断是否已经播放过
    if ([_playHistory isKindOfClass:[NSDictionary class]]) {
        NSString *playedTimeStr = _playHistory[@"playbackProgress"];
        self.playerManager.seekTime = [playedTimeStr integerValue];
        _playHistory = nil;
    }
    _firstBufferStartTime = [Tools getTimeStamp];
    _isFirstBuffer = YES;
    [self setListener];
}

/// 设置播放的url
- (void) jsonPlayUrl:(NSDictionary *)itemDic {
    self.urlsArray = [PlayerRequest dealUrlWithDownload:itemDic[@"download"]];
    [self setDefaultLandScapeDefinition];
    NSString *videoTitle = itemDic[@"name"];
    self.player.assetURL = [_urlsArray[0] objectForKey:@"url"];
    [self.controlView showTitle:videoTitle coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
    [self.player.currentPlayerManager play];
}

/// 设置清晰度
- (void) setDefaultLandScapeDefinition {
    self.controlView.landScapeControlView.definitionBtn.userInteractionEnabled = YES;
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_urlsArray];
    [tempArray insertObject:@{@"width":@"清晰度",@"url":@""} atIndex:0];
    [self.controlView.landScapeControlView.definitionBtn setTitle:[tempArray[1] objectForKey:@"width"] forState:UIControlStateNormal];
    self.controlView.landScapeControlView.definitionArray = (NSArray *)tempArray;
}

/// 清除清晰度数组
- (void) clearLandScapeDefinition {
    self.controlView.landScapeControlView.definitionBtn.userInteractionEnabled = NO;
    self.controlView.landScapeControlView.definitionArray = [NSArray array];
}

/// 清除上一次的选中清晰度、播放进度
- (void) clearLastPlayerConfig {
    self.playerManager.rate = 1;
    [_controlView.landScapeControlView clearSelectStyle];
}

- (void) setListener {
    @weakify(self);
    _player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self);
        if (self.isFirstBuffer) {
            _firstBufferEndTime = [Tools getTimeStamp];
            int tempValue = [self.model.ID intValue];
            [UserActionRequest postDetailPageEventCode:@"1000106006" successCode:@1 beginTime:self.firstBufferStartTime endTime:self.firstBufferEndTime  episode:[NSNumber numberWithInteger:self.currentIndex] albumId:[NSNumber numberWithInt:tempValue] albumName:self.model.name];
            _isFirstBuffer = NO;
        } 
    };
    _player.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {
//        NSLog(@"loadStateChanged -- %lu",(unsigned long)loadState);
        @strongify(self);
        if (loadState == ZFPlayerLoadStatePlayable) { // 缓冲结束
            _nextBufferEndTime = [Tools getTimeStamp];
            [self addBuffer];
        }
        else if (loadState == ZFPlayerLoadStateStalled) { // 开始缓冲
            self.nextBufferStartTime = [Tools getTimeStamp];
        }
    };
    _player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self);
        self.firstBufferEndTime = [Tools getTimeStamp];
        int tempValue = [self.model.ID intValue];
        [UserActionRequest postDetailPageEventCode:@"1000106006" successCode:@0 beginTime:self.firstBufferStartTime endTime:self.firstBufferEndTime  episode:[NSNumber numberWithInteger:self.currentIndex] albumId:[NSNumber numberWithInt:tempValue] albumName:self.model.name];
        self.isFirstBuffer = YES;
    };
    _player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self);
        [self sendBuffer];
    };
}

- (void) addBuffer {
    // 如果视频播放很顺畅，没有卡顿的开始时间，就不加入数组中。
    if (_nextBufferStartTime && _nextBufferEndTime) {
        if (_nextBufferEndTime == _nextBufferStartTime) return;
        // 排重 -- 某种网络下可能导致order1和order2的开始时间相同
        for (int i = 0; i < self.buffersArray.count; i++) {
            NSDictionary *tempDic = self.buffersArray[i];
            NSNumber *tempStartBufferTime = [tempDic objectForKey:@"startTime"];
            if (tempStartBufferTime == _nextBufferStartTime) {
                return;
            }
        }
        NSDictionary *event = @{@"startTime":_nextBufferStartTime,
                                @"endTime":_nextBufferEndTime,
                                @"order":[NSNumber numberWithInteger:self.buffersArray.count],
                                @"pageEvent":@"1000106007",
                                @"success":@1
                                };
        [self.buffersArray addObject:event];
    }
}

- (void) sendBuffer {
    if (self.buffersArray.count ) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSDictionary *params = @{
                                 @"deviceId":[YDDevice getUQID],
                                 @"pageEvents":self.buffersArray,
                                 @"pageName":@"1000100006",
                                 @"platform":@"ios",
                                 @"sysVersion":[[UIDevice currentDevice] systemVersion],
                                 @"appName":[infoDictionary objectForKey:@"CFBundleName"],
                                 @"appVersion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
                                 @"albumId":self.model.ID,
                                 @"albumName":self.model.name,
                                 @"download":@"0"
                                 };
        [UserActionRequest postDetailPageEvent:params];
        [self.buffersArray removeAllObjects];
    }
    _nextBufferStartTime = nil;
    _nextBufferEndTime = nil;
}

- (void) showNativeAds {
    NSLog(@"开始设置广告");
    return;
    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"config"];
    BOOL hasAd = [configDic[@"has_ad"] boolValue];
    if (!hasAd) {
        return;
    }
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:LiveAdUnit
                                       rootViewController:self
                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                  options:@[  ]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void) setupTimer:(UILabel *)timerLabel1 {
    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"config"];
    if (_GCDTimer) {
        dispatch_source_cancel(_GCDTimer);
    }
    __block int _timeout = [configDic[@"ad_duration"] intValue];
    __block UILabel *lable = timerLabel1;
    // GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    _GCDTimer = _timer;
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout <= 0 ){// 倒计时结束
            // 关闭定时器
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _nativeAdView.hidden = YES;
//                [self.player.currentPlayerManager play];
                [self.player.currentPlayerManager reloadPlayer];
            });
        }else{// 倒计时中
            // 显示倒计时结果
            NSString *strTime = [NSString stringWithFormat:@"%d", _timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                lable.text = [NSString stringWithFormat:@"%@",strTime];
            });
            _timeout--;
        }
    });
    // 开启定时器
    dispatch_resume(_timer);
}

#pragma mark GADUnifiedNativeAdLoaderDelegate implementation
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    [self.player.currentPlayerManager pause];
    if (!self.nativeAdView) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
        self.nativeAdView = [nibObjects firstObject];
//        self.nativeAdView = [[PlayerNativeAdsView alloc] initWithFrame:self.playerView.frame];
        [self.controlView addSubview:_nativeAdView];
        
        UILabel *timerLabel = [[UILabel alloc] init];
        timerLabel.layer.cornerRadius = 10;
        timerLabel.backgroundColor = [UIColor grayColor];
        timerLabel.textColor = [UIColor greenColor];
        timerLabel.textAlignment = NSTextAlignmentCenter;
        timerLabel.font = [UIFont systemFontOfSize:13];
        
        [_nativeAdView addSubview:timerLabel];
        [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.equalTo(_nativeAdView.mas_right).offset(0);
            make.width.height.mas_equalTo(20);
        }];
        [self setupTimer:timerLabel];
    } else {
        _nativeAdView.hidden = NO;
//        NSInteger labelIndex = [[_nativeAdView subviews] count] - 2;
//        NSLog(@"%ld",(long)labelIndex);
        UILabel *label = [[_nativeAdView subviews] objectAtIndex:10];
        [self setupTimer:label];
    }
    GADUnifiedNativeAdView *nativeAdView = self.nativeAdView;
    // Deactivate the height constraint that was set when the previous video ad loaded.
    nativeAdView.nativeAd = nativeAd;
    // Set ourselves as the ad delegate to be notified of native ad events.
    nativeAd.delegate = self;
    // Populate the native ad view with the native ad assets.
    // Some assets are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline; /// Google
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body; /// Congratulations! You have successfully implemented Rewarded Video!
    [((UIButton *)nativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                                forState:UIControlStateNormal]; /// INSTALL
    // Some native ads will include a video asset, while others do not. Apps can
    // use the GADVideoController's hasVideoContent property to determine if one
    // is present, and adjust their UI accordingly.
    if (nativeAd.videoController.hasVideoContent) {
        // This app uses a fixed width for the GADMediaView and changes its height
        // to match the aspect ratio of the video it displays.
        if (nativeAd.videoController.aspectRatio > 0) {
            NSLog(@"有视频");
        }
        // By acting as the delegate to the GADVideoController, this ViewController
        // receives messages about events in the video lifecycle.
        nativeAd.videoController.delegate = self;
        NSLog(@"Ad contains a video asset.");
    } else {
        NSLog(@"Ad does not contain a video .");
    }
    // These assets are not guaranteed to be present, and should be checked first.
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    if (nativeAd.icon != nil) {
        nativeAdView.iconView.hidden = NO;
    } else {
        nativeAdView.iconView.hidden = YES;
    }
    ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating]; /// 4
    if (nativeAd.starRating) {
        nativeAdView.starRatingView.hidden = NO;
    } else {
        nativeAdView.starRatingView.hidden = YES;
    }
    ((UILabel *)nativeAdView.storeView).text = nativeAd.store; /// App Store
    if (nativeAd.store) {
        nativeAdView.storeView.hidden = NO;
    } else {
        nativeAdView.storeView.hidden = YES;
    }
    ((UILabel *)nativeAdView.priceView).text = nativeAd.price; /// FREE
    if (nativeAd.price) {
        nativeAdView.priceView.hidden = NO;
    } else {
        nativeAdView.priceView.hidden = YES;
    }
    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    if (nativeAd.advertiser) {
        nativeAdView.advertiserView.hidden = NO;
    } else {
        nativeAdView.advertiserView.hidden = YES;
    }
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;
}

- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
    double starRating = numberOfStars.doubleValue;
    if (starRating >= 5) {
        return [UIImage imageNamed:@"stars_5"];
    } else if (starRating >= 4.5) {
        return [UIImage imageNamed:@"stars_4_5"];
    } else if (starRating >= 4) {
        return [UIImage imageNamed:@"stars_4"];
    } else if (starRating >= 3.5) {
        return [UIImage imageNamed:@"stars_3_5"];
    } else {
        return nil;
    }
}

/**当点中某一集的时候的代理方法**/
- (void)selectedButton:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    if (index == _currentIndex) {
        btn.selected = YES;
        return;
    }
    [self clearLastPlayerConfig];
    [self clearLandScapeDefinition];
    _currentIndex = index;
    btn.selected = YES;
    
    [self sendBuffer]; // 发送缓存次数和对应的时间
    [self showNativeAds];
    [UIView animateWithDuration:0.3 animations:^{
        _bannerView.alpha = 1;
    }];
    [self postPlayRecord];
    
    //不能通过 [self setNewModel]; 方法来设置，因为[self setNewModel];方法里面有判断是否存在播放历史
    NSDictionary *currendDic = self.vimeoResponseArray[(int)_currentIndex];
    self.urlsArray = [PlayerRequest dealUrlWithDownload:currendDic[@"download"]];
    [self setDefaultLandScapeDefinition];
    self.player.assetURL = [_urlsArray[0] objectForKey:@"url"];
    NSString *videoTitle = currendDic[@"name"];
    [self.controlView showTitle:videoTitle coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
    [self.player.currentPlayerManager play];
    _firstBufferStartTime = [Tools getTimeStamp];
    _isFirstBuffer = YES;
}

- (void) setupPlayer {
    [self.view addSubview:self.containerView];
    
    self.playerManager = [[ZFIJKPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完自动播放下一个
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player playTheNext];
        if (!self.player.isLastAssetURL) {
            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
        } else {
            [self.player stop];
        }
    };
}

#pragma mark -- Player相关属性
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
//    return self.player.shouldAutorotate;
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        return UIInterfaceOrientationMaskLandscape;
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void) popToLastPage {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:_isHideTabbar];
}

- (void) postVideoInfo {
    NSString *deviceId = [YDDevice getUQID];
    NSString *albumId = [NSString stringWithFormat:@"%@",self.model.ID];
    NSString *albumTitle = self.model.name;
    NSNumber *albumCategory = self.model.genre_id;
    NSNumber *episodes = _currentIndex ? [NSNumber numberWithInteger:_currentIndex] : @0;
    NSNumber *startTime = _firstBufferEndTime ? _firstBufferEndTime : [Tools getTimeStamp];
    NSNumber *endTime = [Tools getTimeStamp];
    NSDictionary *params = @{@"deviceId":deviceId,
                             @"albumId":albumId,
                             @"albumTitle":albumTitle,
                             @"albumCategory":albumCategory,
                             @"episodes":episodes,
                             @"startTime":startTime,
                             @"endTime":endTime
                             };
    [UserActionRequest postVideoInfo:params];
}

- (void) postPlayRecord {
    if (!self.model) return;
    [self postVideoInfo];
    if (self.player == nil) return;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo;
    if (!isLogin) {
        return;
    }
//    NSLog(@"currentTime.value---%lld",self.playerView.player.currentTime.value);
//    NSLog(@"currentTime.timescale---%d",self.playerView.player.currentTime.timescale);
    CGFloat watchTime = _player.currentTime;

    [[PlayerUserRequest new] postUserRecoreWithTitle:self.model.name albumID:self.model.ID albumImg:self.model.landscape_poster_s currentIndex:_currentIndex watchedTime:watchTime pay:self.model.pay];
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+ScreenWidth*9/16, ScreenWidth, ScreenHeight-ScreenWidth*9/16 - 10 - 20) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[SearchResultTableViewCell class] forCellReuseIdentifier:@"SearchResultTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_relatedView addSubview:_tableView];
    [self.view addSubview:_tableView];
    
    // 添加广告
    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"config"];
    BOOL hasAd = [configDic[@"has_ad"] boolValue];
    if (hasAd) {
        [self addBannerViewToView:self.bannerView];
    }
    [self.view bringSubviewToFront:_bannerView];
}

#pragma mark UITableViewDelegate
//有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个分区下有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storageArray.count;
}

//每个cell是什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultTableViewCell" forIndexPath:indexPath];
    cell.model = self.storageArray[indexPath.row];
    return cell;
}

//头视图
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headView) {
        return _headView;
    }
//    [self configHeaderView];
    self.headView = [PlayerCollectionReusableView new];
    _headView.model = self.model;
    _headView.selectedIndex = _currentIndex;
    [_headView dealResponseData:self.VimeoRequest];
    self.sectionOneHeight = _headView.headerInfoHeight;
    self.vimeoResponseDic = _headView.vimeoResponseDic;
    self.vimeoResponseArray = _headView.vimeoResponseArray;
    _headView.delegate = self;
    //判断是否已经收藏
    _headView.videoInfoView.collectionBtn.selected = self.isCollected;
    //添加收藏按钮的点击事件
    [_headView.videoInfoView.downloadBtn addTarget:self action:@selector(toDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.videoInfoView.collectionBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.videoInfoView.shareBtn addTarget:self action:@selector(showShareView:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.videoInfoView.showDescriptionBtn addTarget:self action:@selector(showDescription:) forControlEvents:UIControlEventTouchUpInside];
    _headView.videoInfoView.frame = CGRectMake(_headView.videoInfoView.frame.origin.x, _headView.videoInfoView.frame.origin.y, _headView.videoInfoView.frame.size.width, _sectionOneHeight);
    return _headView;
}

- (void) showDescription:(UIButton *)btn {
    [_headView showMoreDescript:_headView.videoInfoView.showDescriptionBtn];
    _sectionOneHeight = _headView.headerInfoHeight;
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footView.backgroundColor = [UIColor whiteColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _sectionOneHeight + 10;
}

//点中cell的相应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearLandScapeDefinition];
    if (_isLoadingData) {
        [ShowErrorAlert showSuccessWithMsg:@"小主，稍等哦，数据还在加载中" withViewController:self finish:^{
            
        }];
        return;
    }
    [self sendBuffer]; // 发送缓存次数和对应的时间
    //将头视图滞空，因为在加载简介label的时候有根据头视图的内容来做处理！！！
    _headView = nil;
    //先暂停播放
    [_player.currentPlayerManager pause];
    
    _playHistory = nil;
#pragma mark 播放记录
    [self postPlayRecord];
    
    HomeModel *model = self.storageArray[indexPath.row];
    BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP499"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP299"] boolValue]);
    if (!isPay && model.pay) {
        //        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        //        BOOL isLogin = dic;
        //        if (isLogin) {
        //            PurchaseViewController *vc = [PurchaseViewController new];
        //            vc.isHideTab = YES;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        } else {
        //            LoginViewController *vc = [LoginViewController new];
        //            vc.isHide = YES;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        }
        PurchaseViewController *vc = [PurchaseViewController new];
        vc.isHideTab = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.model = model;
    [_relatedView removeFromSuperview];
    [_videoInfoView removeFromSuperview];
    _vimeoResponseDic = nil;
    _vimeoResponseArray = nil;
    self.currentIndex = 0;
    [self requestUserInfoData];
}


// 统计当前根据ID获取的数据时间
- (void) postTimeWithEvent:(NSString *)eventCode successCode:(NSNumber *)successCodeNum {
    _requestModelEndTime = [Tools getTimeStamp];
    int vimeoID = [self.model.ID intValue];
    [UserActionRequest postDetailPageEventCode:eventCode successCode:successCodeNum beginTime:_requestModelBeginTime endTime:_requestModelEndTime  episode:[NSNumber numberWithInteger:_currentIndex] albumId:[NSNumber numberWithInt:vimeoID] albumName:self.model.name];
}

// 展示底部分享页面
- (void) showShareView:(UIButton *)btn {
    NSString *urlString ;
    if (self.model.genre_id.integerValue == 3) {//电影
        urlString = [NSString stringWithFormat:@"http://share.chinesetvall.com/#/movie?id=%@",_model.ID];
    } else if (self.model.genre_id.integerValue == 4) {//综艺
        urlString = [NSString stringWithFormat:@"http://share.chinesetvall.com/#/variety?id=%@&index=%ld",_model.ID,(long)_currentIndex];
    } else {
        urlString = [NSString stringWithFormat:@"http://share.chinesetvall.com/#/?id=%@&index=%ld",_model.ID,(long)_currentIndex];
    }
    NSDictionary *params = @{@"title":_model.name,@"shareURL":urlString};
    [self.shareView setViewWithTitles:@[@"分享到Facebook",@"复制链接"] imgs:@[[UIImage imageNamed:@"facebook"],[UIImage imageNamed:@"link"]] shareParams:params];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view addSubview:self.shareView];
    } completion:^(BOOL finished) {
        [_player.currentPlayerManager pause];
    }];
}

// 下载按钮
- (void) toDownloadPage:(UIButton *)btn {
    PerDownloadViewController *vc = [PerDownloadViewController new];
    vc.type = self.model.genre_id.intValue;
    vc.ID = self.ID;
//    vc.imgURL = self.model.landscape_poster_s;
    vc.model = self.model;
    vc.vimeoDataDic = [NSMutableDictionary dictionaryWithDictionary:self.vimeoResponseDic];
    vc.vimeoDataArray = self.vimeoResponseArray;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        [_player.currentPlayerManager pause];
    }];
    _isPop = NO;
}

// 收藏按钮
- (void) collection:(UIButton *)btn {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo;
    if (isLogin) {
        if (btn.selected) {
            [self deleteCollection:btn];
        } else { //应该收藏
            [self postAlbum:btn];
        }
    } else {
        [_player.currentPlayerManager pause];
        LoginViewController *vc = [LoginViewController new];
        vc.isHide = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) deleteCollection:(UIButton *)btn {
    [[PlayerUserRequest new] cancleCollectionWithID:self.model.ID andBlock:^(PlayerUserRequest *responseData) {
        if ([responseData.status isEqualToString:@"2"] || [responseData.status isEqualToString:@"3"]) {
            btn.selected = NO;
        }
    } andFilureBlock:^(PlayerUserRequest *responseData) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"取消收藏网络出现问题"];
        [alert show:nil];
    }];
}

//收藏按钮的点击事件
- (void) postAlbum:(UIButton *)btn {
    [[PlayerUserRequest new] collectionWithID:self.model.ID title:self.model.name image:self.model.landscape_poster_s pay:self.model.pay andBlock:^(PlayerUserRequest *responseData) {
        if ([responseData.status isEqualToString:@"3"] || [responseData.status isEqualToString:@"2"]) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    } andFilureBlock:^(PlayerUserRequest *responseData) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"收藏网络发生错误"];
        [alert show:nil];
    }];
}

- (void) dismissShareView {
    [UIView animateWithDuration:0.25 animations:^{
        [self.shareView removeFromSuperview];
    } completion:^(BOOL finished) {
        [_player.currentPlayerManager play];
    }];
}

// 分享的返回结果
- (void) shareCallBack:(NSDictionary *)dic {
    [ShowErrorAlert showErrorMeg:[dic objectForKey:@"msg"] withViewController:self finish:^{
        [self dismissShareView];
    }];
}

//添加广告的view
- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    if (@available(ios 11.0, *)) {
        // In iOS 11, we need to constrain the view to the safe area.
        [self positionBannerViewFullWidthAtBottomOfSafeArea:bannerView];
    } else {
        // In lower iOS versions, safe area is not available so we use
        // bottom layout guide and view edges.
        [self positionBannerViewFullWidthAtBottomOfView:bannerView];
    }
}

#pragma mark - view positioning
- (void)positionBannerViewFullWidthAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0) {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Make it constrained to the edges of the safe area.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
                                              [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
                                              [guide.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor]
                                              ]];
}

- (void)positionBannerViewFullWidthAtBottomOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}

- (void) dismissAds:(UIButton *)btn {
    [UIView animateWithDuration:0.3 animations:^{
        _bannerView.alpha = 0;
    }];
}

#pragma mark setter
- (GADBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView =[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        //        _bannerView.delegate = self;
        //        _bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";//测试ID
        _bannerView.adUnitID = @"ca-app-pub-7468136908049062/5709757680";// 正式ID
        _bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        
        //如果是开发阶段，需要填写测试手机的UUID，不填写可能会误会你自己刷展示量
        //            request.testDevices = @[@"2009e2c8ce304f5dc2b0746ec4814d44"];
        [_bannerView loadRequest:request];
        
        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissBtn.frame = CGRectMake(_bannerView.frame.size.width-20, 0, 20, 20);
        [dismissBtn setImage:[UIImage imageNamed:@"personal_clearBtnHeighted"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismissAds:) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView addSubview:dismissBtn];
    }
    return _bannerView;
}

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
        [_shareView.shadowView addGestureRecognizer:tap];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.landScapeControlView.tempViewController = self.navigationController;
        _controlView.landScapeControlView.definitionBtn.userInteractionEnabled = NO;
        _controlView.landScapeControlView.delegate = self;
        _controlView.fastViewAnimated = YES;
        [_controlView.portraitControlView.backBtn addTarget:self action:@selector(popToLastPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlView;
}

# pragma mark 清晰度、倍速选择回调
- (void) selectedIndex:(NSInteger)index withConfigType:(ConfigType)type {
    if (type == rateType) { // 改变的播放速率
        NSArray *tempArr = @[@"播放倍速",@"1.0X",@"1.25X",@"1.5X",@"2.0X"];
        [_controlView.landScapeControlView.rateBtn setTitle:tempArr[index] forState:UIControlStateNormal];
        self.playerManager.rate = [tempArr[index] floatValue];
    } else { // 改变清晰度
        NSDictionary *tempDic = self.controlView.landScapeControlView.definitionArray[index];
        NSTimeInterval time = self.playerManager.currentTime;
        self.playerManager.seekTime = time;
        self.player.assetURL = tempDic[@"url"];
        [_controlView.landScapeControlView.definitionBtn setTitle:tempDic[@"width"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        _containerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*9/16);
        [_containerView sd_setImageWithURL:[NSURL URLWithString:kVideoCover]];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
        CGFloat min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
        CGFloat min_y = 20;
        CGFloat min_w = 20;
        CGFloat min_h = 20;
        backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
        [backBtn addTarget:self action:@selector(popToLastPage) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:backBtn];
    }
    return _containerView;
}

//- (PlayerCollectionReusableView *)headView {
//    if (!_headView) {
//        _headView = [PlayerCollectionReusableView new];
//    }
//    return _headView;
//}

- (NSArray *)storageArray {
    if (_storageArray == nil) {
        _storageArray = [NSArray array];
    }
    return _storageArray;
}

- (NSMutableArray *)buffersArray {
    if (!_buffersArray) {
        _buffersArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buffersArray;
}

- (NSArray *)urlsArray {
    if (!_urlsArray) {
        _urlsArray = [NSArray array];
    }
    return _urlsArray;
}

@end
