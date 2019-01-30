//
//  FinishFolderModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/12/4.
//  Copyright © 2018 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinishFolderModel : NSObject

@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *count;
@property (nonatomic,copy) NSString *totalSize;

+ (FinishFolderModel *)modelWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) modelsWithArray:(NSArray *) array;

@end

NS_ASSUME_NONNULL_END
