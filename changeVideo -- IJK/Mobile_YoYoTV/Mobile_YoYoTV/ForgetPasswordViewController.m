//
//  ForgetPasswordViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/3.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginNav.h"
#import "PostBaseHttpRequest.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LoginNav *navView;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UIButton *findPasswordBtn;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavView];
    [self setContentView];
}

- (void) setContentView {
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(21, 64+50, ScreenWidth-21*2, 44)];
    _emailTextField.placeholder = @"请输入您的邮箱地址";
    _emailTextField.backgroundColor = [UIColor clearColor];
    
    _emailTextField.textColor = [UIColor blackColor];
    _emailTextField.font = [UIFont systemFontOfSize:16.0];
    //    _emailTextField.clearButtonMode = UITextFieldViewModeAlways;
    //    _emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    _emailTextField.delegate = self;
    [_emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_emailTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_emailTextField.frame.origin.x, CGRectGetMaxY(_emailTextField.frame), _emailTextField.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [self.view addSubview:lineView];
    
    self.findPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _findPasswordBtn.frame = CGRectMake(37, CGRectGetMaxY(_emailTextField.frame)+31, ScreenWidth-37*2, 46);
    _findPasswordBtn.layer.cornerRadius = 3;
    [_findPasswordBtn setTitle:@"立即找回密码" forState:UIControlStateNormal];
    [_findPasswordBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];
    [_findPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_findPasswordBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findPasswordBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_emailTextField resignFirstResponder];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (_emailTextField.text.length > 0) {
        [_findPasswordBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x0BBF06, 1.0)] forState:UIControlStateNormal];
    } else {
        [_findPasswordBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];
    }
}

- (void) findPassword:(UIButton *)btn {
    if (![self validateEmail:_emailTextField.text]) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请输入合法的邮箱地址"];
        [alert show:nil];
        [_emailTextField resignFirstResponder];
        return;
    }
    btn.userInteractionEnabled = NO;//点击之后，不允许用户连续点击
    NSDictionary *params = @{@"email":_emailTextField.text};
    [[PostBaseHttpRequest alloc] basePostDataRequest:params andTransactionSuffix:@"app/member/doRetrievePasswordOne.do" andBlock:^(PostBaseHttpRequest *responseData) {
        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        NSString *statusString = userDic[@"status"];
        
        btn.userInteractionEnabled = YES;//恢复按钮的点击
        if ([statusString isEqualToString:@"1"]) {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"邮件已发送"];
            [alert show:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else if ([statusString isEqualToString:@"2"]){
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"密码邮箱不存在"];
            [alert show:nil];
        } else {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"服务端异常,请稍后重试"];
            [alert show:nil];
        }
    } andFailure:^(PostBaseHttpRequest *responseData) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"邮件发送失败,请检查网络"];
        [alert show:^{
            btn.userInteractionEnabled = YES;//恢复按钮的点击
        }];
    }];
}

- (void) setNavView {
    self.navView = [[LoginNav alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor clearColor];
    _navView.titleLabel.hidden = YES;
    [_navView.backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

- (void) backToLastPage {
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否为邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//封装类方法掉用：
//  颜色转换为背景图片
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
