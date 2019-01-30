//
//  UserBaseRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"

@interface UserBaseRequest : NSObject

@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) id _data;

typedef void (^userHttpResponseBlock)(UserBaseRequest *responseData);

- (void) getUserRequest:(NSDictionary *)params andTransactionSuffix:(NSString *)urlSuffix andBlock:(userHttpResponseBlock)block andFailure:(userHttpResponseBlock)failureBlock;

-(void)postUserRequest:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix andBlock:(userHttpResponseBlock)block andFailure:(userHttpResponseBlock)failureBlock;
@end
