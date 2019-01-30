//
//  SettingViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SettingViewController.h"
#import "NavView.h"
#import "SettingTableViewCell.h"
#import "ExitView.h"
#import "LoginViewController.h"
#import "UserProtocolViewController.h"
//#import "AboutUsViewController.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *heaerView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupHeader];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"系统设置";
    [self.view addSubview:nav];
}

- (void) setupHeader {
    CGFloat height = ScreenWidth * 9/16;
    self.heaerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-78)/2, (height-78)/2, 78, 78)];
    img.image = [UIImage imageNamed:@"settingHeaderImg"];
    [_heaerView addSubview:img];
}

- (void) setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCell"];
    _tableView.tableHeaderView = _heaerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60-15, (50-20)/2, 60, 20)];
        newLabel.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
//        newLabel.backgroundColor = UIColorFromRGB(0x7ED321, 1.0);
        newLabel.font = [UIFont systemFontOfSize:13];
        newLabel.textAlignment = NSTextAlignmentRight;
        newLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        [cell.contentView addSubview:newLabel];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.arrowImg.hidden = YES;
    } else {
        cell.arrowImg.hidden = NO;
    }
    cell.textLabel.text = _titlesArray[indexPath.row][@"title"];
    cell.textLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1435558135"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else if (indexPath.row == 2) {
        UserProtocolViewController *vc = [UserProtocolViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 84;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ExitView *headView = [ExitView new];
    [headView.exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (void) exitBtnClick:(UIButton *) btn {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    BOOL isLogin = userInfo;
    if (isLogin) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [btn setTitle:@"登录/注册" forState:UIControlStateNormal];
    } else {
        LoginViewController *vc = [LoginViewController new];
        vc.isHide = YES;
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

- (NSArray *)titlesArray {
    if (_titlesArray == nil) {
        NSDictionary *dic1 = @{@"title":@"当前版本"};
        NSDictionary *dic2 = @{@"title":@"我来打分"};
        NSDictionary *dic3 = @{@"title":@"用户协议"};
        _titlesArray = @[dic1,dic2,dic3];
    }
    return _titlesArray;
}


@end
