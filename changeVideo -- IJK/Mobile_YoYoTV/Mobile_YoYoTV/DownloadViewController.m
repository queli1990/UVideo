//
//  DownloadViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/21.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadViewController.h"
#import "EditNavView.h"
#import "DownloadTableViewCell.h"
#import "BottomDeleteView.h"

@interface DownloadViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) EditNavView *nav;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<HWDownloadModel *> *dataSource;
@property (nonatomic,strong) BottomDeleteView *deleteView;
@end

@implementation DownloadViewController


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self prepareData];
    [self.view addSubview:self.tableView];
    [self addNotification];
    [self.view addSubview:self.deleteView];
}

- (void) prepareData {
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    if (cacheData.count) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < cacheData.count; i++) {
            HWDownloadModel *model = cacheData[i];
            if (model.state != HWDownloadStateFinish) {
                [tempArray addObject:model];
            }
        }
        self.dataSource = tempArray;
    } else {
        NSLog(@"没有需要下载的数据");
    }
}

- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVCdownLoadProgress:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVCdownLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell *cell = [DownloadTableViewCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (cell.model.state == HWDownloadStateDownloading) {
        if (!cell.model.speed || cell.model.speed <= 0) {
            cell.speedLabel.text = @"0 KB / s";
            cell.speedLabel.textColor = UIColorFromRGB(0x808080, 1.0);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        if (indexPaths.count > 0) [_deleteView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", indexPaths.count] forState:UIControlStateNormal];
        if (indexPaths.count == self.dataSource.count) [_deleteView.allSelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    } else {
        HWDownloadModel *model = self.dataSource[indexPath.row];
//        DownloadTableViewCell *cell = [DownloadTableViewCell cellWithTableView:tableView];
        if (model.state == HWDownloadStateDefault || model.state == HWDownloadStatePaused || model.state == HWDownloadStateError) {
            // 点击默认、暂停、失败状态，调用开始下载
            [[HWDownloadManager shareManager] startDownloadTask:model];
            //        cell.speedLabel.text = @"等待缓存";
        } else if (model.state == HWDownloadStateDownloading || model.state == HWDownloadStateWaiting) {
            // 点击正在下载、等待状态，调用暂停下载
            [[HWDownloadManager shareManager] pauseDownloadTask:model];
            //        cell.speedLabel.text = @"已暂停";
        }
    }
}

- (void) setupNav {
    self.nav = [[EditNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [_nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    _nav.titleLabel.text = @"正在下载";
    [_nav.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}

- (void) edit:(UIButton *)btn {
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    // 左滑cell至出现删除按钮状态和调用“setEditing: animated:”方法使所有cell进入编辑状态，tableView的editing属性都为YES，所以当一个cell处于左滑编辑状态时，点击导航删除按钮想使所有cell进入编辑状态，需要先取消一次tableView的编辑状态
    if (!btn.selected && _tableView.isEditing) [_tableView setEditing:NO animated:YES];
    btn.selected = !btn.selected;
    
    [_tableView setEditing:!_tableView.editing animated:YES];
    
    if (!btn.selected) {
        [self cancelAllSelect];
        _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    } else {
        _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49);
    }
    
    CGFloat tabbarY = btn.selected ? ScreenHeight - 49 : ScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        _deleteView.frame = CGRectMake(0, tabbarY, ScreenWidth, 49);
    }];
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downloadVCdownLoadProgress:(NSNotification *)notification {
    HWDownloadModel *downloadModel = notification.object;
    
    [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                DownloadTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [cell updateViewWithModel:downloadModel];
            });
            
            *stop = YES;
        }
    }];
}

// 状态改变
- (void)downloadVCdownLoadStateChange:(NSNotification *)notification {
    
    HWDownloadModel *downloadModel = notification.object;
    // 如果有出错的情况要处理
    if (downloadModel.state == HWDownloadStateError) {
        
    }
    
    dispatch_queue_t queue = dispatch_queue_create("FinishViewControllerQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
//        NSLog(@"DownloadViewController ---- global_queue -- %@ ---- %ld",downloadModel.fileName,downloadModel.state);
        [self prepareData];
//        sleep(0.5);
//        usleep(50000);
        if (self.dataSource.count) {
            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSLog(@"DownloadViewController ---- main_queue -- %@",[NSThread currentThread]);
//                NSLog(@"dataSource:%ld",_dataSource.count);
                [self.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"需要切换到主线程返回上级页面 ---- %@",[NSThread currentThread]);
                [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:YES];
            });
        }
    });
}

- (void)cancelAllSelect {
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HWDownloadModel *model = self.dataSource[indexPath.row];
    [self deleteRowAtIndex:indexPath.row];
    [self reloadNavRightBtn];
    [[HWDownloadManager shareManager] deleteTaskAndCache:model];
}

- (void)deleteRowAtIndex:(NSInteger)index {
    [self.dataSource removeObjectAtIndex:index];
    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BottomDeleteView *)deleteView {
    if (!_deleteView) {
        _deleteView = [[BottomDeleteView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 49)];
        _deleteView.backgroundColor = [UIColor whiteColor];
        @weakify(self)
        [_deleteView.allSelBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if ([self.deleteView.allSelBtn.titleLabel.text isEqualToString:@"全选"]) {
                // 全选
                for (int i = 0; i < self.dataSource.count; i ++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                [self.deleteView.allSelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
                [self.deleteView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", self.dataSource.count] forState:UIControlStateNormal];
            } else {
                [self cancelAllSelect];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [_deleteView.deleteBtn addTarget:self action:@selector(deleteMehtod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteView;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        NSString *deleteBtnTitle = indexPaths.count > 0 ? [NSString stringWithFormat:@"删除(%ld)", indexPaths.count] : @"删除";
        [_deleteView.deleteBtn setTitle:deleteBtnTitle forState:UIControlStateNormal];
        if (indexPaths.count < self.dataSource.count) [_deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

// 删除
- (void) deleteMehtod:(UIButton *)btn {
    NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [indexes addIndex:indexPath.row];
        [[HWDownloadManager shareManager] deleteTaskAndCache:self.dataSource[indexPath.row]];
    }
    [self.dataSource removeObjectsAtIndexes:indexes];
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [_deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    if (self.dataSource.count == 0) [_deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self edit:_nav.editBtn]; // 将底部的隐藏，同时右上角变为非选中状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadNavRightBtn];
    });
}

- (void) reloadNavRightBtn {
    _nav.editBtn.hidden = self.dataSource.count == 0 ? YES : NO;
}

- (NSMutableArray<HWDownloadModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end
