//
//  MianViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "MianViewController.h"
#import "MainHeadView.h"
#import "NavView.h"
#import "SettingTableViewCell.h"
#import "LoginViewController.h"
//#import "PurchaseViewController.swift"
#import "Mobile_YoYoTV-Swift.h"
#import "SettingViewController.h"
#import "ConversionViewController.h"
#import "CollectionViewController.h"
#import "PlayHistoryViewController.h"
#import "FeedBackViewController.h"
#import "DownloadFinishViewController.h"
#import "RDVTabBar+Extend.h"
#import "ChatViewController.h"

@interface MianViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) MainHeadView *headView;
@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupTableView];
}

- (void) setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = dic;
//    if (indexPath.row == 0) {
//        if (isLogin) {
//            PurchaseViewController *vc = [PurchaseViewController new];
//            vc.isHideTab = NO;
//            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//        } else {
//            LoginViewController *vc = [LoginViewController new];
//            vc.isHide = NO;
//            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//        }
//    }
//    if (indexPath.row == 1) {
//        ConversionViewController *vc = [ConversionViewController new];
//        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//    }
    if (indexPath.row == 0) { // 离线缓存
        DownloadFinishViewController *vc = [DownloadFinishViewController new];
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
    if (indexPath.row == 1) {  //播放历史
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
    if (indexPath.row == 2) {  // 我的收藏
        if (isLogin) {
            CollectionViewController *vc = [CollectionViewController new];
            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
        } else {
            LoginViewController *vc = [LoginViewController new];
            vc.isHide = NO;
            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
        }
    }
    if (indexPath.row == 3) {  // 意见反馈
//        FeedBackViewController *vc = [FeedBackViewController new];
        ChatViewController *vc = [ChatViewController new];
        SettingTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        UIView *redView = [cell.contentView viewWithTag:10000];
        if (redView) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kUnReadNotiCount];
            [redView removeFromSuperview];
        }
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        RDVTabBarController *tabVC = (RDVTabBarController *)appDelegate.viewController;
        RDVTabBar *tabBar = tabVC.tabBar;
        [tabBar hideBadgeOnItemIndex:4];
    }
    if (indexPath.row == 4) { //系统设置
        SettingViewController *vc = [SettingViewController new];
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.contentArray[indexPath.row][@"name"];
    cell.iconImageView.image = [UIImage imageNamed:self.contentArray[indexPath.row][@"img"]];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 3) {
        cell.subTitleLabel.text = @"Feedback";
        [self setReadView:cell];
    }
    return cell;
}

- (void) setReadView:(SettingTableViewCell *)cell {
    NSString *count = [[NSUserDefaults standardUserDefaults] objectForKey:kUnReadNotiCount];
    if (count.integerValue > 0) {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-15-6-15-80-10, (50-5)*0.5, 5, 5)];
        redView.tag = 10000;
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = redView.frame.size.width/2;
        [cell.contentView addSubview:redView];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.headView = [[MainHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo;
    [_headView setupViewByIslogin:isLogin];
    if (!isLogin) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLoginPage:)];
        [_headView addGestureRecognizer:tap];
    }
    [_tableView reloadData];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 168;
}

- (void) setupView {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn setHidden:YES];
    nav.titleLabel.text = @"我的";
    [self.view addSubview:nav];
}

- (void) goLoginPage:(UITapGestureRecognizer *)tap {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.isHide = NO;
    [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
}

- (NSArray *) contentArray {
    if (_contentArray == nil) {
//        NSDictionary *dic1 = @{@"img":@"Main-payVIP",@"name":@"开通VIP会员"};
//        NSDictionary *dic2 = @{@"img":@"Main-VIPCode",@"name":@"VIP兑换码"};
        NSDictionary *dic2 = @{@"img":@"Main-download",@"name":@"离线缓存"};
        NSDictionary *dic3 = @{@"img":@"Main-playrecord",@"name":@"播放历史"};
        NSDictionary *dic4 = @{@"img":@"Main-collection",@"name":@"我的收藏"};
        NSDictionary *dic6 = @{@"img":@"Main-feedback",@"name":@"意见反馈"};
        NSDictionary *dic5 = @{@"img":@"Main-setting",@"name":@"系统设置"};
        _contentArray = [NSArray arrayWithObjects:dic2,dic3,dic4,dic6,dic5, nil];
    }
    return _contentArray;
}


@end
