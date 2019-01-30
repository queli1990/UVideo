//
//  CalculateView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/12.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculateView : UIView

@property (nonatomic,strong) UIView *lineView;
/** 缓存 **/
@property (nonatomic,strong) UILabel *topLabel;
/** 剩余大小 **/
@property (nonatomic,strong) UILabel *leftLabel;

@end

NS_ASSUME_NONNULL_END
