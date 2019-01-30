//
//  DownloadFinishViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadFinishViewController.h"
#import "EditNavView.h"
#import "DownloadTopTableViewCell.h"
#import "DownloadFinishTableViewCell.h"
#import "DownloadViewController.h"
#import "FolderViewController.h"
#import "BottomDeleteView.h"
#import "NoRecordView.h"

@interface DownloadFinishViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) EditNavView *nav;
@property (nonatomic,strong) NSMutableArray *unfinishDatas;
@property (nonatomic,strong) NSMutableArray *finishDatas;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BottomDeleteView *deleteView;
@property (nonatomic,strong) NoRecordView *noResultView;
@end

@implementation DownloadFinishViewController


- (void)dealloc {}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareData];
    [self.tableView reloadData];
    [self addNotification];
    [self reloadNavRightBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self initTableView];
    // 添加底部的删除按钮
    [self.view addSubview:self.deleteView];
    [self initNoResultView];
}

- (void) prepareData {
    NSMutableArray *tempUnfinishDatas = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempFinishFolders = [NSMutableArray arrayWithCapacity:0];

    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    NSMutableArray *folders = [[NSUserDefaults standardUserDefaults] objectForKey:@"folders"];
    
    for (int j = 0; j < folders.count; j++) {
        NSString *genreID = [folders[j] objectForKey:@"identifier"];
        NSInteger count = 0;
        BOOL exist = NO;
        for (int i = 0; i < cacheData.count; i++) {
            HWDownloadModel *model = cacheData[i];
            if (model.state == HWDownloadStateFinish) {
                NSArray *strArray = [model.vid componentsSeparatedByString:@"-"];
                if ([strArray[0] isEqualToString:genreID]) { // 放入当前专辑
                    count ++;
                    if (!exist) {
                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:folders[j]];
                        [tempFinishFolders addObject:tempDic];
                        exist = YES;
                    }
                }
            } else {
                [tempUnfinishDatas addObject:model];
            }
        }
        if ([tempFinishFolders lastObject] && count > 0) {
            [[tempFinishFolders lastObject] setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"finishCount"];
        }
    }
    self.finishDatas = tempFinishFolders;
    self.unfinishDatas = tempUnfinishDatas;
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80.f;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)addNotification {
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishVCdownLoadProgress:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishVCdownLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.unfinishDatas.count) {
        return 1 + self.finishDatas.count;
    } else {
        return self.finishDatas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.unfinishDatas.count && indexPath.row == 0) {
        DownloadTopTableViewCell *cell = [DownloadTopTableViewCell cellWithTableView:tableView];
//        cell.model = nil;
        for (int i = 0; i < self.unfinishDatas.count; i++) {
            HWDownloadModel *model = _unfinishDatas[i];
            if (model.state == HWDownloadStateDownloading) {
                cell.model = model;
            }
        }
        cell.speedLabel.text = cell.model ? @"" : @"已暂停";
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    } else {
        DownloadFinishTableViewCell *cell = [DownloadFinishTableViewCell cellWithTableView:tableView];
        NSDictionary *folderDic;
        // 如果有顶部的cell，则这里需要-1，不然会crash
        if (self.unfinishDatas.count) {
            folderDic = self.finishDatas[indexPath.row - 1];
        } else {
            folderDic = self.finishDatas[indexPath.row];
        }
        NSDictionary *dic = @{@"fileName":folderDic[@"folderName"],@"totalFileSize":@"",@"imageURL":folderDic[@"folderImage"],@"finishCount":folderDic[@"finishCount"]};
        cell.modelDic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) { // 编辑状态下
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        if (indexPaths.count > 0) [_deleteView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)", (unsigned long)indexPaths.count] forState:UIControlStateNormal];
        CGFloat totalCount = self.unfinishDatas.count ? 1 + self.finishDatas.count : self.finishDatas.count;
        if (indexPaths.count == totalCount) [_deleteView.allSelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    } else {
        if (self.unfinishDatas.count && indexPath.row == 0) {
            DownloadViewController *vc = [DownloadViewController new];
            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
        } else {
            NSDictionary *dic ;
            if (self.unfinishDatas.count) {
                dic = self.finishDatas[indexPath.row - 1];
            } else {
                dic = self.finishDatas[indexPath.row];
            }
            FolderViewController *vc = [FolderViewController new];
            vc.identifier = dic[@"identifier"];
            vc.folderName = dic[@"folderName"];
            [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        NSString *deleteBtnTitle = indexPaths.count > 0 ? [NSString stringWithFormat:@"删除(%lu)", (unsigned long)indexPaths.count] : @"删除";
        [_deleteView.deleteBtn setTitle:deleteBtnTitle forState:UIControlStateNormal];
        CGFloat totalCount = self.unfinishDatas.count ? 1 + self.finishDatas.count : self.finishDatas.count;
        if (indexPaths.count < totalCount) [_deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downloadFinishVCdownLoadProgress:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;

    [self.unfinishDatas enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                DownloadTopTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell updateViewWithModel:downloadModel];
            });

            *stop = YES;
        }
    }];
}

