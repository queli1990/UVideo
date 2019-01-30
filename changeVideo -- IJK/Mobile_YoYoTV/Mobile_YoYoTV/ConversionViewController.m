//
//  ConversionViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ConversionViewController.h"
#import "NavView.h"

@interface ConversionViewController () <UITextFieldDelegate>
@property (nonatomic,strong) UITextField *input;
@property (nonatomic,strong) UIButton *useBtn;
@end

@implementation ConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_input becomeFirstResponder];
}

- (void) setupView {
    self.input = [[UITextField alloc] initWithFrame:CGRectMake(20, 64+60, ScreenWidth-20*2, 44)];
    _input.placeholder = @"请输入您的兑换码";
    _input.delegate = self;
    [self.view addSubview:_input];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, 64+60+44, ScreenWidth-20*2, 1)];
    line.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
    [self.view addSubview:line];
    
    self.useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _useBtn.frame = CGRectMake(38, CGRectGetMaxY(line.frame)+30, ScreenWidth-38*2, 46);
    [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, _useBtn.frame.size.width, _useBtn.frame.size.height);
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
    layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
                     (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
    //起始点
    layer.startPoint = CGPointMake(0.15, 0.5);
    //结束点
    layer.endPoint = CGPointMake(0.85, 0.5);
    [_useBtn.layer addSublayer:layer];
    [self.view addSubview:_useBtn];
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"VIP兑换码";
    [self.view addSubview:nav];
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
