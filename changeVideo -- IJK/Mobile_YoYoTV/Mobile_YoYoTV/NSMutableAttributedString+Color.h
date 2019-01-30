//
//  NSMutableAttributedString+Color.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/12.
//  Copyright © 2018 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Color)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
