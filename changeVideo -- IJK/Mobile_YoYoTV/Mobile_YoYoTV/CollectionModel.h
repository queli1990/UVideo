//
//  CollectionModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,copy) NSString *albumImg;
@property (nonatomic,copy) NSString *albumTitle;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic) BOOL pay;
@property (nonatomic,copy) NSString *watchTime;

+ (CollectionModel *)modelWithDictionary:(NSDictionary *) dic;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end
