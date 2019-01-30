//
//  GenresModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "GenresModel.h"

@implementation GenresModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *newID = [dictionary valueForKey:@"id"];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [newDic removeObjectForKey:@"id"];
        [newDic setValue:newID forKey:@"ID"];
        [self setValuesForKeysWithDictionary:newDic];
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"class name>> %@----UndefinedKey:%@",NSStringFromClass([self class]),key);
}

+ (GenresModel *)modelWithDictionary:(NSDictionary *) dictionary{
    GenresModel *model = [[GenresModel alloc] initWithDictionary:dictionary];
    return  model;
}


+ (NSArray *) modelsWithArray:(NSArray *) array{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    if (array.count >= 1) {
        for (int i = 0; i<array.count; i++) {
            GenresModel *model = [GenresModel modelWithDictionary:array[i]];
            [mutableArray addObject:model];
        }
        return (NSArray *)mutableArray;
    }
    else {
        return nil;
    }
}

@end
