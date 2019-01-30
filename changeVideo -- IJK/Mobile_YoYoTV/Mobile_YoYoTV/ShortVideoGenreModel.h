//
//  ShortVideoGenreModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortVideoGenreModel : NSObject
@property (nonatomic,copy) NSString *vimeo_token;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSNumber *eps;
@property (nonatomic,copy) NSString *vimeo_id;

+ (ShortVideoGenreModel *)modelWithDictionary:(NSDictionary *)dic;

+ (NSArray *) modelsWithArray:(NSArray *)array;

@end



NS_ASSUME_NONNULL_END
