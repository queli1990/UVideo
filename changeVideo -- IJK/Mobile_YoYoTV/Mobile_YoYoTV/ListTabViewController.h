//
//  ListTabViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/10/11.
//  Copyright © 2018年 li que. All rights reserved.
//

/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

#import <UIKit/UIKit.h>

@interface ListTabViewController : UIViewController

/**顶部的标题**/
@property (nonatomic, copy) NSString *titleName;
//顶部滑动的标题数组
@property (nonatomic, strong) NSArray *datas;
//当前的某一个大分类下的ID(如：电影下的同步剧场等分类)
@property (nonatomic, assign) NSInteger currentIndex;
//当前的大分类(电影、综艺、动漫等)
@property (nonatomic, copy) NSString *genreID;
//所有的标题对应的genreID数组
@property (nonatomic, strong) NSArray *genreIDs;








@end
