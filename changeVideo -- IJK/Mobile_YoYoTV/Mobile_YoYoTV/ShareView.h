//
//  ShareView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/7.
//  Copyright © 2018年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTypeButton.h"

@protocol ShareResultDelegate <NSObject>

- (void) shareCallBack:(NSDictionary *)dic;

@end

typedef void (^shareBtnCallBack)(SEL sel);

@interface ShareView : UIView

@property (nonatomic,copy) shareBtnCallBack shareCallback;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,weak) id<ShareResultDelegate> delegate;
@property (nonatomic,strong) NSDictionary *passParams;

- (void) setViewWithTitles:(NSArray *)titles imgs:(NSArray *)imgs shareParams:(NSDictionary *)params;

@end
