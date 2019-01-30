//
//  ChatModel.h
//  Mobile_YoYoTV
//
//  Created by li que on 2019/1/17.
//  Copyright © 2019 li que. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UUMessageFrame;
@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray<UUMessageFrame *> *dataSource;

- (void) getInfoData:(void (^)(BOOL isSuccess))complement;

- (void)addSpecifiedItem:(NSDictionary *)dic;

- (void)recountFrame;

// 获取是否有未读的系统消息
- (void) hasNewMsg:(void(^)(BOOL isHave))complement;

// 标志成已阅读
- (void) postReadMsgType:(NSString *)codeStr content:(NSString *)contentStr sendSuccess:(void(^)(BOOL isSendSuccess))complement;

@end

NS_ASSUME_NONNULL_END
