//
//  NineBoxDownloadBtn.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/5.
//  Copyright © 2018 li que. All rights reserved.
//

#import "NineBoxDownloadBtn.h"

@interface NineBoxDownloadBtn (){
    id _target;
    SEL _action;
}

@end

@implementation NineBoxDownloadBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat leftGap = 15; // 最左边和最右边的间距
        CGFloat horizontalGap = 20; // 两个item之间水平的间距
        CGFloat width = (ScreenWidth - leftGap*2 - (5-1)*horizontalGap) / 5; // 宽
        
        // 集数标签
        UILabel *episodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, width-12*2, width-12*2)];
        episodeLabel.textAlignment = NSTextAlignmentCenter;
        episodeLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        episodeLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:episodeLabel];
        _titleLabel = episodeLabel;
        
        // 状态视图
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.image = [UIImage imageNamed:@"com_download_default"];
        [self addSubview:imgView];
        imgView.layer.cornerRadius = 6;
        _imgView = imgView;
        imgView.hidden = YES;
    }
    return self;
}

- (void)setModel:(HWDownloadModel *)model {
    _model = model;
    self.state = model.state;
}

- (void)setState:(HWDownloadState)state {
    switch (state) {
        case HWDownloadStateDownloading:
            _imgView.hidden = NO;
            _imgView.image = [UIImage imageNamed:@"com_download_ing"];
            break;
        case HWDownloadStateFinish:
            _imgView.hidden = NO;
            _imgView.image = [UIImage imageNamed:@"downloadFinishIcon"];
            break;
        case HWDownloadStateWaiting:
            _imgView.hidden = NO;
            _imgView.image = [UIImage imageNamed:@"com_download_waiting"];
            break;
        case HWDownloadStateError:
            _imgView.hidden = NO;
            _imgView.image = [UIImage imageNamed:@"com_download_error"];
        default:
            _imgView.hidden = YES;
            break;
    }
    _state = state;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 此处的 i 应该是清晰度的选择
    NSNumber *selectedIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"definitionSelectedIndex"];
    if (!self.downloadUrlArray.count) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"当前视频无法下载"];
        [alert show:^{
            
        }];
        return;
    }
    _model.url = [self.downloadUrlArray[selectedIndex.intValue-1000] objectForKey:@"link"];
    NSUInteger totalSize = [[self.downloadUrlArray[selectedIndex.integerValue-1000] objectForKey:@"size"] integerValue];
    _model.totalFileSize = totalSize;
    
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    if (cacheData.count) {
        for (HWDownloadModel *downloadModel in cacheData) {
            if ([downloadModel.vid isEqualToString:[NSString stringWithFormat:@"%@-%ld",self.episodeID,self.tag-1000+1]]) {
                AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"已添加下载"];
                [alert show:^{
                    
                }];
                return;
            }
        }
    }
    
    if (!_target || !_action) return;
    ((void (*)(id, SEL, id))[_target methodForSelector:_action])(_target, _action, self);
}


@end
