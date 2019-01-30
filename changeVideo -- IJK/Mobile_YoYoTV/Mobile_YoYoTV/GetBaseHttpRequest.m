//
//  GetBaseHttpRequest.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GetBaseHttpRequest.h"
//#define baseURL_vego @"http://cdn.100uu.tv"//线上
#define baseURL_vego @"http://videocdn.chinesetvall.com"
//#define baseURL_vego @"http://dw4f3k6eh2fyb.cloudfront.net/"

@implementation GetBaseHttpRequest

-(void)baseGetRequest:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix andBlock:(basehttpResponseBlock)block andFailure:(basehttpResponseBlock)failureBlock{
    
    NSString*url = [self buildUrlStr:params andTransactionSuffix:urlSuffix];
        NSLog(@"url:%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self._data = responseObject;
        block(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _error = error;
        failureBlock(self);
    }];
}

-(NSString*)buildUrlStr:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix{
    
    NSMutableString *urlString =[NSMutableString string];
    [urlString appendString:baseURL_vego];
    [urlString appendString:urlSuffix];
    NSString *escapedString;
    NSInteger keyIndex = 0;
    
    for (id key in params) {
        if(keyIndex == 0){
            escapedString = [self togetherParams:[params valueForKey:key]];
            [urlString appendFormat:@"?%@=%@",key,escapedString];
        }else{
            escapedString = [self togetherParams:[params valueForKey:key]];
            [urlString appendFormat:@"&%@=%@",key,escapedString];
        }
        keyIndex ++;
    }
//        NSLog(@"urlstring:%@",urlString);
    return urlString;
}

- (NSString *) togetherParams:(NSString *)eachItemString {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *escapedString = [eachItemString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return escapedString;
}

@end
