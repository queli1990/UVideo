//
//  PerDownloadViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/21.
//  Copyright © 2018 li que. All rights reserved.
//

#import "PerDownloadViewController.h"
#import "XJALertView.h"
#import "NineBoxView.h"
#import "PerDownloadTableViewCell.h"
#import "HWDataBaseManager.h"
#import "CalculateView.h"
#import "NSMutableAttributedString+Color.h"
#import "UserActionRequest.h"
#import "SettingViewController.h"

@interface PerDownloadNavView : UIView
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation PerDownloadNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
        self.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backBtn);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(150, 24));
        }];
    }
    return self;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15, 20+(44-44)/2, 50, 44);
        CGFloat width = 22*0.8;
        CGFloat height = 36*0.8;
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake((44-height)/2, 0, (44-height)/2, 50-width);
        [_backBtn setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0xFFFFFF, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    }
    return _titleLabel;
}

@end


@interface TitleView : UIView
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *definitionLabel;
@property (nonatomic,strong) UIImageView *definitionImgView;
@property (nonatomic,strong) UIView *selecteView;
@end

@implementation TitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
        [self.selecteView addSubview:self.definitionLabel];
        [self.selecteView addSubview:self.definitionImgView];
        [self addSubview:self.selecteView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth*0.5, 20));
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(0);
        }];
        [self.selecteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 20));
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(0);
        }];
//        self.definitionLabel.preferredMaxLayoutWidth = 120;
        [self.definitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(0);
        }];
        [self.definitionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 7));
            make.centerY.mas_equalTo(self.definitionLabel);
            make.left.mas_equalTo(self.definitionLabel.mas_right).offset(0);
        }];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"当前清晰度：";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _nameLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

- (UIView *)selecteView {
    if (!_selecteView) {
        _selecteView = [[UIView alloc] init];
    }
    return _selecteView;
}

- (UILabel *)definitionLabel {
    if (!_definitionLabel) {
        _definitionLabel = [[UILabel alloc] init];
        _definitionLabel.textAlignment = NSTextAlignmentCenter;
        _definitionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _definitionLabel.textColor = UIColorFromRGB(0x0BBF06, 1.0);
        _definitionLabel.userInteractionEnabled = YES;
        //设置huggingPriority
//        [_definitionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _definitionLabel;
}

- (UIImageView *)definitionImgView {
    if (!_definitionImgView) {
        _definitionImgView = [[UIImageView alloc] init];
        _definitionImgView.image = [UIImage imageNamed:@"definitionIcon"];
        _definitionImgView.userInteractionEnabled = YES;
    }
    return _definitionImgView;
}

@end



@interface PerDownloadViewController () <SelectTypeDelegate,UITableViewDelegate,UITableViewDataSource,ClickDownloadBtnDelegate>
@property (nonatomic,strong) PerDownloadNavView *navView;
@property (nonatomic,strong) TitleView *titleView;
@property (nonatomic,strong) XJALertView *alert;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) NineBoxView *boxView;
@property (nonatomic,strong) UITableView *tableView;
// 获取所有预下载的文件的总大小
@property (nonatomic, assign) NSUInteger allOccupySize;
// 获取所有的已经下载了的文件大小
@property (nonatomic, assign) NSUInteger allTempSize;
// 存储进入页面时的剩余空间
@property (nonatomic, assign) NSUInteger leftSizeNum;
// 当前剧集已经在缓存列表的数量
@property (nonatomic, assign) NSUInteger currentDownloadCount;
@property (nonatomic,strong) CalculateView *calculateView;
@end

@implementation PerDownloadViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navView];
    _selectedIndex = 1000; // 默认值
    [self dealData];
    [self setupHeaderView];
    self.calculateView = [[CalculateView alloc] initWithFrame:CGRectMake(0, ScreenHeight-59, ScreenWidth, 59)];
    [self.view addSubview:self.calculateView];
    [self setupCalculateView];
    NSNumber *selectedIndex = [NSNumber numberWithLong:_selectedIndex];
    [[NSUserDefaults standardUserDefaults] setObject:selectedIndex forKey:@"definitionSelectedIndex"];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PerDownloadVCdownLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

