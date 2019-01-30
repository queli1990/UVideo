//
//  RegistViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/18.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginNav.h"
#import "PostBaseHttpRequest.h"
#import "NSString+encrypto.h"

@interface RegistViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LoginNav *navView;
@property (nonatomic,strong) UITextField *nickNameTextField;
@property (nonatomic,strong) UITextField *passWordTextField;
@property (nonatomic,strong) UITextField *repassWordTextField;
@property (nonatomic,strong) UIButton *registBtn;
@property (nonatomic,strong) UIAlertController *nickNameAlert;
@property (nonatomic,strong) UIAlertController *passWordAlert;

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *passwordImageView;
@property (nonatomic,strong) UIImageView *repasswordImageView;
@end

@implementation RegistViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_nickNameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self initTextField];
    self.nickNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的用户名长度太短，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
    self.passWordAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的密码太短，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [_nickNameAlert addAction:okAction];
    [_passWordAlert addAction:okAction];
    [_nickNameAlert.view setNeedsLayout];
    [_passWordAlert.view setNeedsLayout];
}

static SEL extracted() {
    return @selector(regist:);
}

- (void) initTextField{
    UIView *inputView1 = [[UIView alloc] initWithFrame:CGRectMake(30, 64+30, ScreenWidth-60, 40)];
    //    inputView1.layer.masksToBounds = YES;
    //    inputView1.layer.borderWidth = 1.0;
    //    inputView1.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView1.layer.cornerRadius = 14.0;
    inputView1.backgroundColor = [UIColor clearColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth-60, 1)];
    lineView1.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView1 addSubview:lineView1];
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    _headImageView.image = [UIImage imageNamed:@"login_personal_normal"];
    [inputView1 addSubview:_headImageView];
    
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame)+15, 5, ScreenWidth-60-_headImageView.frame.size.width-30-10-5-20, 30)];
    _nickNameTextField.placeholder = @"请输入邮箱地址";
    //设置placeholder的颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = UIColorFromRGB(0x9B9B9B, 1.0);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_nickNameTextField.placeholder attributes:dict];
    [_nickNameTextField setAttributedPlaceholder:attribute];
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.font = [UIFont systemFontOfSize:16.0];
//    _nickNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    //    _nickNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nickNameTextField.delegate = self;
    [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView1 addSubview:_nickNameTextField];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(CGRectGetMaxX(_nickNameTextField.frame)+5, 10, 20, 20);
    [clearBtn setImage:[UIImage imageNamed:@"personal_clearBtnNormal"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearInput:) forControlEvents:UIControlEventTouchUpInside];
    [inputView1 addSubview:clearBtn];
    [self.view addSubview:inputView1];
    
    
    UIView *inputView2 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(inputView1.frame)+20, ScreenWidth-60, 40)];
    inputView2.backgroundColor = [UIColor clearColor];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth-60, 1)];
    lineView2.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView2 addSubview:lineView2];
    
    self.passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    _passwordImageView.image = [UIImage imageNamed:@"personal_lock_normal"];
    [inputView2 addSubview:_passwordImageView];
    
    self.passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passwordImageView.frame)+15, 5, _nickNameTextField.frame.size.width, 30)];
    _passWordTextField.textColor = [UIColor blackColor];
    _passWordTextField.placeholder = @"请输入8位数以上密码";
    //设置placeholder的颜色
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSForegroundColorAttributeName] = UIColorFromRGB(0x9B9B9B, 1.0);
    NSAttributedString *attribute2 = [[NSAttributedString alloc] initWithString:_passWordTextField.placeholder attributes:dict2];
    [_passWordTextField setAttributedPlaceholder:attribute2];
    _passWordTextField.font = [UIFont systemFontOfSize:16.0];
    //    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.delegate = self;
    [inputView2 addSubview:_passWordTextField];
    [_passWordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:inputView2];
    
    
    UIView *inputView3 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(inputView2.frame)+20, ScreenWidth-60, 40)];
    //    inputView3.layer.masksToBounds = YES;
    //    inputView3.layer.borderWidth = 1.0;
    //    inputView3.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView2.layer.cornerRadius = 14.0;
    inputView3.backgroundColor = [UIColor clearColor];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth-60, 1)];
    lineView3.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView3 addSubview:lineView3];
    
    
    self.repasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    _repasswordImageView.image = [UIImage imageNamed:@"personal_lock_normal"];
    [inputView3 addSubview:_repasswordImageView];
    
    self.repassWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passwordImageView.frame)+15, 5, _nickNameTextField.frame.size.width, 40)];
    _repassWordTextField.textColor = [UIColor blackColor];
    _repassWordTextField.placeholder = @"请确认密码";
    _repassWordTextField.secureTextEntry = YES;
    //设置placeholder的颜色
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[NSForegroundColorAttributeName] = UIColorFromRGB(0x9B9B9B, 1.0);
    NSAttributedString *attribute3 = [[NSAttributedString alloc] initWithString:_repassWordTextField.placeholder attributes:dict3];
    [_repassWordTextField setAttributedPlaceholder:attribute3];
    
    _repassWordTextField.font = [UIFont systemFontOfSize:16.0];
    //    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _repassWordTextField.delegate = self;
    [_repassWordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView3 addSubview:_repassWordTextField];
    
    [self.view addSubview:inputView3];
    
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = ScreenWidth-35*2;
    CGFloat height = width*46/304;
    _registBtn.frame = CGRectMake(35, CGRectGetMaxY(inputView3.frame)+30, width, height);
    [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registBtn.layer.cornerRadius = 3;
    _registBtn.backgroundColor = [UIColor orangeColor];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn addTarget:self action:extracted() forControlEvents:UIControlEventTouchUpInside];
    [_registBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];
    [self.view addSubview:_registBtn];
}

