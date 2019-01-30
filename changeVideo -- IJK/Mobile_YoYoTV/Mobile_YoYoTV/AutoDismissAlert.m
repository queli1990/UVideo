//
//  AutoDismissAlert.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/30.
//  Copyright © 2018 li que. All rights reserved.
//

#define AlertView_W     200.0f
#define MessageMin_H    50.0f       //messagelab的最小高度
#define MessageMAX_H    120.0f      //messagelab的最大高度，当超过时，文本会以...结尾


#import "AutoDismissAlert.h"
#import "UILabel+QLAdd.h"

@interface AutoDismissAlert ()

@property (nonatomic,strong)UIView *alertView;

@property (nonatomic,strong)UIWindow *alertWindow;

@end


@implementation AutoDismissAlert

-(instancetype)initWithTitle:(NSString *)msg {
    if (self = [super init]) {
        
        self.frame=[UIScreen mainScreen].bounds;
//        self.backgroundColor = [UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        _alertView.layer.cornerRadius=6.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        CGFloat messageLabSpace = 25;
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.text = msg;
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.numberOfLines=0;
        msgLabel.textAlignment=NSTextAlignmentCenter;
        msgLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        msgLabel.characterSpace=2;
        msgLabel.lineSpace=3;
        CGSize labSize = [msgLabel getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        msgLabel.frame=CGRectMake(messageLabSpace, 10, AlertView_W-messageLabSpace*2, endMessageLabH);
        
        _alertView.frame = CGRectMake(0, 0, AlertView_W, msgLabel.frame.size.height+20);
        [self addSubview:_alertView];
        _alertView.center = self.center;
        [_alertView addSubview:msgLabel];
        
    }
    return self;
}

- (void) show:(finishBlock)block {
    _alertWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.windowLevel=UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    [_alertWindow addSubview:self];
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_alertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_alertView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    double delayInSeconds = 1;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self removeFromSuperview];
                        [_alertWindow resignKeyWindow];
                        block();
                    });
                }];
            }];
        }];
    }];
}

@end
