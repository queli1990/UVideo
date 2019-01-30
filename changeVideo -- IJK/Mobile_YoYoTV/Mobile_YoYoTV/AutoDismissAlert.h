//
//  AutoDismissAlert.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/30.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoDismissAlert : UIView

typedef void (^finishBlock)();

-(instancetype)initWithTitle:(NSString *)msg;

- (void) show:(finishBlock)block;

@end


