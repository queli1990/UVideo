//
//  PostBaseHttpRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/2.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface PostBaseHttpRequest : NSObject

@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) id _data;
@property (nonatomic,copy) NSString *flag;

typedef void (^PostBasehttpResponseBlock)(PostBaseHttpRequest *responseData);
typedef void (^PostBasehttpFlagBlock)(NSString *flag);


-(void)basePostDataRequest:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix andBlock:(PostBasehttpResponseBlock)block andFailure:(PostBasehttpResponseBlock)failureBlock;


- (void) basePostFlagRequest:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix andBlock:(PostBasehttpFlagBlock)block andFailure:(PostBasehttpFlagBlock)failureBlock;


@end
