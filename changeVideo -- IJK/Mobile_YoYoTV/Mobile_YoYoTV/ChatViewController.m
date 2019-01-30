//
//  ChatViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/17.
//  Copyright © 2019 li que. All rights reserved.
//

#import "ChatViewController.h"
//#import "UUInputFunctionView.h"
#import "UUInputView.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "UUChatCategory.h"
#import "NavView.h"

@interface ChatViewController ()<UUInputViewDelegate, UUMessageCellDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _keyboardHeight;
}
@property (strong, nonatomic) ChatModel *chatModel;

@property (strong, nonatomic) UITableView *chatTableView;

@property (strong, nonatomic) UUInputView *inputFuncView;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7, 1.0);
    [self setupNav];
    [self loadBaseViewsAndData];
//    _chatTableView.frame = CGRectMake(0, 64, self.view.uu_width, self.view.uu_height-64-56);
//    _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, 56);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustCollectionViewLayout) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_inputFuncView.textViewInput.isFirstResponder) {
        _chatTableView.frame = CGRectMake(0, 64, self.view.uu_width, self.view.uu_height-64-56-_keyboardHeight);
        _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, 56);
    } else {
        _chatTableView.frame = CGRectMake(0, 64, self.view.uu_width, self.view.uu_height-64-56);
        _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, 56);
    }
}

#pragma mark - prive methods

- (void)initBasicViews
{
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.uu_width, self.view.uu_height-64-56) style:UITableViewStylePlain];
    _chatTableView.backgroundColor = UIColorFromRGB(0xF7F7F7, 1.0);
    _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    [self.view addSubview:_chatTableView];
    
    [_chatTableView registerClass:[UUMessageCell class] forCellReuseIdentifier:NSStringFromClass([UUMessageCell class])];
    
    _inputFuncView = [[UUInputView alloc] initWithFrame:CGRectMake(0, _chatTableView.uu_bottom, self.view.uu_width, 56)];
    _inputFuncView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _inputFuncView.delegate = self;
    [self.view addSubview:_inputFuncView];
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc] init];
    [self.chatModel getInfoData:^(BOOL isSuccess) {
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initBasicViews];
                [self.chatTableView reloadData];
                [self tableViewScrollToBottom];
            });
        }else {
            AutoDismissAlert *alert = [[AutoDismissAlert alloc] initWithTitle:@"请检查您的网络"];
            [alert show:^{
                
            }];
        }
    }];
}

#pragma mark - notification event

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0) { return; }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    _keyboardHeight = keyboardEndFrame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    self.chatTableView.uu_height = self.view.uu_height - _inputFuncView.uu_height;
    self.chatTableView.uu_height -= notification.name == UIKeyboardWillShowNotification ? _keyboardHeight:0;
    self.chatTableView.contentOffset = CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.uu_height+64);
    
    self.inputFuncView.uu_top = self.chatTableView.uu_bottom;
    
    [UIView commitAnimations];
}

- (void)adjustCollectionViewLayout
{
    [self.chatModel recountFrame];
    [self.chatTableView reloadData];
}

#pragma mark - InputFunctionViewDelegate
- (void) UUInputView:(UUInputView *)inputView sendMessage:(NSString *)message {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) { // 没有网络
            [ShowErrorAlert showErrorMeg:@"当前没有网络，请检查您的网络" withViewController:self finish:^{
                
            }];
        } else {
            NSDictionary *dic = @{@"strContent": message,
                                  @"type": @(UUMessageTypeText)};
            inputView.textViewInput.text = @"";
            [inputView clearInput:@""];
            [self dealTheFunctionData:dic];
            [self.chatModel postReadMsgType:@"0" content:message sendSuccess:^(BOOL isSendSuccess) {
                NSLog(@"上传数据成功：%@",(isSendSuccess)?@"YES":@"NO");
            }];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UUMessageCell class])];
    cell.delegate = self;
    cell.messageFrame = self.chatModel.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark NavView
- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"消息与反馈";
    [self.view addSubview:nav];
}

- (void) goBack:(UIButton *)btn {
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

@end
