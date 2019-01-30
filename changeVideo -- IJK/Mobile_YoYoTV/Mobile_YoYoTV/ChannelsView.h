//
//  ChannelsView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/11/17.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectNavIndexDelegate <NSObject>
- (void) selectedIndex:(NSInteger)index;
@end

//@protocol hideNavDelegate <NSObject>
//- (void) hideNav;
//@end

@interface ChannelsView : UIView
@property (nonatomic,weak) id<selectNavIndexDelegate>delegate;
//@property (nonatomic,weak) id<hideNavDelegate>hideDelegate;
//@property (nonatomic,strong) UIView *shadowView;
- (ChannelsView *) addChannelsWithTitles:(NSArray *)array withIndex:(NSInteger)index;
@end
