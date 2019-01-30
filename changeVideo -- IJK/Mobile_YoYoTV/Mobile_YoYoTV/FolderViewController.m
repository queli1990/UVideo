//
//  FolderViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/4.
//  Copyright © 2018 li que. All rights reserved.
//

#import "FolderViewController.h"
#import "WatchDownloadVideoViewController.h"
#import "DownloadFinishTableViewCell.h"
#import "EditNavView.h"
#import "BottomDeleteView.h"

@interface FolderViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) EditNavView *nav;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BottomDeleteView *deleteView;
@end

@implementation FolderViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self initTableView];
    // 添加底部的删除按钮
    [self.view addSubview:self.deleteView];
    [self prepareData];
    [self addNotification];
    [self reloadNavRightBtn];
    [self.tableView reloadData];
}

- (void) prepareData {
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < cacheData.count; i++) {
        HWDownloadModel *model = cacheData[i];
        if (model.state == HWDownloadStateFinish) {
            NSArray *strArray = [model.vid componentsSeparatedByString:@"-"];
            if ([strArray[0] isEqualToString:self.identifier]) { // 放入当前专辑
                [tempArray addObject:model];
            }
        }
    }
    self.dataSource = [self sortArray:tempArray];
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

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadFinishTableViewCell *cell = [DownloadFinishTableViewCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HWDownloadModel *model = self.dataSource[indexPath.row];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self reloadNavRightBtn];
    [[HWDownloadManager shareManager] deleteTaskAndCache:model];
    if (self.dataSource.count == 0) {
        [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) { // 编辑状态下
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        if (indexPaths.count > 0) [_deleteView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", indexPaths.count] forState:UIControlStateNormal];
        if (indexPaths.count == self.dataSource.count) [_deleteView.allSelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    } else {
        WatchDownloadVideoViewController *vc = [WatchDownloadVideoViewController new];
        HWDownloadModel *model = self.dataSource[indexPath.row];
        vc.videoName = model.fileName;
        vc.localPath = model.localPath;
        vc.model = model;
        [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
        NSString *deleteBtnTitle = indexPaths.count > 0 ? [NSString stringWithFormat:@"删除(%ld)", indexPaths.count] : @"删除";
        [_deleteView.deleteBtn setTitle:deleteBtnTitle forState:UIControlStateNormal];
        if (indexPaths.count < self.dataSource.count) [_deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void) reloadNavRightBtn {
    _nav.editBtn.hidden = self.dataSource.count == 0 ? YES : NO;
}

- (void)addNotification {
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(folderVCdownLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

// 状态改变
- (void)folderVCdownLoadStateChange:(NSNotification *)notification {
//    HWDownloadModel *downloadModel = notification.object;
    dispatch_queue_t queue = dispatch_queue_create("FinishViewControllerQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self prepareData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self reloadNavRightBtn];
        });
    });
}

- (void) setupNav {
    self.nav = [[EditNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [_nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    _nav.titleLabel.text = self.folderName;
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
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.deleteView.allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
}

- (void) goPlayer {
//    WatchDownloadVideoViewController *vc = [WatchDownloadVideoViewController new];
//    HWDownloadModel *model ;
//    if (self.unfinishDatas.count) {
//        model = self.finishDatas[indexPath.row - 1];
//    } else {
//        model = self.finishDatas[indexPath.row];
//    }
//    vc.videoName = model.fileName;
//    vc.localPath = model.localPath;
//    [[PushHelper new] pushController:vc withOldController:self.navigationController andSetTabBarHidden:YES];
}

- (BottomDeleteView *)deleteView {
    if (!_deleteView) {
        _deleteView = [[BottomDeleteView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 49)];
        @weakify(self)
        [_deleteView.allSelBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if ([self.deleteView.allSelBtn.titleLabel.text isEqualToString:@"全选"]) {
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

// 删除的方法实现
- (void) deleteMehtod:(UIButton *)btn {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [indexes addIndex:indexPath.row];
        NSLog(@"%ld",indexPath.row);
        HWDownloadModel *model = self.dataSource[indexPath.row];
        [[HWDownloadManager shareManager] deleteTaskAndCache:model];
    }
    [_deleteView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self edit:_nav.editBtn]; // 将底部的隐藏，同时右上角变为非选中状态
    dispatch_queue_t queue = dispatch_queue_create("FinishViewControllerQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self prepareData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self reloadNavRightBtn];
        });
    });
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:YES];
}

// 数组排序
- (NSMutableArray *) sortArray:(NSMutableArray *)tempArray {
    [tempArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
     {
         //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从小到大排列）
         HWDownloadModel *model1 = (HWDownloadModel *)obj1;
         HWDownloadModel *model2 = (HWDownloadModel *)obj2;
         NSArray *strArray1 = [model1.vid componentsSeparatedByString:@"-"];
         NSArray *strArray2 = [model2.vid componentsSeparatedByString:@"-"];
         NSInteger value1 = [strArray1[1] integerValue];
         NSInteger value2 = [strArray2[1] integerValue];
         if (value1 > value2){
             return NSOrderedDescending;
         } else {
             return NSOrderedAscending;
         }
     }];
    return [NSMutableArray arrayWithArray:tempArray];
}


@end
