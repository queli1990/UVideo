//
//  Tools.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/2/28.
//  Copyright © 2019 li que. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString *) getCurrentTime {
    //获取当前时间
    NSDate *now = [NSDate date];
    //创建日期格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    return [dateFormatter stringFromDate:now];
}

+ (NSNumber *)getTimeStamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return [NSNumber numberWithInteger:timeString.integerValue];
}

+ (NSString *)timeFormatted:(NSInteger)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
