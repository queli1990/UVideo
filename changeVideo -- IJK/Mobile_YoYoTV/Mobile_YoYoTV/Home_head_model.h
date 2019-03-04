//
//  Home_head_model.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/15.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Home_head_model : NSObject

@property (nonatomic,copy) NSString *landscape_poster_m;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSNumber *ID;

+ (Home_head_model *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;


@end
