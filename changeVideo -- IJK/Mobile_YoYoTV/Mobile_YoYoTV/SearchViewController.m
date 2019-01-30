//
//  SearchViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchNav.h"
#import "SearchHistory.h"
#import "HotSearchRequest.h"
#import "HotSearchTableViewCell.h"
#import "SearchResultTableView.h"
#import "PlayerViewController.h"
#import "Mobile_YoYoTV-Swift.h"
#import "LoginViewController.h"

const CGFloat NavHeight = 64;

@interface SearchViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,HistoryBtnClickDelegate>
@property (nonatomic,strong) SearchNav *nav;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,strong) SearchResultTableView *resultView;
@property (nonatomic) CGFloat height;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _height = _isTabPage ? ScreenHeight-NavHeight-49 : ScreenHeight-NavHeight;
    self.resultView = [[SearchResultTableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, _height)];
    [self setNav];
    [self requestDataForHotSearch];
}

- (void) requestDataForHotSearch {
    [self.loaderHUD showLoader];
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [[HotSearchRequest alloc] requestData:nil andBlock:^(HotSearchRequest *responseData) {
//        SuccessLog(NSStringFromClass([self class]));
        self.datas = responseData.responseData;
        self.tableView ? [self reloadTableView] : [self initTableView];
        [self.loaderHUD dismissLoader];
//        [SVProgressHUD dismiss];
    } andFailureBlock:^(HotSearchRequest *responseData) {
//        FailLog(NSStringFromClass([self class]));
        [self.loaderHUD dismissLoader];
//        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

- (void) reloadTableView {
    _tableView.hidden = NO;
    [self addTableViewHeadView];
    [self.tableView reloadData];
}

- (void) initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, _height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[HotSearchTableViewCell class] forCellReuseIdentifier:@"HotSearchTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addTableViewHeadView];
    [self.view addSubview:_tableView];
}

#pragma mark 根据是否有过搜索记录判断是否有头视图
- (void) addTableViewHeadView {
    NSArray *historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"];
    if (historyArray.count > 0) {
        int itemCount;
        if (historyArray.count % 2 == 0) {
            itemCount = (int)historyArray.count/2;
        }else {
            itemCount = (int)historyArray.count/2 + 1;
        }
        SearchHistory *historyView = [[SearchHistory alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36+itemCount*(32+15))];
        historyView.backgroundColor = [UIColor whiteColor];
        historyView.delegate = self;
        [historyView addHistoryView:historyArray];
        _tableView.tableHeaderView = historyView;
        [historyView.clearHistoryBtn addTarget:self action:@selector(clearUser:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//通过历史搜索view上的btn的delegate 将点击的str传过来
- (void) passKeyword:(NSString *)str {
    [self passKeywordToResultView:str];
}

//新建resultView，并开始请求keyword对应的数据
- (void) passKeywordToResultView:(NSString *)keyword {
    //2.将当前的name存入历史搜索中
    //3.同时将当前页面的tableview隐藏
    //4.并将下一页面显示
    [self deweightString:keyword];
    _tableView.hidden = YES;
    _resultView.keyword = keyword;
    [self.view addSubview:_resultView];
    [_resultView requestDataWhenLoaded:^{
        
    }];
    __weak __typeof(self) weakSelf = self;
    _resultView.passHomeModel = ^(SearchResultModel *model) {
        BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP499"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP299"] boolValue]);
        if (!isPay && model.pay) {
//            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
//            BOOL isLogin = dic;
//            if (isLogin) {
//                PurchaseViewController *vc = [PurchaseViewController new];
//                vc.isHideTab = weakSelf.isTabPage ? false : true;
//                [[PushHelper new] pushController:vc withOldController:weakSelf.navigationController andSetTabBarHidden:YES];
//            } else {
//                LoginViewController *vc = [LoginViewController new];
//                vc.isHide = weakSelf.isTabPage ? false : true;
//                [[PushHelper new] pushController:vc withOldController:weakSelf.navigationController andSetTabBarHidden:YES];
//            }
            PurchaseViewController *vc = [PurchaseViewController new];
            vc.isHideTab = weakSelf.isTabPage ? false : true;
            [[PushHelper new] pushController:vc withOldController:weakSelf.navigationController andSetTabBarHidden:YES];
        } else {
            PlayerViewController *vc = [[PlayerViewController alloc] init];
            BOOL hidden = weakSelf.isTabPage ? false : true;
            vc.isHideTabbar = hidden;
//            vc.model = model;
            vc.ID = [NSString stringWithFormat:@"%@",model.ID];
            [[PushHelper new] pushController:vc withOldController:weakSelf.navigationController andSetTabBarHidden:YES];
        }
    };
    
}

//点击搜索历史的clearBtn时，清空历史搜索
- (void) clearUser:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SearchHistory"];
        _tableView.tableHeaderView = nil;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotSearchTableViewCell" forIndexPath:indexPath];
    cell.model = _datas[indexPath.row];
    cell.indexLable.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    if (indexPath.row == 0) {
        cell.indexLable.backgroundColor = UIColorFromRGB(0xD0011B, 1.0);
    }
    else if(indexPath.row == 1) {
        cell.indexLable.backgroundColor = UIColorFromRGB(0xFF7800, 1.0);
    } else if (indexPath.row == 2) {
        cell.indexLable.backgroundColor = UIColorFromRGB(0xEED036, 1.0);
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model = _datas[indexPath.row];
    [self passKeywordToResultView:model.name];
    //点击item时:
    //1.将keyword传入到resuleView界面
    //后续逻辑由passKeywordToResultView方法去处理
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *hotSearchLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 20)];
    hotSearchLabel.text = @"热门搜索";
    hotSearchLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    hotSearchLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:hotSearchLabel];
    return headView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (void) setNav {
    self.nav = [[SearchNav alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavHeight)];
    _nav.inputTextField.delegate = self;
    _nav.inputTextField.returnKeyType = UIReturnKeySearch;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [_nav.cancelLabel addGestureRecognizer:tap];
    [self.view addSubview:_nav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    _nav.cancelLabel.hidden = _isTabPage ? true : false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BOOL hidden = _isTabPage ? false : true;
    [[self rdv_tabBarController] setTabBarHidden:hidden animated:YES];
}


//点击回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *inputString = textField.text;
    if (inputString.length < 1) {
        return YES;
    }
    [self passKeywordToResultView:inputString];
    return YES;
}

//处理用户输入的关键字,并存入历史搜索的数组中
- (void) deweightString:(NSString *)inputString {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"]];
//NSLog(@"改变之前%@",array);
    NSDictionary *dic = [self transformStringToDic:inputString];
    if (array.count == 0) {
        [array addObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchHistory"];
        return;
    }
    //去重
    BOOL isHaveSameString = false;
    for (int i = 0; i<array.count; i++) {
        if ([array[i][@"title"] isEqualToString:inputString]) {
            [array removeObjectAtIndex:i];
            isHaveSameString = true;
            break;
        }
    }
    if (isHaveSameString) {
        NSArray *orderArray = (NSArray *)[self upsidedown:array andAddObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:orderArray forKey:@"SearchHistory"];
        return;
    }
    //判断是否超过10个
    if (array.count >= 10) {
        [array removeObjectAtIndex:9];
        NSArray *orderArray = (NSArray *)[self upsidedown:array andAddObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:orderArray forKey:@"SearchHistory"];
        return;
    }
    NSArray *orderArray = (NSArray *)[self upsidedown:array andAddObject:dic];
    [[NSUserDefaults standardUserDefaults] setObject:orderArray forKey:@"SearchHistory"];
//NSLog(@"array-----%@",orderArray);
}

//将userDefault中的数据倒序
- (NSArray *) upsidedown :(NSArray *)array andAddObject:(NSDictionary *)dic {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    [tempArray addObject:dic];
    [tempArray addObjectsFromArray:array];
    return tempArray;
}

//将string变成dictionary
- (NSDictionary *) transformStringToDic:(NSString *)title {
    NSDictionary *dic = @{@"title":title};
    return dic;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nav.inputTextField resignFirstResponder];
}

- (void) goBack:(UITapGestureRecognizer *)tap {
    if (_isTabPage) {
        [_resultView removeFromSuperview];
        [self requestDataForHotSearch];
    } else {
        [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
    }
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}

@end
