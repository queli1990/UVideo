//
//  ChatModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/17.
//  Copyright © 2019 li que. All rights reserved.
//

#import "ChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"

static NSString *BaseUrl = @"http://videocdn.chinesetvall.com/";

@implementation ChatModel

- (void) getInfoData:(void (^)(BOOL isSuccess))complement {
    NSDictionary *params = @{@"device_id":[YDDevice getUQID]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"feedbackInfo"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self dealData:contentDic];
        complement(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error ---- %@",error);
        complement(NO);
    }];
}

// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
//    [dataDic setObject:@"Hi:sister" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;


- (void)recountFrame
{
    [self.dataSource enumerateObjectsUsingBlock:^(UUMessageFrame * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.message = obj.message;
    }];
}

#pragma mark 将数据添加到数组中
- (void) dealData:(NSDictionary *)contentDic {
    NSMutableArray<UUMessageFrame *> *result = [NSMutableArray array];
    NSArray *usersArray = contentDic[@"feedbacks"];
    for (int i = 0; i < usersArray.count; i++) {
        NSDictionary *dic = usersArray[i];
        NSNumber *ID = dic[@"roleId"];
        NSDictionary *dataDic;
        if (ID.intValue == 1) { // 用户
             dataDic = [self setUserInfo:dic];
        } else if (ID.intValue == 2) { // 系统
            dataDic = [self setReadSysInfo:dic];
        }
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    NSDictionary *sysDic = contentDic[@"sysmsg"];
    if (sysDic.allKeys.count > 0) {
        NSDictionary *dataDic = [self setUnreadSysInfo:sysDic];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
        // 请求到数据则上报，且标志位已读
        [self postReadMsgType:sysDic[@"id"] content:sysDic[@"content"] sendSuccess:^(BOOL isSendSuccess) {
            
        }];
    }
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:result];
}

// 用户发送的
- (NSDictionary *) setUserInfo:(NSDictionary *)infoDic {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
    [dictionary setObject:@(UUMessageTypeText) forKey:@"type"];
    [dictionary setObject:infoDic[@"msg"] forKey:@"strContent"];
    NSNumber *dateNum = infoDic[@"actionDate"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.integerValue/1000];
    [dictionary setObject:[date description] forKey:@"strTime"];
    return dictionary;
}

- (NSDictionary *) setReadSysInfo:(NSDictionary *)infoDic {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(UUMessageTypeText) forKey:@"type"];
    [dictionary setObject:infoDic[@"msg"] forKey:@"strContent"];
    NSNumber *dateNum = infoDic[@"actionDate"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.integerValue/1000];
    [dictionary setObject:[date description] forKey:@"strTime"];
    return dictionary;
}

// 取出字典中相应数据
- (NSDictionary *) setUnreadSysInfo:(NSDictionary *)infoDic {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(UUMessageTypeText) forKey:@"type"];
    [dictionary setObject:infoDic[@"content"] forKey:@"strContent"];
    [dictionary setObject:[[NSDate date] description] forKey:@"strTime"];
    return dictionary;
}

// 上报已读的消息
- (void) postReadMsgType:(NSString *)codeStr content:(NSString *)contentStr sendSuccess:(void(^)(BOOL isSendSuccess))complement {
    NSString *device_id = [YDDevice getUQID];
    NSString *newsID = codeStr;
    NSNumber *action_date = [self getTimeStamp];
    NSString *platform = @"ios";
    NSString *msg = contentStr;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    // 获取App的build版本
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSDictionary *params = @{@"device_id":device_id,
                             @"news_id":newsID,
                             @"action_date":action_date,
                             @"platform":platform,
                             @"msg":msg,
                             @"version_number":appBuildVersion,
                             @"version_code":appVersion
                             };
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"feedbacks"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        complement(contentDic[@"success"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error ---- %@",error);
        complement(NO);
    }];
}

// 获取是否存在未读的系统消息
- (void) hasNewMsg:(void(^)(BOOL isHave))complement {
    NSDictionary *params = @{@"device_id":[YDDevice getUQID]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"hasnewmsg"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str = [NSString stringWithFormat:@"%@",contentDic[@"data"]];
        BOOL isHave = str.integerValue > 0 ? YES : NO;
        complement(isHave);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error ---- %@",error);
        complement(NO);
    }];
}

- (NSNumber *)getTimeStamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return [NSNumber numberWithInteger:timeString.integerValue];
}

@end
