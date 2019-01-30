//
//  SearchResultTableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SearchResultTableView.h"
#import "SearchResultRequest.h"
#import "DGActivityIndicatorView.h"

@interface SearchResultTableView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NoResultView *noResultView;
@property (nonatomic) CGFloat height;
@property (nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation SearchResultTableView


- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height)];
        
        [self addSubview:self.noResultView];
        _noResultView.hidden = YES;
        _height = frame.size.height;
        
        CGFloat width = 50.0;
        CGFloat height = 50.0;
        self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor grayColor] size:50.0f];
        self.activityIndicatorView.frame = CGRectMake((frame.size.width-width)*0.5, (frame.size.height-height)*0.5, width, height);
        [self addSubview:self.activityIndicatorView];
        [self bringSubviewToFront:self.activityIndicatorView];
    }
    return self;
}

- (void) requestDataWhenLoaded:(FinishLoad) callback {
//    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [self.activityIndicatorView startAnimating];
    SearchResultRequest *request = [[SearchResultRequest alloc] init];
    request.keyword = [self.keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [request requestData:nil andBlock:^(SearchResultRequest *responseData) {
        NSLog(@"success---%@",NSStringFromClass([self class]));
        self.contentArray = responseData.responseData;
        if (_contentArray.count > 0) {
            _noResultView.hidden = YES;
            _tableView.hidden = NO;
            if (_tableView) {
                [_tableView reloadData];
            } else {
                [self initTableView];
            }
        } else {
            _noResultView.hidden = NO;
            _tableView.hidden = YES;
        }
//        [SVProgressHUD dismiss];
        [self.activityIndicatorView stopAnimating];
        callback();
    } andFailureBlock:^(SearchResultRequest *responseData) {
        NSLog(@"fail---%@",NSStringFromClass([self class]));
        [self.activityIndicatorView stopAnimating];
    }];
}

- (void) initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _height) style:UITableViewStylePlain];
    [_tableView registerClass:[SearchResultTableViewCell class] forCellReuseIdentifier:@"SearchResultTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
}

#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchResultModel *model = _contentArray[indexPath.row];
    _passHomeModel(model);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultTableViewCell" forIndexPath:indexPath];
    cell.model = self.contentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

//- (NoResultView *)noResultView {
//    if (_noResultView == nil) {
//        _noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, _height)];
//    }
//    return _noResultView;
//}



@end