- (void) clearInput:(UIButton *)btn{
    _nickNameTextField.text = nil;
}

- (void) regist:(UIButton *)btn{
    if (![self validateEmail:_nickNameTextField.text]) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请输入正确的邮箱地址"];
        [alert show:^{
            
        }];
        [_nickNameTextField resignFirstResponder];
        return;
    }
    if (_passWordTextField.text.length<8) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"您的密码太短，请重新输入"];
        [alert show:^{
            
        }];
        [_passWordTextField resignFirstResponder];
        return;
    }
    if (![_passWordTextField.text isEqualToString:_repassWordTextField.text]) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"您两次输入的密码不一致"];
        [alert show:^{
            
        }];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userName = _nickNameTextField.text;
    NSString *password = _passWordTextField.text;
    NSString *platform = @"mobile-ios";
    NSString *channel = @"uu100";
    NSString *combineStr = [NSString stringWithFormat:@"%@%@%@%@",userName,password,platform,channel];
    NSString *md5Str = [combineStr md5];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:channel forKey:@"channel"];
    [params setObject:md5Str forKey:@"sign"];
    btn.userInteractionEnabled = NO;//点击之后，不允许用户连续点击
    [[PostBaseHttpRequest alloc] basePostDataRequest:params andTransactionSuffix:@"app/member/doRegister.do" andBlock:^(PostBaseHttpRequest *responseData) {
        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        NSString *statusString = userDic[@"status"];
        btn.userInteractionEnabled = YES;//恢复按钮的点击
        if ([statusString isEqualToString:@"2"]) {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"注册成功"];
            [alert show:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else if ([statusString isEqualToString:@"1"]){
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"用户已经存在"];
            [alert show:nil];
        } else {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"服务端异常,请稍后重试"];
            [alert show:nil];
        }
        /*
         {
         dueTime = "";
         isVip = 0;
         status = 1;
         token = a21362784feae48e5955e94fae328c3a;
         userName = "zhangsan@hotmail.com";
         }
         */
    } andFailure:^(PostBaseHttpRequest *responseData) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"注册失败请查看网络"];
        [alert show:^{
            btn.userInteractionEnabled = YES;//恢复按钮的点击
        }];
    }];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passWordTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];
}

- (void) setNav{
    self.navView = [[LoginNav alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor clearColor];
    [_navView addRightBtn];
    [_navView.rightBtn setTitle:@"登录" forState:UIControlStateNormal];
    _navView.titleLabel.hidden = YES;
    _navView.rightBtn.frame = CGRectMake(ScreenWidth-15-40, 20+(44-49.0*0.5)/2, 40, 49.0*0.5);
    [_navView.rightBtn setTitleColor:UIColorFromRGB(0x0BBF06, 1.0) forState:UIControlStateNormal];
    [_navView.rightBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navView.backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

//判断是否为邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void) backToLastPage {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    //注册按钮
    if (_nickNameTextField.text.length > 0 && _passWordTextField.text.length >0 && _repassWordTextField.text.length > 0) {
        [_registBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x0BBF06, 1.0)] forState:UIControlStateNormal];
    } else {
        [_registBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];
    }
    //注册的头像
    if (_nickNameTextField.text.length > 0) {
        _headImageView.image = [UIImage imageNamed:@"login_personal_selected"];
    } else {
        _headImageView.image = [UIImage imageNamed:@"login_personal_normal"];
    }
    //密码框
    if (_passWordTextField.text.length > 0) {
        _passwordImageView.image = [UIImage imageNamed:@"personal_lock_selected"];
    } else {
        _passwordImageView.image = [UIImage imageNamed:@"personal_lock_normal"];
    }
    //确认密码框
    if (_repassWordTextField.text.length > 0) {
        _repasswordImageView.image = [UIImage imageNamed:@"personal_lock_selected"];
    } else {
        _repasswordImageView.image = [UIImage imageNamed:@"personal_lock_normal"];
    }
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