// 状态改变
- (void)PerDownloadVCdownLoadStateChange:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;
    if (_type == 2 || _type == 5) {
        for (NineBoxDownloadBtn *btnView in self.boxView.subviews) {
            if ([btnView.model.fileName isEqualToString:downloadModel.fileName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    btnView.model = downloadModel;
                });
                break;
            }
        }
    }
    if (_type == 3 || _type == 4) {
        [self.datas enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.vid isEqualToString:downloadModel.vid]) {
                // 主线程更新cell进度
                dispatch_async(dispatch_get_main_queue(), ^{
                    PerDownloadTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                    [cell updateViewWithModel:downloadModel];
                });
                *stop = YES;
            }
        }];
    }
}

- (void) setupCalculateView {
    /// 剩余大小
    float freesize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    NSNumber *_free;
    if (dictionary) {
        _free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0;
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    NSInteger leftSize = _free.integerValue - _allOccupySize + _allTempSize;
    _leftSizeNum = leftSize;
    [self setCalculateViewLabelText];
}

- (void) setCalculateViewLabelText {
    float leftNum = [[NSNumber numberWithInteger:_leftSizeNum] unsignedIntegerValue] * 1.0;
    
    NSString *contentStr = [NSString stringWithFormat:@"%ld",_currentDownloadCount]; // 回复的内容
    NSString *replyNickName = @"已缓存文件："; // 回复某个评论的userName
    NSString *combinStr = [NSString stringWithFormat:@"%@%@",replyNickName,contentStr];
    NSMutableAttributedString *indroStr1 = [NSMutableAttributedString setupAttributeString:combinStr rangeText:contentStr textColor:UIColorFromRGB(0x0BBF06, 1.0)];
    
    _calculateView.topLabel.attributedText = indroStr1;
    _calculateView.leftLabel.text = [NSString stringWithFormat:@"剩余:%.1f GB",(leftNum/1024/1024/1024)];
}

- (void) setupHeaderView {
    if (self.vimeoDataDic.allKeys.count) {
        NSArray *files = _vimeoDataDic[@"files"];
        self.titleView.definitionLabel.text = [NSString stringWithFormat:@"%@",[files[0] objectForKey:@"height"]];
    } else {
        NSArray *files = [self sortArray:[_vimeoDataArray[0] objectForKey:@"files"]];
        self.titleView.definitionLabel.text = [NSString stringWithFormat:@"%@",[files[0] objectForKey:@"height"]];
    }
    [self.view addSubview:self.titleView];
    
    if (_type == 2 || _type == 5) {     //  方框 -- view        电视剧=2    动漫=5
        [self initNineBox];
    } else {                            //  横条 -- tableView   综艺=4      电影=3
        [self initCell];
        if (_type == 3) {
//            [self.datas addObject:self.vimeoDataDic];
            HWDownloadModel *model = [[HWDownloadModel alloc] init];
            model.fileName = self.vimeoDataDic[@"name"];
            model.vid = [NSString stringWithFormat:@"%@-%d",_ID,1];
            NSArray *pictures = [_vimeoDataDic objectForKey:@"pictures"];
            model.imageURL = [pictures[2] objectForKey:@"link"];
            NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
            for (HWDownloadModel *downloadModel in cacheData) {
                _allOccupySize += downloadModel.totalFileSize;
                if (downloadModel.state != HWDownloadStateFinish) {
                    _allTempSize += downloadModel.tmpFileSize;
                }
                if ([model.vid isEqualToString:downloadModel.vid]) {
                    model.state = downloadModel.state;
                    _currentDownloadCount += 1;
                    NSLog(@"已经在下载列表中了:%@--%ld",downloadModel.fileName,(long)downloadModel.state);
                }
            }
            NSArray *sortArray = [self sortArray:_vimeoDataDic[@"files"]];
            model.url = [sortArray[_selectedIndex-1000] objectForKey:@"link"];
            [self.datas addObject:model];
        } else {
//            self.datas = [NSMutableArray arrayWithArray:_vimeoDataArray];
            NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];

            for (HWDownloadModel *downloadModel in cacheData) {
                _allOccupySize += downloadModel.totalFileSize;
                if (downloadModel.state != HWDownloadStateFinish) {
                    _allTempSize += downloadModel.tmpFileSize;
                }
            }
            
            for (int i = 0; i < _vimeoDataArray.count; i++) {
                HWDownloadModel *model = [[HWDownloadModel alloc] init];
                model.fileName = [_vimeoDataArray[i] objectForKey:@"name"];
                model.vid = [NSString stringWithFormat:@"%@-%d",_ID,i+1];
                NSArray *pictures = [_vimeoDataArray[i] objectForKey:@"pictures"];
                model.imageURL = [pictures[2] objectForKey:@"link"];
                for (HWDownloadModel *downloadModel in cacheData) {
                    if ([model.vid isEqualToString:downloadModel.vid]) {
                        model.state = downloadModel.state;
                        _currentDownloadCount += 1;
                        NSLog(@"已经在下载列表中了:%@--%ld",downloadModel.fileName,(long)downloadModel.state);
                    }
                }
                [self.datas addObject:model];
            }
        }
    }
}

