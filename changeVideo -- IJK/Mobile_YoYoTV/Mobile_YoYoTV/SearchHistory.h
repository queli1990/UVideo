//
//  SearchHistory.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryBtnClickDelegate <NSObject>
- (void) passKeyword:(NSString *)str;
@end

@interface SearchHistory : UIView
@property (nonatomic,strong) UIButton *clearHistoryBtn;
@property (nonatomic,weak) id<HistoryBtnClickDelegate> delegate;
- (void) addHistoryView:(NSArray *)historyArray;
@end
