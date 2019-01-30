//
//  NineBoxView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DownloadImgView.h"
#import "NineBoxView.h"
#import "NineBoxDownloadBtn.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ClickDownloadBtnDelegate <NSObject>

- (void) selectBtn:(NineBoxDownloadBtn *)btnView withArray:(NSArray *)array;

@end

@interface NineBoxView : UIView

@property (nonatomic,weak) id<ClickDownloadBtnDelegate>delegate;
//@property (nonatomic,strong) DownloadImgView *downloadImgView;

- (NSDictionary *) setupViewWithArray:(NSArray *)array episodeID:(NSString *) ID;

@end

NS_ASSUME_NONNULL_END