// 正方形
- (void) initNineBox {
    CGFloat totalHeight ;
    CGFloat leftGap = 15; // 最左边和最右边的间距
    CGFloat horizontalGap = 20; // 两个item之间水平的间距
    CGFloat verticalGap = 14; // 两个item之间竖直的间距
    CGFloat itemHeight = (ScreenWidth - leftGap*2 - (5-1)*horizontalGap) / 5;
    if (_vimeoDataArray.count % 5 == 0) {
        totalHeight = 20 + _vimeoDataArray.count/5 * (itemHeight + verticalGap) ;
    } else {
        totalHeight = 20 + (_vimeoDataArray.count/5 + 1) * (itemHeight + verticalGap) ;
    }
    
    self.boxView = [[NineBoxView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, totalHeight)];
    _boxView.delegate = self;
    NSDictionary *params = [_boxView setupViewWithArray:_vimeoDataArray episodeID:self.ID];
    
    _allOccupySize = [[params objectForKey:@"allOccupySize"] integerValue];
    _allTempSize = [[params objectForKey:@"allTempSize"] integerValue];
    _currentDownloadCount = [[params objectForKey:@"currentDownloadCount"] integerValue];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40, ScreenWidth, ScreenHeight-64-40-60)];
    scrollView.contentSize = CGSizeMake(ScreenWidth, totalHeight);
    [scrollView addSubview:_boxView];
    [self.view addSubview:scrollView];
}

