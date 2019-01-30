//
//  PlayHistoryViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayHistoryViewController.h"
#import "NSString+encrypto.h"
#import "PlayHistoryRequest.h"
#import "PlayHistoryTableViewCell.h"
#import "PlayerViewController.h"
#import "EditNavView.h"
#import "DeleteFooterView.h"
#import "NoRecordView.h"
#import "LoginViewController.h"
#import "Mobile_YoYoTV-Swift.h"


@interface PlayHistoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DeleteFooterView *deleteFooterView;
@property (nonatomic,strong) EditNavView *nav;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) NSMutableArray *albumIdArray;
@property (nonatomic,strong) NoRecordView *noResultView;
@end

@implementation PlayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self initTableView];
    [self initNoResultView];
    [self requestData];
    [self.view addSubview:self.deleteFooterView];
}

- (void) requestData {
    [[[PlayHistoryRequest alloc] init] requestData:nil andBlock:^(PlayHistoryRequest *responseData) {
        self.contentArray = [NSMutableArray arrayWithArray:responseData.responseArray];
        if (responseData.responseArray.count > 0) {
            [_tableView reloadData];
            _nav.editBtn.hidden = NO;
        } else {
            [_noResultView setHidden:NO];
            _nav.editBtn.hidden = YES;
        }
    } andFailureBlock:^(PlayHistoryRequest *responseData) {
        NSLog(@"fail");
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayHistoryTableViewCell" forIndexPath:indexPath];
    cell.model = self.contentArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayHistoryModel *model = _contentArray[indexPath.row];
    BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP499"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP299"] boolValue]);
    if (self.nav.editBtn.selected) { //编辑模式下
        [self.deleteArray addObject:model];
        [self.albumIdArray addObject:model.ID];
//        NSLog(@"%lu",(unsigned long)_deleteArray.count);
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (!isPay && model.pay) {
//            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
//            BOOL isLogin = dic;
//            if (isLogin) {
//                PurchaseViewController *vc = [PurchaseViewController new];
//                vc.isHideTab = YES;
//                [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//            } else {
//                LoginViewController *vc = [LoginViewController new];
//                vc.isHide = YES;
//                [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//            }
//            PurchaseViewController *vc = [PurchaseViewController new];
//            vc.isHideTab = NO;
//            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
//        } else {
            PlayerViewController *VC = [PlayerViewController new];
            VC.isHideTabbar = YES;
            VC.ID = model.albumId;
            [[PushHelper new] pushController:VC withOldController:self.navigationController andSetTabBarHidden:YES];
//        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayHistoryModel *model = _contentArray[indexPath.row];
    [self.deleteArray removeObject:model];
    [self.albumIdArray removeObject:model.ID];
//    NSLog(@"%lu",(unsigned long)_deleteArray.count);
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[PlayHistoryTableViewCell class] forCellReuseIdentifier:@"PlayHistoryTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) setupNav {
    self.nav = [[EditNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [_nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    _nav.titleLabel.text = @"播放历史";
    [_nav.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}

- (void) edit:(UIButton *) btn {
    btn.selected = !btn.selected;
    [self.tableView setEditing:btn.selected animated:YES];
    if (btn.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            _deleteFooterView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
            _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
        } completion:^(BOOL finished) {}];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _deleteFooterView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
            _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        } completion:^(BOOL finished) {}];
    }
}

// 编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (DeleteFooterView *)deleteFooterView {
    if (_deleteFooterView == nil) {
        _deleteFooterView = [[DeleteFooterView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 49)];
        [_deleteFooterView.allSelecteBtn addTarget:self action:@selector(selectAllCell:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteFooterView.deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteFooterView;
}

- (void) selectAllCell: (UIButton *)btn {
    [self.deleteArray removeAllObjects];
    [self.albumIdArray removeAllObjects];
    for (int i = 0; i < self.contentArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayHistoryTableViewCell *cell = (PlayHistoryTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selected = YES;
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        PlayHistoryModel *model = self.contentArray[i];
        [self.albumIdArray addObject:model.ID];
    }
    [self.deleteArray addObjectsFromArray:self.contentArray];
}

- (void) delete:(UIButton *) btn{
    if (self.deleteArray.count == 0) return;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = userInfo[@"token"];
    NSString *historyIds = [NSString stringWithFormat:@"%@",_albumIdArray[0]];
    for (int i = 1; i < _albumIdArray.count; i++) {
        historyIds = [historyIds stringByAppendingString:[NSString stringWithFormat:@",%@",_albumIdArray[i]]];
    }
    NSString *platform = @"mobile-ios";
    NSString *channel = @"uu100";
    NSString *language = @"cn";
    NSString *combinStr = [NSString stringWithFormat:@"%@%@%@%@%@",token,historyIds,platform,channel,language];
    NSString *mdStr = [combinStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:historyIds forKey:@"historyIds"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:channel forKey:@"channel"];
    [params setObject:language forKey:@"language"];
    [params setObject:mdStr forKey:@"sign"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://accountcdn.chinesetvall.com/app/member/doDeleteHistory.do" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"2"]) {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"播放历史删除成功"];
            [alert show:^{
                [self clearData]; // 将数组清空，并且判断是否还有观看历史，如果没有则显示无结果页面
            }];
        } else {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"播放历史删除失败"];
            [alert show:^{
                [self clearData];
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请检查网络"];
        [alert show:^{
            
        }];
    }];
}

- (void) clearData {
    [self edit:self.nav.editBtn];
    [_contentArray removeObjectsInArray:_deleteArray];
    [_albumIdArray removeAllObjects];
    [_deleteArray removeAllObjects];
    if (_contentArray.count > 0) {
        [_tableView reloadData];
    } else {
        _noResultView.hidden = NO;
        _tableView.hidden = YES;
        _nav.editBtn.hidden = YES;
    }
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

- (void) initNoResultView {
    self.noResultView = [[NoRecordView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    _noResultView.alertLabel.text = @"暂未播放，快播放你喜欢的影片吧";
    [self.view addSubview:_noResultView];
    _noResultView.hidden = YES;
}

- (NSMutableArray *) deleteArray {
    if (_deleteArray == nil) {
        _deleteArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _deleteArray;
}

- (NSMutableArray *) albumIdArray {
    if (_albumIdArray == nil) {
        _albumIdArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _albumIdArray;
}





@end
