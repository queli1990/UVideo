//
//  ZFLandScapeControlView.h
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

#import <UIKit/UIKit.h>
#import "ZFPlayerController.h"
#import "ZFSliderView.h"

NS_ASSUME_NONNULL_BEGIN

///
typedef NS_ENUM(NSInteger, ConfigType) {
    rateType = 1,
    definitionType
} ;

@protocol SelectedConfigDelete <NSObject>

- (void) selectedIndex:(NSInteger)index withConfigType:(ConfigType)type;

@end

@interface ZFLandScapeControlView : UIView
/// 顶部工具栏
@property (nonatomic, strong, readonly) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong, readonly) UIView *bottomToolView;
/// 播放或暂停按钮 
@property (nonatomic, strong, readonly) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong, readonly) ZFSliderView *slider;
/// 播放速率
@property (nonatomic,strong) UIButton *rateBtn;
/// 清晰度
@property (nonatomic,strong) UIButton *definitionBtn;
/// 视频总时间
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong, readonly) UIButton *lockBtn;
/// 播放器
@property (nonatomic, weak) ZFPlayerController *player;
/// slider滑动中
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);
/// slider滑动结束
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);
/// 倍速数据源
@property (nonatomic, strong) NSArray *rateArray;
/// 清晰度数据源
@property (nonatomic, strong) NSArray *definitionArray;
/// 倍速、清晰度选择
@property (nonatomic, strong) UITableView *configTableView;
///  倍速 / 清晰度
@property (nonatomic, assign) ConfigType type;
/// 用来控制动画消失
@property (nonatomic, strong) UIViewController *tempViewController;
///
@property (nonatomic, weak) id<SelectedConfigDelete>delegate;
/// default 1
@property (nonatomic, assign) NSInteger rateSelectedIndex;
/// default 1
@property (nonatomic, assign) NSInteger definitionSelectedIndex;

/// 重置控制层
- (void)resetControlView;
/// 显示控制层
- (void)showControlView;
/// 隐藏控制层
- (void)hideControlView;
/// 设置播放时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
/// 设置缓冲时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;
/// 是否响应该手势
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch;
/// 标题和全屏模式
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(ZFFullScreenMode)fullScreenMode;
/// 根据当前播放状态取反
- (void)playOrPause;
/// 播放按钮状态
- (void)playBtnSelectedState:(BOOL)selected;

/// 全屏按钮的返回事件
- (void)backBtnClickAction:(UIButton *)sender;

/// 倍速播放、清晰度选择
//- (void) showTableViewWithType:(ConfigType)type;
/// 横屏时，倍速、清晰度的tableView消失
- (void) dismissTableView;
/// 清除上一次的倍速、清晰度
- (void) clearSelectStyle;


@end

NS_ASSUME_NONNULL_END
