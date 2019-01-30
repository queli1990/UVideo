//
//  SearchResultTableView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/24.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultTableViewCell.h"

@interface SearchResultTableView : UIView

typedef void (^callBackSelectedItem)(SearchResultModel *model);
typedef void (^FinishLoad)();

@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,copy) callBackSelectedItem passHomeModel;

- (void) requestDataWhenLoaded:(FinishLoad) callback;

@end
