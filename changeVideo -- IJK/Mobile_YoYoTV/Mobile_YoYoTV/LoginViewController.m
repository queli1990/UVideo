//
//  LoginViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/18.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNav.h"
#import "NSString+encrypto.h"
#import "PostBaseHttpRequest.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
#import "CollectionRequest.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LoginNav *navView;
@property (nonatomic,strong) UITextField *nickNameTextField;
@property (nonatomic,strong) UITextField *passWordTextField;
@property (nonatomic,strong) NSMutableArray *collections;
@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *passwordImageView;

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_nickNameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    
    [self initTextField];
}

- (void) initTextField{
    
    UIView *inputView1 = [[UIView alloc] initWithFrame:CGRectMake(30, 64+50, ScreenWidth-60, 40)];
    //    inputView1.layer.masksToBounds = YES;
    //    inputView1.layer.borderWidth = 1.0;
    //    inputView1.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView1.layer.cornerRadius = 14.0;
    inputView1.backgroundColor = [UIColor clearColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth-60, 1)];
    lineView1.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView1 addSubview:lineView1];
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    _headImageView.image = [UIImage imageNamed:@"login_personal_normal"];
    [inputView1 addSubview:_headImageView];
    
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame)+15, 5, ScreenWidth-60-_headImageView.frame.size.width-30-10-5-20, 30)];
    _nickNameTextField.placeholder = @"请输入邮箱地址";
    _nickNameTextField.backgroundColor = [UIColor clearColor];
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
    
    
    UIView *inputView2 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(inputView1.frame)+30, ScreenWidth-60, 40)];
    //    inputView2.layer.masksToBounds = YES;
    //    inputView2.layer.borderWidth = 1.0;
    //    inputView2.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView2.layer.cornerRadius = 14.0;
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
    _passWordTextField.secureTextEntry = YES;
    //设置placeholder的颜色
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSForegroundColorAttributeName] = UIColorFromRGB(0x9B9B9B, 1.0);
    NSAttributedString *attribute2 = [[NSAttributedString alloc] initWithString:_passWordTextField.placeholder attributes:dict2];
    [_passWordTextField setAttributedPlaceholder:attribute2];
    _passWordTextField.font = [UIFont systemFontOfSize:16.0];
    //    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passWordTextField.delegate = self;
    [_passWordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView2 addSubview:_passWordTextField];
    
    [self.view addSubview:inputView2];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = ScreenWidth-35*2;
    CGFloat height = width*46/304;
    _loginBtn.frame = CGRectMake(35, CGRectGetMaxY(inputView2.frame)+30, width, height);
    _loginBtn.layer.cornerRadius = 3;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];

    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(CGRectGetMaxX(_loginBtn.frame)-56, CGRectGetMaxY(_loginBtn.frame)+16, 56, 20);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:UIColorFromRGB(0x0BBF06, 1.0) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [forgetBtn addTarget:self action:@selector(goForgetPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
}

- (void) goForgetPage:(UIButton *)btn {
    ForgetPasswordViewController *vc = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) clearInput:(UIButton *)btn{
    _nickNameTextField.text = nil;
}

- (void) regist:(UIButton *)btn{
    RegistViewController *vc = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) login:(UIButton *)btn{
    if (![self validateEmail:_nickNameTextField.text]) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请输入合法的邮箱地址"];
        [alert show:^{
            
        }];
        [_nickNameTextField resignFirstResponder];
        return;
    }
    if (_passWordTextField.text.length<8) {
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"您输入的密码名不符合"];
        [alert show:^{
            
        }];
        [_passWordTextField resignFirstResponder];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userName = _nickNameTextField.text;
    NSString *password = _passWordTextField.text;
    NSString *platform = @"mobile-ios";
    NSString *combineStr = [NSString stringWithFormat:@"%@%@%@",userName,password,platform];
    NSString *md5Str = [combineStr md5];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:md5Str forKey:@"sign"];
    btn.userInteractionEnabled = NO;//禁止连续点击
    [[PostBaseHttpRequest alloc] basePostDataRequest:params andTransactionSuffix:@"app/member/doLogin.do" andBlock:^(PostBaseHttpRequest *responseData) {
        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        NSString *statusString = userDic[@"status"];
        btn.userInteractionEnabled = YES;//恢复点击
        if ([statusString isEqualToString:@"1"]) {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"登录成功"];
            [alert show:^{
                [self backToLastPage];
            }];
            
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userInfo"];
            
        } else if ([statusString isEqualToString:@"0"]){
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"服务端异常,请稍后重试"];
            [alert show:^{
                
            }];
        } else {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"用户名或密码错误"];
            [alert show:^{
                
            }];
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
        AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"登录失败请查看网络"];
        [alert show:^{
            btn.userInteractionEnabled = YES;//恢复点击
        }];
    }];
}

//判断是否为邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passWordTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    //登录按钮
    if (_nickNameTextField.text.length > 0 && _passWordTextField.text.length >0) {
        [_loginBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x0BBF06, 1.0)] forState:UIControlStateNormal];
    } else {
        [_loginBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE6E6E6, 1.0)] forState:UIControlStateNormal];
    }
    //邮箱
    if (_nickNameTextField.text.length > 0) {
        _headImageView.image = [UIImage imageNamed:@"login_personal_selected"];
    } else {
        _headImageView.image = [UIImage imageNamed:@"login_personal_normal"];
    }
    //密码
    if (_passWordTextField.text.length > 0) {
        _passwordImageView.image = [UIImage imageNamed:@"personal_lock_selected"];
    } else {
        _passwordImageView.image = [UIImage imageNamed:@"personal_lock_normal"];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
}


- (void) setNav{
    self.navView = [[LoginNav alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor clearColor];
    [_navView addRightBtn];
    [_navView.rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    _navView.titleLabel.hidden = YES;
    _navView.rightBtn.frame = CGRectMake(ScreenWidth-15-40, 20+(44-49.0*0.5)/2, 40, 49.0*0.5);
    [_navView.rightBtn setTitleColor:UIColorFromRGB(0x0BBF06, 1.0) forState:UIControlStateNormal];
    [_navView.rightBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    [_navView.backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

- (void) backToLastPage {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:self.isHide];
}

- (void) requestCollection {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *token = userInfo[@"token"];
    NSString *platform = @"mobile-ios";
    NSString *channel = @"uu100";
    NSString *language = @"cn";
    NSString *combinStr = [NSString stringWithFormat:@"%@%@%@%@",token,platform,channel,language];
    NSString *md5Str = [combinStr md5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"token"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:channel forKey:@"channel"];
    [params setObject:language forKey:@"language"];
    [params setObject:md5Str forKey:@"sign"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://accountcdn.chinesetvall.com/app/member/doMyCollection.do" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *list = dic[@"collectionList"];
        for (int i = 0; i < list.count; i++) {
            NSNumber *albumId = list[i][@"albumId"];
            [self.collections addObject:albumId];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_collections forKey:@"collectionIDList"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
    }];
}

- (NSMutableArray *) collections {
    if (_collections == nil) {
        _collections = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _collections;
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
