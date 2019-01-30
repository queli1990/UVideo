//
//  FeedBackViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NavView.h"

@interface FeedBackViewController () <UITextViewDelegate>
@property (nonatomic,strong) UITextView *feedbackTextView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UILabel *placeholdLabel;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self setupView];
}

- (void) setNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"意见反馈";
    [self.view addSubview:nav];
}

- (void) setupView {
    self.feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 64+20, ScreenWidth-30, (ScreenWidth-30)*(200.0/343.0))];
    _feedbackTextView.layer.borderColor = [UIColorFromRGB(0xE6E6E6, 1.0) CGColor];
    _feedbackTextView.layer.borderWidth = 1.0;
    _feedbackTextView.layer.cornerRadius = 2.0;
    _feedbackTextView.delegate = self;
    _feedbackTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0];
    _feedbackTextView.textContainerInset = UIEdgeInsetsMake(16, 21, 16, 21);
    [self.view addSubview:_feedbackTextView];
    
    self.placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, ScreenWidth-30-24*2, 120)];
    _placeholdLabel.text = @"HI，我是中文影视小助手。希望收集到您的宝贵意见或者我们的产品bug，谢谢！\nHI, I am a small assistant of Chinesetvall. I hope to collect your valuable comments or our product bugs, thank you!";
    _placeholdLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
    _placeholdLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _placeholdLabel.numberOfLines = 0;
    [_feedbackTextView addSubview:_placeholdLabel];
    
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(15, CGRectGetMaxY(_feedbackTextView.frame)+20, ScreenWidth-30, 45);
    _submitBtn.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
    [_submitBtn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0x0AB705, 1.0)] forState:UIControlStateHighlighted];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 3.0;
    [self.view addSubview:_submitBtn];
}

- (void) submitBtnClick:(UIButton *)btn {
    if (_feedbackTextView.text.length <2 ) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"您输入的内容过短"];
        [alert show:nil];
        return;
    }
    // 禁止连续点击
    btn.userInteractionEnabled = NO;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    // 获取App的build版本
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSDictionary *dic = @{@"id":@3,@"platform":@"ios",@"msg":_feedbackTextView.text,@"version_number":appVersion,@"version_code":appBuildVersion};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://video.chinesetvall.com/feedbacks" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"已提交成功"];
        [alert show:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请检查您的网络设置"];
        [alert show:nil];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@",textView.text);
    if (textView.text.length > 0) {
        _submitBtn.backgroundColor = UIColorFromRGB(0x0BBF06, 1.0);
        _placeholdLabel.hidden = YES;
    } else {
        _submitBtn.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
        _placeholdLabel.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_feedbackTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void) goBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage*) createImageWithColor:(UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
