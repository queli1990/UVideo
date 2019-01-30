//
//  UserProtocolViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/14.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "UserProtocolViewController.h"
#import "NavView.h"

@interface UserProtocolViewController () <UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"拼命加载中，请稍等"];
    [self setupNav];
    [self loadWeb];
}

- (void) loadWeb {
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://34.224.203.220/pravicy.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start ...");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"load end");
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showWithStatus:@"加载失败"];
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"用户协议";
    [self.view addSubview:nav];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void) goBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
