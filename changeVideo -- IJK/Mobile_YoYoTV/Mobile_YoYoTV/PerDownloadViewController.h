//
//  PerDownloadViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/21.
//  Copyright © 2018 li que. All rights reserved.
//
/**
 *　　　　　　　 ┏┓       ┏┓+ +
 *　　　　　　　┏┛┻━━━━━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　 ┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 █████━█████  ┃+
 *　　　　　　　┃　　　　　　 ┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　 ┃ + +
 *　　　　　　　┗━━┓　　　 ┏━┛
 *               ┃　　  ┃
 *　　　　　　　　　┃　　  ┃ + + + +
 *　　　　　　　　　┃　　　┃　Code is far away from     bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　         神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　 ┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━━━┳┓┏┛ + + + +
 *　　　　　　　　　 ┃┫┫　 ┃┫┫
 *　　　　　　　　　 ┗┻┛　 ┗┻┛+ + + +
 */

#import <UIKit/UIKit.h>
#import "PlayerModel.h"
#import "HomeModel.h"

typedef NS_ENUM(NSInteger, VideoType) {
    varietyType = 4, // 综艺
    videoType = 3, // 电影
    episodeType = 0, // 非电影和综艺的。主要是是电视剧
};


@interface PerDownloadViewController : UIViewController

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) int type;
@property (nonatomic,strong) NSMutableDictionary *vimeoDataDic;
@property (nonatomic,strong) NSArray *vimeoDataArray;
//@property (nonatomic,copy) NSString *imgURL;
@property (nonatomic,strong) HomeModel *model;

@end

