//
//  PlayerModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/25.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

@property (nonatomic,copy) NSString *quality;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSNumber *width;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,copy) NSString *expires;//
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *created_time;
@property (nonatomic,strong) NSNumber *fps;
@property (nonatomic,strong) NSNumber *size;
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *link_secure;//

+ (PlayerModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end
