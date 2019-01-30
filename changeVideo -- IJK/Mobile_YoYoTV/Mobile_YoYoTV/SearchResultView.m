//
//  SearchResultView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/25.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SearchResultView.h"
#import "SearchResultRequest.h"


@interface SearchResultView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NoResultView *noResultView;
@property (nonatomic) CGFloat height;
@end

@implementation SearchResultView


- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.noResultView];
        _noResultView.hidden = YES;
        _height = frame.size.height;
    }
    return self;
}

- (void) requestData {
    SearchResultRequest *request = [[SearchResultRequest alloc] init];
    request.keyword = [self.keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [request requestData:nil andBlock:^(SearchResultRequest *responseData) {
        NSLog(@"%@success---",NSStringFromClass([self class]));
        self.contentArray = responseData.responseData;
        if (_contentArray.count > 0) {
            _noResultView.hidden = YES;
            _collectionView.hidden = NO;
            if (_collectionView) {
                [_collectionView reloadData];
            } else {
                [self initCollectionView];
            }
        } else {
            _collectionView.hidden = YES;
        }
    } andFailureBlock:^(SearchResultRequest *responseData) {
        NSLog(@"%@fail---",NSStringFromClass([self class]));
    }];
}

- (void) initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 5;
    CGFloat itemWidth = (ScreenWidth-4*padding)/3.0;
    CGFloat itemHeight = itemWidth * (152.0/107.0);
    layout.itemSize    = CGSizeMake(itemWidth, itemHeight); // 设置cell的宽高
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _height) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
}

#pragma mark UIColltionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = _contentArray[indexPath.row];
    _passHomeModel(model);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.contentArray[indexPath.row];
    return cell;
}

- (NoResultView *)noResultView {
    if (_noResultView == nil) {
        _noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, _height)];
    }
    return _noResultView;
}

@end