// 判断当前是否为4G，并且不允许4G网络下载
- (void) showCellularAccessOrNetworkingReachability {
    //    AFNetworkReachabilityStatusUnknown          = -1,
    //    AFNetworkReachabilityStatusNotReachable     = 0,
    //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
    if (!([[HWNetworkReachabilityManager shareManager] networkReachabilityStatus] == AFNetworkReachabilityStatusReachableViaWiFi)) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:HWDownloadAllowsCellularAccessKey]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\"允许非WiFi网络下载\"已关闭" message:@"请前往\"我的\"-\"系统设置\"中手动开启\"允许非WiFi网络下载\"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SettingViewController *vc = [SettingViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:defaultAction];
            [alert addAction:cancleAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark -- 选中正方形的view中btn的点击事件
// 此处的btn其实是个view
- (void)selectBtn:(NineBoxDownloadBtn *)btn withArray:(nonnull NSArray *)array {
    if (_leftSizeNum < btn.model.totalFileSize) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"空间不足，请清理空间再试"];
        [alert show:^{
            
        }];
        return;
    }
    NSDictionary *albumEpisodes = @{@"episode":[NSNumber numberWithInteger:btn.tag-1000],
                                    @"success":@0};
    NSArray *tempArray = [NSArray arrayWithObject:albumEpisodes];
    NSDictionary *params = @{@"deviceId":[YDDevice getUQID],
                             @"albumId":[NSNumber numberWithInteger:[self.model.ID integerValue]],
                             @"albumName":self.model.name,
                             @"albumEpisodes":tempArray,
                             @"platform":@"ios"};
    [UserActionRequest postDownload:params complent:^(NSDictionary * _Nonnull dic) {
        NSLog(@"上传下载数据 -- %@",dic);
    }];
    
    if (btn.model.state == HWDownloadStateDefault || btn.model.state == HWDownloadStatePaused || btn.model.state == HWDownloadStateError) {
        // 点击默认、暂停、失败状态，调用开始下载
        [[HWDownloadManager shareManager] startDownloadTask:btn.model];
        [self showCellularAccessOrNetworkingReachability];
    } else if (btn.model.state == HWDownloadStateDownloading || btn.model.state == HWDownloadStateWaiting) {
        // 点击正在下载、等待状态，调用暂停下载
        [[HWDownloadManager shareManager] pauseDownloadTask:btn.model];
    }

    _currentDownloadCount += 1;
    _leftSizeNum -= btn.model.totalFileSize;
    [self setCalculateViewLabelText];
    
    // 用于存储文件夹
    NSString *folderImage = self.model.landscape_poster_s;
    NSString *folderName = self.model.name;
    NSArray *folders = [[NSUserDefaults standardUserDefaults] objectForKey:@"folders"];
    if (!folders) {
        folders = [NSArray array];
    }
    BOOL exist = NO;
    for (NSDictionary *tempDic in folders) {
        if ([tempDic[@"identifier"] isEqualToString:self.ID]) {
            exist = YES;
            break;
        }
    }
    if (!exist) {
        NSDictionary *folderDic = @{@"identifier":self.ID,@"folderName":folderName,@"folderImage":folderImage};
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:folders];
        [tempArray insertObject:folderDic atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)tempArray forKey:@"folders"];
    }
}

// tableView
- (void) initCell {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, ScreenWidth, ScreenHeight-64-40-60) style:UITableViewStylePlain];
    [tableView registerClass:[PerDownloadTableViewCell class] forCellReuseIdentifier:@"PerDownloadTableViewCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark -- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PerDownloadTableViewCell *cell = [PerDownloadTableViewCell cellWithTableView:tableView];
    cell.model = self.datas[indexPath.row];
    // 禁止cell点击选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取已缓存数据
    PerDownloadTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    NSDictionary *tempDic = _vimeoDataArray[indexPath.row];
    if (_type == 3) { // 电影
        NSArray *sortArray = [self sortArray:_vimeoDataDic[@"files"]];
        cell.model.url = [sortArray[_selectedIndex-1000] objectForKey:@"link"];
        NSUInteger totalSize = [[sortArray[_selectedIndex-1000] objectForKey:@"size"] integerValue];
        cell.model.totalFileSize = totalSize;
    } else if (_type == 4) { // 综艺
        NSArray *sortArray = [self sortArray:tempDic[@"files"]];
        cell.model.url = [sortArray[_selectedIndex-1000] objectForKey:@"link"];
        NSUInteger totalSize = [[sortArray[_selectedIndex-1000] objectForKey:@"size"] integerValue];
        cell.model.totalFileSize = totalSize;
    }
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    for (HWDownloadModel *downloadModel in cacheData) {
        if ([downloadModel.vid isEqualToString:cell.model.vid]) {
            cell.model = downloadModel;
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"已添加下载"];
            [alert show:^{
                
            }];
            return;
        }
    }
    if (_leftSizeNum < cell.model.totalFileSize) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"空间不足，请清理空间再试"];
        [alert show:^{
            
        }];
        return;
    }
    _currentDownloadCount += 1;
    _leftSizeNum -= cell.model.totalFileSize;
    [self setCalculateViewLabelText];
    
    if (cell.model.state == HWDownloadStateDefault || cell.model.state == HWDownloadStatePaused || cell.model.state == HWDownloadStateError) {
        // 点击默认、暂停、失败状态，调用开始下载
        [[HWDownloadManager shareManager] startDownloadTask:cell.model];
        [self showCellularAccessOrNetworkingReachability];
    } else if(cell.model.state == HWDownloadStateDownloading || cell.model.state == HWDownloadStateWaiting) {
        // 点击正在下载、等待状态，调用暂停下载
        [[HWDownloadManager shareManager] pauseDownloadTask:cell.model];
    }
    // 用于存储文件夹
    NSString *folderImage = self.model.landscape_poster_s;
    NSString *folderName = self.model.name;
    NSArray *folders = [[NSUserDefaults standardUserDefaults] objectForKey:@"folders"];
    if (!folders) {
        folders = [NSArray array];
    }
    BOOL exist = NO;
    for (NSDictionary *tempDic in folders) {
        if ([tempDic[@"identifier"] isEqualToString:self.ID]) {
            exist = YES;
            break;
        }
    }
    if (!exist) {
        NSDictionary *folderDic = @{@"identifier":self.ID,@"folderName":folderName,@"folderImage":folderImage};
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:folders];
        [tempArray insertObject:folderDic atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)tempArray forKey:@"folders"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}


