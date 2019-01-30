//
//  UUInputVIew.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/21.
//  Copyright © 2019 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUInputView;

@protocol UUInputViewDelegate <NSObject>

- (void) UUInputView:(UUInputView *)inputView sendMessage:(NSString *)message;

@end


@interface UUInputView : UIView

@property (nonatomic, strong) UIButton *btnSendMessage;

@property (nonatomic, strong) UITextView *textViewInput;

@property (nonatomic, assign) id<UUInputViewDelegate>delegate;

- (void) clearInput:(NSString *)inputText;

@end

NS_ASSUME_NONNULL_END
