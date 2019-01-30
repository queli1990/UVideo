//
//  GenresModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenresModel : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *genre_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *image_normal;
@property (nonatomic,copy) NSString *image_focus;

+ (GenresModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end
