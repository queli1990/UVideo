//
//  ShortVideoViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import "ShortVideoViewController.h"
#import "ShortVideoRequest.h"
#import "ShortVideoTableViewCell.h"
#import "HyPopMenuView/HyPopMenuView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ZFPlayer.h"
//#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"


@interface ShortVideoViewController () <UITableViewDelegate,UITableViewDataSource,HyPopMenuViewDelegate,FBSDKSharingDelegate,ZFTableViewCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic,strong) NoWiFiView *noWifiView;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL haveSetFreshHeader;
@property (nonatomic,assign) NSNumber *totalCount;
@property (nonatomic, strong) HyPopMenuView* menu;
@property (nonatomic, assign) NSInteger sharedVideoIndex;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@end

@implementation ShortVideoViewController

// 页面消失时候
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player.currentPlayerManager pause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) initMenu {
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [PopMenuModel
                           allocPopMenuModelWithImageNameString:@"facebook"
                           AtTitleString:@"分享到Facebook"
                           AtTextColor:[UIColor grayColor]
                           AtTransitionType:PopMenuTransitionTypeCustomizeApi
                           AtTransitionRenderingColor:nil];
    PopMenuModel* model1 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"link"
                            AtTitleString:@"复制链接"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    _menu.dataSource = @[ model, model1 ];
    _menu.delegate = self;
    _menu.popMenuSpeed = 12.0f;
    _menu.automaticIdentificationColor = YES;
    _menu.animationType = HyPopMenuViewAnimationTypeViscous;
    
    CGFloat height = 667*ScreenWidth/375;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    imgView.image = [UIImage imageNamed:@"shareBg"];
    _menu.topView = imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _haveSetFreshHeader = NO;
    _currentPage = 1;
    [self.view addSubview:self.noWifiView];
    _noWifiView.hidden = YES;
    
    [self requestVimeoData];
    [self initMenu];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49) style:UITableViewStylePlain];
    [_tableView registerClass:[ShortVideoTableViewCell class] forCellReuseIdentifier:@"ShortVideoTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // player依赖于tableView
    [self setupPlayer];
}

- (void) setupTableReloadHeader {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [self requestVimeoData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage += 1;
        [self requestVimeoData];
    }];
}

- (void) setupPlayer {
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
//    self.player.assetURLs = self.urls;
    self.player.shouldAutoPlay = YES;
    /// 1.0是完全消失的时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
//    自动播放下一个
//    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
//        @strongify(self)
//        if (self.player.playingIndexPath.row < self.urls.count - 1 && !self.player.isFullScreen) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
//        } else if (self.player.isFullScreen) {
//            [self.player stopCurrentPlayingCell];
//        }
//    };
}

- (void) requestVimeoData {
    _noWifiView.hidden = YES;
    self.loaderHUD.activityIndicatorView.frame = CGRectMake((ScreenWidth-50)*0.5, (ScreenHeight-64-49-50)*0.5, 50, 50);
    [self.loaderHUD showLoader];
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    NSDictionary *params = @{@"vimeoID":self.vimeoID,@"vimeoToken":self.vimeoToken,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"perCount":@"10"};
    [[[ShortVideoRequest alloc] init] requestVimeo:params SuccessBlock:^(ShortVideoRequest *responseData) {
        _totalCount = responseData.totalCount;
        if (_currentPage > 1) {
            [self.dataArray addObjectsFromArray: responseData.responseData];
            [_tableView reloadData];
        } else {
            self.dataArray = (NSMutableArray *)responseData.responseData;
            self.tableView ? [_tableView reloadData] : [self initTableView];
        }
        if (!_haveSetFreshHeader) {
            [self setupTableReloadHeader];
        }
        _haveSetFreshHeader = YES;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (_totalCount.longLongValue <= self.dataArray.count) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
//        [SVProgressHUD dismiss];
        [self.loaderHUD dismissLoader];
    } failureBlock:^(ShortVideoRequest *responseData) {
//        [SVProgressHUD showWithStatus:@"请检查网络"];
        [self.loaderHUD dismissLoader];
        _noWifiView.hidden = NO;
    }];
}

- (BOOL)shouldAutorotate {
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenWidth*9/16 + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShortVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShortVideoTableViewCell" forIndexPath:indexPath];
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(presentShare:) forControlEvents:UIControlEventTouchUpInside];
    // 取到对应cell的model
    ShortVideoModel *model        = self.dataArray[indexPath.row];
    // 赋值model
    cell.model = model;
    [cell setDelegate:self withIndexPath:indexPath];
    [cell setNormalMode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate
- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    ShortVideoModel *model = self.dataArray[indexPath.row];
    self.player.assetURL = [NSURL URLWithString:model.url];
    [self.controlView showTitle:model.title coverURLString:model.imgURL fullScreenMode:ZFFullScreenModeLandscape];
    [self.player.currentPlayerManager play];
}

// 推出分享页面
- (void) presentShare:(UIButton *)btn {
    _sharedVideoIndex = btn.tag;
    [_menu openMenu];
    [_player.currentPlayerManager pause];
}

// 点击分享页面的按钮的回调事件
- (void)popMenuView:(HyPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"buttonIndex:%lu----selectedIndex:%lu",(unsigned long)index,(unsigned long)_sharedVideoIndex);
    NSString *urlString = [NSString stringWithFormat:@"http://sharecdn.chinesetvall.com/#/short?id=%@&index=%ld&token=%@",_vimeoID,(long)_sharedVideoIndex,_vimeoToken];
//    http://sharecdn.chinesetvall.com/#/short?id=5498860&index=0&token=306fd2ec2aac624b874580e2ead9f1e1&total=14
    if (index == 0) { // facebook
        NSString *contentUrlString = urlString;
        ShortVideoModel *model = _dataArray[_sharedVideoIndex];
        NSString *description = model.title;
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:contentUrlString];
        content.quote = description;
        FBSDKShareDialog *dl = [[FBSDKShareDialog alloc] init];
        dl.mode = FBSDKShareDialogModeFeedWeb;
        dl.delegate = self;
        [dl setShareContent:content];
        [dl show];
    } else { // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = urlString;
        NSDictionary *dic = @{@"result":@"1",@"msg":@"复制成功"};
        [self shareResult:dic];
    }
}



- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSDictionary *dic = @{@"result":@"1",@"msg":@"分享成功"};
    [self shareResult:dic];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSDictionary *dic = @{@"result":@"-1",@"msg":@"分享失败"};
    [self shareResult:dic];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSDictionary *dic = @{@"result":@"-1",@"msg":@"分享取消"};
    [self shareResult:dic];
}

- (void) shareResult:(NSDictionary *)dic {
    [ShowErrorAlert showErrorMeg:[dic objectForKey:@"msg"] withViewController:self finish:^{
        [_player.currentPlayerManager play];
    }];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

- (NoWiFiView *)noWifiView {
    if (!_noWifiView) {
        _noWifiView = [[NoWiFiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49)];
        [_noWifiView.reloadBtn addTarget:self action:@selector(requestVimeoData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noWifiView;
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}


@end
