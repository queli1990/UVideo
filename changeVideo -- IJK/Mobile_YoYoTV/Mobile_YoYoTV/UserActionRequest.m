//
//  UserActionRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/13.
//  Copyright © 2018 li que. All rights reserved.
//

#import "UserActionRequest.h"
#import "PlayerCollectionReusableView.h"

//static NSString *baseUrl = @"http://192.168.188.189:8088";
static NSString *baseUrl = @"http://analytics.chinesetvall.com";

@implementation UserActionRequest

+ (void) postOnceUserDevice {
    BOOL havePostUserInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"postOnceUserDevice"] boolValue];
    if (havePostUserInfo) {
        return;
    }
    NSString *deviceId = [YDDevice getUQID];
    NSString *manufacturer = @"iOS"; // 设备厂商
    NSString *deviceModel = [[PlayerCollectionReusableView new] getDeviceName]; // 设备型号
    NSString *resolution = [[PlayerCollectionReusableView new] getDeviceName]; // 分辨率
    NSString *version = [[UIDevice currentDevice] systemVersion]; // 系统版本
    NSString *language = [[NSLocale currentLocale] localeIdentifier];
    NSString *platform = @"appStore";
    NSString *channel = @"appStore";
    NSString *appName =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSDictionary *params = @{@"deviceId":deviceId,
                             @"manufacturer":manufacturer,
                             @"deviceModel":deviceModel,
                             @"resolution":resolution,
                             @"version":version,
                             @"language":language,
                             @"platform":platform,
                             @"channel":channel,
                             @"appName":appName,
                             @"appVersion":appVersion
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://analytics.chinesetvall.com/service/device" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"postOnceUserDevice"];
        NSLog(@"class name>> %@----success:%@",NSStringFromClass([self class]),dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"class name>> %@----error:%@",NSStringFromClass([self class]),error);
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"postOnceUserDevice"];
    }];
}

+ (void) postVideoInfo:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://analytics.chinesetvall.com/service/playrecord" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postVideoInfo>> %@----success:%@",NSStringFromClass([self class]),dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"postVideoInfo>> %@----error:%@",NSStringFromClass([self class]),error);
    }];
}

+ (void) postDetailPageEventCode:(NSString *)eventCode successCode:(NSNumber *)sucCode beginTime:(NSNumber *)beginTime endTime:(NSNumber *)endTime episode:(NSNumber *)episode albumId:(NSNumber *)albumId albumName:(NSString *)albumName {
    // 容错处理
    if (!eventCode || !sucCode || !beginTime || !endTime || !episode || !albumId || !albumName) {
        return;
    }
    NSDictionary *event = @{@"startTime":beginTime,
                            @"endTime":endTime,
                            @"order":@0,
                            @"pageEvent":eventCode,
                            @"success":sucCode,
                            @"episode":episode
                            };
    NSArray *arr = [NSArray arrayWithObject:event];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *params = @{
                             @"deviceId":[YDDevice getUQID],
                             @"pageEvents":arr,
                             @"pageName":@"1000100006",
                             @"platform":@"ios",
                             @"sysVersion":[[UIDevice currentDevice] systemVersion],
                             @"appName":[infoDictionary objectForKey:@"CFBundleName"],
                             @"appVersion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
                             @"albumId":albumId,
                             @"albumName":albumName
                             };
    [UserActionRequest postDetailPageEvent:params];
}

+ (void) postDetailPageEvent:(NSDictionary *)params {
    // iTunes后台crash，先这样容错，具体看2.4版本，是否还存在这样的crash
    if (!params) return;
//    NSString *requestUrl = @"http://analytics.chinesetvall.com/service/pageaccessduration";
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"/service/pageeventduration"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval= 20;//设置超时时间
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//设置发送数据格式类型
    // 你的字典数据,后面会将该字典转化为body体数据
    NSError *error = nil;
    //将字典转为化NSData数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //当json转化不成功的时候结束请求的发送
    if(error){return;}
    //将NSData 放入body体
    [request setHTTPBody:jsonData];
    //设置可以接收的数据格式
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    //发送请求
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"xx");
    }] resume];
    
    
//    "deviceId":"3c72627db99d4cf79a0b9e52eb4f6e3e",
//    "pageEvents":[{"endTime":1542074924177,
//                    "order":0,
//                    "pageEvent":"albumApi0",
//                    "startTime":1542074924177,
//                    "success":1},
//                  {"endTime":1542074924177,
//                      "order":0,
//                      "pageEvent":"albumApi1",
//                      "startTime":1542074924177,
//                      "success":1}],
//    "pageName":"album detial page"}
}

+ (void) postDownload:(NSDictionary *)params complent:(void(^)(NSDictionary *dic))complent {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"/service/albumdownload"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval= 20;//设置超时时间
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//设置发送数据格式类型
    // 你的字典数据,后面会将该字典转化为body体数据
    NSError *error = nil;
    //将字典转为化NSData数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //当json转化不成功的时候结束请求的发送
    if(error){return;}
    //将NSData 放入body体
    [request setHTTPBody:jsonData];
    //设置可以接收的数据格式
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    //发送请求
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            complent(dic);
        }
    }] resume];
}

+ (void) postOfflinePlayback:(NSDictionary *)params complent:(void(^)(NSDictionary *dic))complent {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"/service/offlineplayback"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval= 20;//设置超时时间
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//设置发送数据格式类型
    // 你的字典数据,后面会将该字典转化为body体数据
    NSError *error = nil;
    //将字典转为化NSData数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //当json转化不成功的时候结束请求的发送
    if(error){return;}
    //将NSData 放入body体
    [request setHTTPBody:jsonData];
    //设置可以接收的数据格式
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    //发送请求
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            complent(dic);
        }
    }] resume];
}



@end
