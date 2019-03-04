//
//  MainHomeModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/3/4.
//  Copyright © 2019 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainHomeModel : NSObject

@property (nonatomic,copy) NSString *update_progress;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *landscape_poster_s;
@property (nonatomic,copy) NSString *attributes;
@property (nonatomic,strong) NSNumber *ID;

+ (MainHomeModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end

NS_ASSUME_NONNULL_END
