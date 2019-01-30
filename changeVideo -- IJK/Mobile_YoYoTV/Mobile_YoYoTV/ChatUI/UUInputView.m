//
//  UUInputVIew.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/21.
//  Copyright © 2019 li que. All rights reserved.
//

#import "UUInputView.h"

@interface UUInputView()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeHold;

@end


@implementation UUInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 发送按钮
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnSendMessage setTitle:@"发送" forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:17];
        self.btnSendMessage.titleLabel.textColor = [UIColor grayColor];
        self.btnSendMessage.backgroundColor = UIColorFromRGB(0x0BBF06, 1.0);
        self.btnSendMessage.layer.cornerRadius = 4;
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        // 输入框
        self.textViewInput = [[UITextView alloc] init];
        self.textViewInput = [[UITextView alloc] init];
        self.textViewInput.layer.cornerRadius = 4;
        self.textViewInput.layer.masksToBounds = YES;
        self.textViewInput.delegate = self;
        self.textViewInput.layer.borderWidth = 1;
        self.textViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.textViewInput];
        
        //输入框的提示语
        _placeHold = [[UILabel alloc] init];
        _placeHold.text = @"请输入您的反馈";
        _placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.textViewInput addSubview:_placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 上8 下8 共56高
    self.textViewInput.frame = CGRectMake(10, 8, ScreenWidth-8-10-10-70, 40);
    self.btnSendMessage.frame = CGRectMake(CGRectGetMaxX(_textViewInput.frame)+8, 8, 70, 40);
    self.placeHold.frame = CGRectMake(20, 0, 200, 40);
}

- (void) sendMessage:(UIButton *)btn {
    NSString *resultStr = [self.textViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
    [self.delegate UUInputView:self sendMessage:resultStr];
}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeHold.hidden = textView.text.length>0;
    [self clearInput:textView.text];
}

- (void) clearInput:(NSString *)inputText {
    if (inputText.length > 0) {
//        self.btnSendMessage.titleLabel.textColor = [UIColor whiteColor];
        self.btnSendMessage.userInteractionEnabled = YES;
    } else {
//        self.btnSendMessage.titleLabel.textColor = [UIColor grayColor];
        self.btnSendMessage.userInteractionEnabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
