//
//  ShortVideoGenreModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import "ShortVideoGenreModel.h"

@implementation ShortVideoGenreModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

+ (ShortVideoGenreModel *)modelWithDictionary:(NSDictionary *)dic {
    ShortVideoGenreModel *model = [[ShortVideoGenreModel alloc] initWithDictionary:dic];
    return model;
}

+ (NSArray *) modelsWithArray:(NSArray *)array {
    NSMutableArray *tempArray = @[].mutableCopy;
    if (array.count >= 1) {
        for (int i = 0; i < array.count; i++) {
            ShortVideoGenreModel *model = [ShortVideoGenreModel modelWithDictionary:array[i]];
            [tempArray addObject:model];
        }
        return (NSArray *)tempArray;
    } else {
        return nil;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"class name>> %@----UndefinedKey:%@",NSStringFromClass([self class]),key);
}

@end
