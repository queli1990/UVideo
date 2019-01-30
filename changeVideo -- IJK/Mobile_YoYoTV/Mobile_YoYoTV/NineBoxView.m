//
//  NineBoxView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/11/22.
//  Copyright © 2018 li que. All rights reserved.
//

#import "NineBoxView.h"

@interface NineBoxView()
@property (nonatomic,strong) NSArray *tempArray;
@property (nonatomic, assign) NSUInteger allOccupySize;
@property (nonatomic, assign) NSUInteger allTempSize;
@property (nonatomic, assign) NSUInteger currentDownloadCount;
@end

@implementation NineBoxView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (NSDictionary *) setupViewWithArray:(NSArray *)array episodeID:(NSString *) ID {
    self.tempArray = array;
    CGFloat leftGap = 15; // 最左边和最右边的间距
    CGFloat horizontalGap = 20; // 两个item之间水平的间距
    CGFloat verticalGap = 14; // 两个item之间竖直的间距
    CGFloat width = (ScreenWidth - leftGap*2 - (5-1)*horizontalGap) / 5; // 宽
    CGFloat height = width; // 高
    CGFloat top = 20; // 最顶部的高度
    
    // loading
    [SVProgressHUD show];
    
    // 匹配数据库中当前专辑,如果当前的专辑已经有下载完成的集数，则还需要for循环比对状态
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];
    NSMutableArray *episodeArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < cacheData.count; i++) {
        HWDownloadModel *model = cacheData[i];
        _allOccupySize += model.totalFileSize;
        if (model.state != HWDownloadStateFinish) {
            _allTempSize += model.tmpFileSize;
        }
        NSArray *strArray = [model.vid componentsSeparatedByString:@"-"];
        if ([strArray[0] isEqualToString:ID]) { // 放入当前专辑
            [episodeArray addObject:model];
            _currentDownloadCount += 1;
        }
    }
    
    
    for (NSInteger i = 0; i < array.count; i++) {
        NineBoxDownloadBtn *btnView = [[NineBoxDownloadBtn alloc] init];
        NSInteger column = i / 5; // 列
        NSInteger row = i % 5; // 行
        btnView.frame = CGRectMake(leftGap+row*(width+horizontalGap), top+column*(height+verticalGap), width, height);
        btnView.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)i+1];
        btnView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
        btnView.tag = 1000 + i;
        
        HWDownloadModel *downloadModel = [[HWDownloadModel alloc] init];
        downloadModel.fileName = [array[i] objectForKey:@"name"];
        downloadModel.vid = [NSString stringWithFormat:@"%@-%ld",ID,i+1];
        if (![[array[i] objectForKey:@"pictures"] isEqual:[NSNull null]]) {
            NSArray *pictures = [array[i] objectForKey:@"pictures"];
            downloadModel.imageURL = [pictures[2] objectForKey:@"link"];
        }
        // 赋值状态
        for (int j = 0; j < episodeArray.count; j++) {
            HWDownloadModel *libraryModel = episodeArray[j];
            if ([libraryModel.fileName isEqualToString:downloadModel.fileName]) {
                downloadModel.state = libraryModel.state;
            }
        }
        
        NSDictionary *dic = [[self sortArray:[NSMutableArray arrayWithArray:array]] objectAtIndex:i];
        NSArray *sortArray = [self sortArray:dic[@"files"]];
        btnView.downloadUrlArray = sortArray;
        btnView.model = downloadModel;
        btnView.episodeID = ID;
        
        [btnView addTarget:self action:@selector(click:)];
        [self addSubview:btnView];
        
        [SVProgressHUD dismiss];
    }
    NSDictionary *params = @{@"allTempSize":[NSNumber numberWithInteger:_allTempSize],@"allOccupySize":[NSNumber numberWithInteger:_allOccupySize],@"currentDownloadCount":[NSNumber numberWithInteger:_currentDownloadCount]};
    return params;
}

// 数组排序
- (NSArray *) sortArray:(NSMutableArray *)tempArray {
    for (int i = 0; i < tempArray.count; i++) {
        if ([[tempArray[i] objectForKey:@"quality"] isEqualToString:@"hls"]) {
            [tempArray removeObject:tempArray[i]];
        }
    }
    [tempArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
     {
         //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
         if ([obj1[@"height"] integerValue] > [obj2[@"height"] integerValue]){
             return NSOrderedDescending;
         } else {
             return NSOrderedAscending;
         }
     }];
    return tempArray;
}

- (void) click:(NineBoxDownloadBtn *)btnView {
    if ([self.delegate respondsToSelector:@selector(selectBtn:withArray:)]) {
        [self.delegate selectBtn:btnView withArray:self.tempArray];
    }
}



@end
