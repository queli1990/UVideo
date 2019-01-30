//
//  ShareView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/7.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "ShareView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ShareView()<FBSDKSharingDelegate>

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-80)];
        [self addSubview:_shadowView];
        self.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    }
    return self;
}

- (void) setViewWithTitles:(NSArray *)titles imgs:(NSArray *)imgs shareParams:(NSDictionary *)params {
    self.passParams = params;
    CGFloat gap = 15;
    CGFloat width = 80;
    CGFloat separation = (ScreenWidth-gap*2-titles.count*width)/(titles.count+1);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-80, ScreenWidth, 80)];
    bottomView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < titles.count; i++) {
        ShareTypeButton *btn = [ShareTypeButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(gap + width*i + separation*(i+1), 10, width, 60);
        [btn setImage:imgs[i] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    }
    [self addSubview:bottomView];
}

- (void) shareBtnClick:(UIButton *)btn {
    NSLog(@"%ld",btn.tag);
    if (btn.tag == 1000) { // 分享按钮
        NSString *contentUrlString = [self.passParams objectForKey:@"shareURL"];
//        NSURL *imgURL = [NSURL URLWithString:@"http://cdn.100uu.tv/media/upload_imgs/推荐-3.png"];
        NSString *description = [self.passParams objectForKey:@"title"];
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:contentUrlString];
        content.quote = description;
        FBSDKShareDialog *dl = [[FBSDKShareDialog alloc] init];
        dl.mode = FBSDKShareDialogModeFeedWeb;
        dl.delegate = self;
        [dl setShareContent:content];
        [dl show];
    } else { // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.passParams objectForKey:@"shareURL"];
        NSDictionary *dic = @{@"result":@"1",@"msg":@"复制成功"};
        if ([self.delegate respondsToSelector:@selector(shareCallBack:)]) {
            [self.delegate shareCallBack:dic];
        }
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSDictionary *dic = @{@"result":@"1",@"msg":@"分享成功"};
    if ([self.delegate respondsToSelector:@selector(shareCallBack:)]) {
        [self.delegate shareCallBack:dic];
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSDictionary *dic = @{@"result":@"-1",@"msg":@"分享失败"};
    if ([self.delegate respondsToSelector:@selector(shareCallBack:)]) {
        [self.delegate shareCallBack:dic];
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSDictionary *dic = @{@"result":@"-1",@"msg":@"分享取消"};
    if ([self.delegate respondsToSelector:@selector(shareCallBack:)]) {
        [self.delegate shareCallBack:dic];
    }
}




@end
