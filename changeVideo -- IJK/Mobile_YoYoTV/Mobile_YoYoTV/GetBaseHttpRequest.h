//
//  GetBaseHttpRequest.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"

@interface GetBaseHttpRequest : NSObject

@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) id _data;

typedef void (^basehttpResponseBlock)(GetBaseHttpRequest *responseData);

-(void)baseGetRequest:(NSDictionary *)params andTransactionSuffix:(NSString *) urlSuffix andBlock:(basehttpResponseBlock)block andFailure:(basehttpResponseBlock)failureBlock;


@end
