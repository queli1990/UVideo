//
//  MainHomeModel.m
//  Mobile_YoYoTV
//
//  Created by li que on 2019/3/4.
//  Copyright © 2019 li que. All rights reserved.
//

#import "MainHomeModel.h"

@implementation MainHomeModel

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

+ (MainHomeModel *)modelWithDictionary:(NSDictionary *) dictionary {
    MainHomeModel *model = [[MainHomeModel alloc] initWithDictionary:dictionary];
    return model;
}

+ (NSArray *)modelsWithArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    if (array.count >= 1) {
        for (int i = 0; i<array.count; i++) {
            MainHomeModel *model = [MainHomeModel modelWithDictionary:array[i]];
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
