//
//  ZFLandScapeControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFLandScapeControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayer.h>
#else
#import "ZFPlayer.h"
#endif

#define shadowColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]

@interface ConfigCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSDictionary *dic;
@end

@implementation ConfigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)setDic:(NSDictionary *)dic {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"config"]];
}

@end


@interface ZFLandScapeControlView () <ZFSliderViewDelegate,UITableViewDelegate,UITableViewDataSource>
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
//@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间 
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) NSInteger tableViewSelectedIndex;

@end

@implementation ZFLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tableViewSelectedIndex = 1;
        
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        
        [self.bottomToolView addSubview:self.rateBtn];
        [self.bottomToolView addSubview:self.definitionBtn];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self addSubview:self.lockBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layOutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9; 
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
    min_y = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 15: [UIApplication sharedApplication].statusBarFrame.size.height > 0 ? [UIApplication sharedApplication].statusBarFrame.size.height : 20;
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.centerY = self.backBtn.centerY;
    
    min_h = iPhoneX ? 73: 45;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: min_margin;
    min_y = 5;
    min_w = 30;
    min_h = 30;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.right + 4;
    min_y = 0;
    min_w = 62;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    // 清晰度
    min_w = 50;
    min_x = self.bottomToolView.width - min_w - ((iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: min_margin);
    min_y = 0;
    min_h = 30;
    self.definitionBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.definitionBtn.centerY = self.playOrPauseBtn.centerY;
    self.definitionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // 倍速
    min_x = self.definitionBtn.left-40-4;
    min_y = 0;
    min_w = 40;
    min_h = 30;
    self.rateBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.rateBtn.centerY = self.playOrPauseBtn.centerY;
    self.rateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // totalTimeLabel
    min_w = 62;
    min_x = self.rateBtn.left-min_w-4;
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    // slider
    min_x = self.currentTimeLabel.right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.centerY = self.playOrPauseBtn.centerY;
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.centerY = self.centerY;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layOutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)showControlView {
    self.lockBtn.alpha = 1;
    self.isShow = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.y = -self.topToolView.height;
        self.bottomToolView.y = self.height;
    } else {
        self.topToolView.y = 0;
        self.bottomToolView.y = self.height - self.bottomToolView.height;
    }
    self.lockBtn.left = iPhoneX ? 50: 18;
    self.player.statusBarHidden = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha = 0;
        self.bottomToolView.alpha = 0;
    } else {
        self.topToolView.alpha = 1;
        self.bottomToolView.alpha = 1;
    }
}

- (void)hideControlView {
    self.isShow = NO;
    self.topToolView.y = -self.topToolView.height;
    self.bottomToolView.y = self.height;
    self.lockBtn.left = iPhoneX ? -82: -47;
    self.topToolView.alpha = 0;
    self.bottomToolView.alpha = 0;
    self.lockBtn.alpha = 0;
    self.player.statusBarHidden = YES;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(_configTableView.frame, point)) { // configTableView的响应事件
        return NO;
    }
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    [self.player enterFullScreen:NO animated:YES];
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

#pragma mark - 

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
}

/// 展示tableview
- (void) showTableViewWithType:(UIButton *)btn {
    _type = btn.tag - 1000;
//    if (!_configTableView) {
        [self addSubview:self.configTableView];
//    }
    self.configTableView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width*0.3, self.bounds.size.height);
    [self hideControlView];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.configTableView.alpha = 1.0f ;
        self.configTableView.frame = CGRectMake(self.bounds.size.width*0.7, 0, self.bounds.size.width*0.3, self.bounds.size.height);
    } completion:^(BOOL finished) {
    }];
}

- (void) dismissTableView {
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.configTableView.alpha = 0.0f ;
        self.configTableView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width*0.3, self.bounds.size.height);
        
    } completion:^(BOOL finished) {
        // 动画Animated必须是NO，不然消失之后，会有0.35s时间，再点击无效
        if (self.tempViewController) {
            [self.tempViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 第一个是title
    if (indexPath.row == 0) return;
    // 清除之前的选中label
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:_tableViewSelectedIndex inSection:0];
    ConfigCell *lastCell = [_configTableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.titleLabel.textColor = [UIColor whiteColor];
    // 设置选中状态
    _tableViewSelectedIndex = indexPath.row;
    ConfigCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"0BBF06"];
    if ([self.delegate respondsToSelector:@selector(selectedIndex:withConfigType:)]) {
        [self.delegate selectedIndex:indexPath.row withConfigType:self.type];
    }
    [self dismissTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.type == rateType ? self.rateArray.count : self.definitionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigCell" forIndexPath:indexPath];
    if (indexPath.row == _tableViewSelectedIndex) {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"0BBF06"];
    } else {
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
    cell.backgroundColor = shadowColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.type == rateType ? cell.dic = self.rateArray[indexPath.row] : self.definitionArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.type == rateType ? (self.bounds.size.height-100)/self.rateArray.count : (self.bounds.size.height-100)/self.definitionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    header.backgroundColor = shadowColor;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    footer.backgroundColor = shadowColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark - getter
- (NSArray *)rateArray {
    if (!_rateArray) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
        NSArray *tempArr = @[@"播放倍速",@"1.0X",@"1.25",@"1.5X",@"2.0X"];
        for (int i = 0; i < tempArr.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:tempArr[i] forKey:@"config"];
            [datas addObject:dic];
        }
        _rateArray = (NSArray *)datas;
    }
    return _rateArray;
}

- (UITableView *)configTableView {
    if (!_configTableView) {
        _configTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _configTableView.backgroundColor = shadowColor;
        _configTableView.alpha = 0.0;
        [_configTableView registerClass:[ConfigCell class] forCellReuseIdentifier:@"ConfigCell"];
        _configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _configTableView.delegate = self;
        _configTableView.dataSource = self;
    }
    return _configTableView;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UIButton *)rateBtn {
    if (!_rateBtn) {
        _rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateBtn.tag = 1001;
        [_rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [_rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rateBtn addTarget:self action:@selector(showTableViewWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateBtn;
}

- (UIButton *)definitionBtn {
    if (!_definitionBtn) {
        _definitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _definitionBtn.tag = 1002;
        [_definitionBtn setTitle:@"清晰度" forState:UIControlStateNormal];
        [_definitionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_definitionBtn addTarget:self action:@selector(showTableViewWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definitionBtn;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

@end
