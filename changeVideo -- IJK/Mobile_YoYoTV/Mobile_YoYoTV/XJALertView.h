//
//  XJALertView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectTypeDelegate <NSObject>

- (void) selectedBtn:(UIButton *)btn;

@end

@interface XJALertView : UIView

@property (nonatomic,weak) id<SelectTypeDelegate>delegate;
@property (nonatomic,assign) NSInteger currentIndex;

- (void) setupArrayView:(NSArray *)array;
- (void) showAlert;
- (void) dismissAlert;

@end

NS_ASSUME_NONNULL_END
