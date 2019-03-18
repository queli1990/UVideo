//
//  Tools.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/2/28.
//  Copyright © 2019 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

/// 获取当前时间戳
+ (NSString *) getCurrentTime;

/// 毫秒数
+ (NSNumber *)getTimeStamp;

+ (NSString *)timeFormatted:(NSInteger)totalSeconds;

@end

NS_ASSUME_NONNULL_END