- (void) dealData  {
    if (self.type == 3) { // 电影 -- 字典
        NSArray *sortArray = [self sortArray:self.vimeoDataDic[@"files"]];
        [self.vimeoDataDic removeObjectForKey:@"files"];
        [self.vimeoDataDic setValue:sortArray forKey:@"files"];
    } else { // 电视剧等 -- 数组
        
    }
}

- (NSArray *) sortArray:(NSMutableArray *)tempArray {
    for (int i = 0; i < tempArray.count; i++) {
        if ([[tempArray[i] objectForKey:@"quality"] isEqualToString:@"hls"]) {
            [tempArray removeObject:tempArray[i]];
        }
    }
    [tempArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
     {
         //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
         if ([obj1[@"height"] integerValue] > [obj2[@"height"] integerValue]){
             return NSOrderedDescending;
         } else {
             return NSOrderedAscending;
         }
     }];
    return tempArray;
}

- (void) showSheet:(UITapGestureRecognizer *)tap {
    NSDictionary *definitionDic;
    if (self.type == 3) { // 电影
        definitionDic = self.vimeoDataDic;
    } else {
        definitionDic = self.vimeoDataArray[0];
    }
    self.alert.currentIndex = _selectedIndex;
    [self.alert setupArrayView:definitionDic[@"files"]];
    [self.alert showAlert];
    self.alert.delegate = self;
}

#pragma mark -- 选中清晰度时候的按钮回调事件
- (void)selectedBtn:(UIButton *)btn {
    _selectedIndex = btn.tag;
    NSNumber *selectedIndex = [NSNumber numberWithLong:_selectedIndex];
    [[NSUserDefaults standardUserDefaults] setObject:selectedIndex forKey:@"definitionSelectedIndex"];
    self.titleView.definitionLabel.text = btn.titleLabel.text;
    [self.alert dismissAlert];
}

- (XJALertView *)alert {
    if (!_alert) {
        _alert = [[XJALertView alloc] initWithFrame:self.view.bounds];
        _alert.delegate = self;
    }
    return _alert;
}

- (TitleView *)titleView {
    if (!_titleView) {
        _titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 60)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheet:)];
        [_titleView.selecteView addGestureRecognizer:tap];
    }
    return _titleView;
}

- (PerDownloadNavView *)navView {
    if (!_navView) {
        _navView = [[PerDownloadNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navView.titleLabel.text = @"选择缓存的集数";
        [_navView.backBtn bk_addEventHandler:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _navView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _datas;
}

@end
