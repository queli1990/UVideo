//
//  ChannelsViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ChannelsViewController.h"
#import "NavView.h"
#import "HomeRequest.h"
#import "ChannelsCollectionViewCell.h"

@interface ChannelsViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *genreModels;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LoaderObject *loaderHUD;
@end

@implementation ChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavView];
    [self initCollectionView];
    [self requestData];
}

- (void) initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15;
    CGFloat itemWidth = (ScreenWidth - 3*padding)/2.0;
    CGFloat itemHeight = itemWidth * (94.0/165.0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
//    layout.minimumLineSpacing = 5.0;
//    layout.minimumInteritemSpacing = 20.0;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) collectionViewLayout:layout];
    [_collectionView registerClass:[ChannelsCollectionViewCell class] forCellWithReuseIdentifier:@"ChannelsCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [self.view addSubview:_collectionView];
    _mainTabbar.delegate = self;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"xx");
}

#pragma mark CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.genreModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelsCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.genreModels[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中了:%ld",(long)indexPath.row);
    [[self rdv_tabBarController] tabBar:_mainTabbar.tabBar didSelectItemAtIndex:0];
    NSDictionary *dic = @{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passIndex" object:nil userInfo:dic];
}

- (void) requestData {
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [self.loaderHUD showLoader];
    [[[HomeRequest alloc] init] requestData:nil andBlock:^(HomeRequest *responseData) {
        self.genreModels = [[NSArray alloc] initWithArray:responseData.genresArray];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<_genreModels.count; i++) {
            GenresModel *model = _genreModels[i];
            [tempArray addObject:model.name];
        }
        [self.collectionView reloadData];
        [self.loaderHUD dismissLoader];
//        [SVProgressHUD dismiss];
    } andFailureBlock:^(HomeRequest *responseData) {
        [self.loaderHUD dismissLoader];
//        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

- (void) setupNavView {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.backBtn.hidden = YES;
    nav.titleLabel.text = @"频道";
    [self.view addSubview:nav];
}

- (LoaderObject *)loaderHUD {
    if (!_loaderHUD) {
        _loaderHUD = [[LoaderObject alloc] initWithFatherView:self.view];
    }
    return _loaderHUD;
}

@end