// 状态改变
- (void)downloadFinishVCdownLoadStateChange:(NSNotification *)notification {
//    HWDownloadModel *downloadModel = notification.object;
    dispatch_queue_t queue = dispatch_queue_create("FinishViewStateChangeControllerQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
//        NSLog(@"FinishViewController ---- global_queue -- %@ -- %ld",downloadModel.fileName,downloadModel.state);
        [self prepareData];
        sleep(1);
        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"FinishViewController ---- main_queue -- %@ -- %ld",downloadModel.fileName,downloadModel.state);
//            NSLog(@"unfinishDatas:%lu ---- finishDatas:%lu",(unsigned long)_unfinishDatas.count,(unsigned long)_finishDatas.count);
            [self.tableView reloadData];
        });
    });
}

- (void) setupNav {
    self.nav = [[EditNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [_nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    _nav.titleLabel.text = @"离线缓存";
    [_nav.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}

- (void) edit:(UIButton *)btn {
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    
    // 左滑cell至出现删除按钮状态和调用“setEditing: animated:”方法使所有cell进入编辑状态，tableView的editing属性都为YES，所以当一个cell处于左滑编辑状态时，点击导航删除按钮想使所有cell进入编辑状态，需要先取消一次tableView的编辑状态
    if (!btn.selected && _tableView.isEditing) [_tableView setEditing:NO animated:YES];
    btn.selected = !btn.selected;
    
    [_tableView setEditing:!_tableView.editing animated:YES];
    
    if (!btn.selected) [self cancelAllSelect];
    
    CGFloat tabbarY = btn.selected ? ScreenHeight - 49 : ScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        _deleteView.frame = CGRectMake(0, tabbarY, ScreenWidth, 49);
    }];
}

- (void)cancelAllSelect {
    CGFloat totalCount = self.unfinishDatas.count ? 1 + self.finishDatas.count : self.finishDatas.count;
    for (int i = 0; i < totalCount; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.unfinishDatas.count > 0) { // 删除下载队列中的任务
        for (int i = 0; i < self.unfinishDatas.count; i++) {
            HWDownloadModel *model = self.unfinishDatas[i];
//            NSLog(@"删除下载队列中的----%@",model.fileName);
            [[HWDownloadManager shareManager] deleteTaskAndCache:model];
        }
        self.unfinishDatas = nil;
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else { // 删除文件夹
        NSInteger currentIndex = self.unfinishDatas.count ? indexPath.row - 1 : indexPath.row;
        NSDictionary *folderDic = self.finishDatas[currentIndex];
        
        NSString *identifierStr = folderDic[@"identifier"];
        NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
        int count = 0; // 未下载完成的个数
        for (int i = 0; i < cacheData.count; i++) {
            HWDownloadModel *model = cacheData[i];
            NSArray *strArray = [model.vid componentsSeparatedByString:@"-"];
            if ([strArray[0] isEqualToString:identifierStr]) { // 放入当前专辑
                if (model.state == HWDownloadStateFinish) {
                    [[HWDownloadManager shareManager] deleteTaskAndCache:model];
//                    NSLog(@"要删除----%@",model.fileName);
                } else {
                    count ++;
                }
            }
        }
        [self.finishDatas removeObject:folderDic];
        if (count == 0) {
            // 将本地userDefault里面的文件夹删除
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:self.finishDatas] forKey:@"folders"];
        }
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self reloadNavRightBtn];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BottomDeleteView *)deleteView {
    if (!_deleteView) {
        _deleteView = [[BottomDeleteView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 49)];
        @weakify(self)
        _deleteView.backgroundColor = [UIColor whiteColor];
        [_deleteView.allSelBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if ([self.deleteView.allSelBtn.titleLabel.text isEqualToString:@"全选"]) {
                CGFloat totalCount = self.unfinishDatas.count ? 1 + self.finishDatas.count : self.finishDatas.count;
                for (int i = 0; i < totalCount; i ++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                [self.deleteView.allSelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
                [self.deleteView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)", (unsigned long)self.finishDatas.count] forState:UIControlStateNormal];
            } else {
                [self cancelAllSelect];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [_deleteView.deleteBtn addTarget:self action:@selector(deleteMehtod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteView;
}

// 删除的方法实现
- (void) deleteMehtod:(UIButton *)btn {
    [SVProgressHUD show];
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    NSMutableArray *tempFiles = [NSMutableArray arrayWithArray:self.finishDatas];
    NSMutableArray *tempFolders = [NSMutableArray arrayWithArray:self.finishDatas];
    for ( int j = 0; j < indexPaths.count; j++) {
        NSIndexPath *indexPath = indexPaths[j];
        if (indexPath.row == 0 && self.unfinishDatas.count > 0) { // 删除下载中的文件
            [indexes addIndex:indexPath.row];
            for (int i = 0; i < self.unfinishDatas.count; i++) {
                HWDownloadModel *model = self.unfinishDatas[i];
//                NSLog(@"删除下载队列中的----%@",model.fileName);
                [[HWDownloadManager shareManager] deleteTaskAndCache:model];
            }
            self.unfinishDatas = nil;
        } else { // 删除下载完成的文件夹
            NSInteger currentIndex = self.unfinishDatas.count ? indexPath.row - 1 : indexPath.row;
            [indexes addIndex:currentIndex];
            NSDictionary *folderDic = self.finishDatas[currentIndex];
            
            NSString *identifierStr = folderDic[@"identifier"];
            NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
            int count = 0; // 未下载完成的个数
            for (int i = 0; i < cacheData.count; i++) {
                HWDownloadModel *model = cacheData[i];
                NSArray *strArray = [model.vid componentsSeparatedByString:@"-"];
                if ([strArray[0] isEqualToString:identifierStr]) {
                    if (model.state == HWDownloadStateFinish) { // 放入当前专辑
                        [[HWDownloadManager shareManager] deleteTaskAndCache:model];
//                        NSLog(@"要删除----%@",model.fileName);
                    } else {
                        count ++;
                    }
                }
            }
            [tempFiles removeObject:folderDic];
            if (count == 0) {
                // 将本地userDefault里面的文件夹删除
                [tempFolders removeObject:folderDic];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:tempFolders] forKey:@"folders"];
    self.finishDatas = tempFiles;
    // 删除对应的row
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [SVProgressHUD dismiss];
    [_deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self edit:_nav.editBtn]; // 将底部的隐藏，同时右上角变为非选中状态
    [self reloadNavRightBtn];
}

- (void) reloadNavRightBtn {
    if (self.unfinishDatas.count == 0 && self.finishDatas.count == 0) {
        _nav.editBtn.hidden = YES;
        _noResultView.hidden = NO;
    } else {
        _nav.editBtn.hidden = NO;
        _noResultView.hidden = YES;
    }
}

- (void) initNoResultView {
    self.noResultView = [[NoRecordView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    _noResultView.alertLabel.text = @"暂未缓存，快去缓存你喜欢的影片吧";
    [self.view addSubview:_noResultView];
    _noResultView.hidden = YES;
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

- (NSMutableArray *)unfinishDatas {
    if (!_unfinishDatas) {
        _unfinishDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _unfinishDatas;
}

- (NSMutableArray *)finishDatas {
    if (!_finishDatas) {
        _finishDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _finishDatas;
}


@end
