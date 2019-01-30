//
//  HomeModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *newID = [dictionary valueForKey:@"id"];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [newDic removeObjectForKey:@"id"];
        [newDic setValue:newID forKey:@"ID"];
        
        NSString *newDescription = [dictionary valueForKey:@"description"];
        [newDic removeObjectForKey:@"description"];
        [newDic setValue:newDescription forKey:@"Description"];
        
        [self setValuesForKeysWithDictionary:newDic];
    }
    return self;
}

+ (HomeModel *)modelWithDictionary:(NSDictionary *)dictionary {
    HomeModel *model = [[HomeModel alloc] initWithDictionary:dictionary];
    return  model;
}

+ (NSArray *)modelsWithArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    if (array.count >= 1) {
        for (int i = 0; i<array.count; i++) {
            HomeModel *model = [HomeModel modelWithDictionary:array[i]];
            [mutableArray addObject:model];
        }
        return (NSArray *)mutableArray;
    }
    else {
        return nil;
    }
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"class name>> %@----UndefinedKey:%@",NSStringFromClass([self class]),key);
}


@end
