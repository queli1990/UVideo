//
//  PlayHistoryModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/6.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayHistoryModel : NSObject

@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,copy) NSString *albumImg;
@property (nonatomic,copy) NSString *albumTitle;
@property (nonatomic,copy) NSNumber *episodes;
@property (nonatomic,copy) NSNumber *ID;
@property (nonatomic,copy) NSString *playbackProgress;
@property (nonatomic,copy) NSString *watchTime;
@property (nonatomic) BOOL pay;

+ (PlayHistoryModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end
