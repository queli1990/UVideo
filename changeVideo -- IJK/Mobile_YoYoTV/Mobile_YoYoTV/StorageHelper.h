//
//  StorageHelper.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageHelper : NSObject

@property (nonatomic,strong) NSArray *storageArray;

+ (id)sharedSingleClass;

@end
