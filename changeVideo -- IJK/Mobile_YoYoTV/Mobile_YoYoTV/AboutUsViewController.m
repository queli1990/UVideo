//
//  AboutUsViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/14.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "AboutUsViewController.h"
#import "NavView.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupView];
}

- (void) setupView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 64+36, ScreenWidth-30, 110)];
    label.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"        优优TV是UU团队推出的智能互联网多平台视频播放应用，现已经覆盖Apple TV/Android TV/Roku/Android移动端/iOS移动端/WEB端等平台，并包含海量高清正版影视资源，致力于提供最畅爽的电视观看体验。";
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSKernAttributeName : @(1.5f)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    [label setAttributedText:attributedString];
    
    label.numberOfLines = 0;
    [label sizeToFit];
    
    
    [self.view addSubview:label];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-136)/2, CGRectGetMaxY(label.frame)+30, 136, 136)];
    imgView1.image = [UIImage imageNamed:@"wechat_code"];
    [self.view addSubview:imgView1];
    
    UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView1.frame)+17, ScreenWidth, 19)];
    wechatLabel.textAlignment = NSTextAlignmentCenter;
    wechatLabel.font = [UIFont systemFontOfSize:13];
    wechatLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
    wechatLabel.text = @"UU微信公众号";
    [self.view addSubview:wechatLabel];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-123)/2, CGRectGetMaxY(wechatLabel.frame)+31, 123, 123)];
    imgView2.image = [UIImage imageNamed:@"wechat_code"];
    [self.view addSubview:imgView2];
    
    UILabel *weiBoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView2.frame)+17, ScreenWidth, 19)];
    weiBoLabel.textAlignment = NSTextAlignmentCenter;
    weiBoLabel.font = [UIFont systemFontOfSize:13];
    weiBoLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
    weiBoLabel.text = @"UU微博";
    [self.view addSubview:weiBoLabel];
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"用户协议";
    [self.view addSubview:nav];
}

- (void) goBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
