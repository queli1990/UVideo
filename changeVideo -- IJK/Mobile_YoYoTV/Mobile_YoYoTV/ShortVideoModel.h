//
//  ShortVideoModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/18.
//  Copyright © 2018 li que. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ShortVideoModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *imgURL;


+ (ShortVideoModel *)modelWithDictionary:(NSDictionary *)dic;

+ (NSArray *) modelsWithArray:(NSArray *)array;

@end


