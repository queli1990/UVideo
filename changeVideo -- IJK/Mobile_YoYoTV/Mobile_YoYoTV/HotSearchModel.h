//
//  HotSearchModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/3/6.
//  Copyright © 2019 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotSearchModel : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,copy) NSString *name;

+ (HotSearchModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end

NS_ASSUME_NONNULL_END
