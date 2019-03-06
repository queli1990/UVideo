//
//  HotSearchModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/3/6.
//  Copyright © 2019 li que. All rights reserved.
//

#import "HotSearchModel.h"

@implementation HotSearchModel

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

+ (HotSearchModel *)modelWithDictionary:(NSDictionary *) dictionary {
    HotSearchModel *model = [[HotSearchModel alloc] initWithDictionary:dictionary];
    return model;
}


+ (NSArray *) modelsWithArray:(NSArray *) array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    if (array.count >= 1) {
        for (int i = 0; i<array.count; i++) {
            HotSearchModel *model = [HotSearchModel modelWithDictionary:array[i]];
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
