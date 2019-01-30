//
//  DownloadImgView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018 li que. All rights reserved.
//

#import "DownloadImgView.h"

@implementation DownloadImgView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setModel:(HWDownloadModel *)model {
    _model = model;
    self.state = model.state;
}

- (void)setState:(HWDownloadState)state {
    switch (state) {
        case HWDownloadStateDefault:
//            self.image = [UIImage imageNamed:@"com_download_default"];
            break;
            
        case HWDownloadStateDownloading:
            self.image = [UIImage imageNamed:@"com_download_ing"];
            break;
            
        case HWDownloadStateWaiting:
            self.image = [UIImage imageNamed:@"com_download_waiting"];
            break;
            
        case HWDownloadStatePaused:
//            self.image = [UIImage imageNamed:@"com_download_pause"];
            break;
            
        case HWDownloadStateFinish:
            self.image = [UIImage imageNamed:@"com_download_finish"];
            break;
            
        case HWDownloadStateError:
//            self.image = [UIImage imageNamed:@"com_download_error"];
            break;
            
        default:
            break;
    }
    
    _state = state;
}



@end
