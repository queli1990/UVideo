//
//  PlayerCollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/8/10.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerCollectionReusableView.h"
#import "NSString+QT.h"
#import "sys/utsname.h"


@interface PlayerCollectionReusableView()

@end

@implementation PlayerCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void) dealResponseData:(PlayerRequest *)responseData {
    CGFloat height = 0.0 ;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    if (self.model.genre_id.integerValue == 3) {//电影
        //NSLog(@"%@",responseData.vimeo_responseDataDic);
        height = 13+22+136;
        [tempArray addObject:responseData.vimeo_responseDataDic];
        self.vimeoResponseDic = responseData.vimeo_responseDataDic;
    } else if (self.model.genre_id.integerValue == 4) {//综艺
        //NSLog(@"%@",responseData.vimeo_responseDataArray);
        [tempArray addObjectsFromArray:responseData.vimeo_responseDataArray];
        self.vimeoResponseArray = responseData.vimeo_responseDataArray;
        height = 13+22+14+22+8+66;
    } else {//电视剧或者动漫及其他
        //NSLog(@"%@",responseData.vimeo_responseDataArray);
        [tempArray addObjectsFromArray:responseData.vimeo_responseDataArray];
        self.vimeoResponseArray = responseData.vimeo_responseDataArray;
        if (responseData.vimeo_responseDataArray.count > 1) {
            height = 13+22+14+22+8+40;
        }else {
            height = 13+22+136;
        }
    }
    
    
    self.videoInfoView = [[PlayVCContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    _videoInfoView.delegate = self;
    _videoInfoView.genre_id = self.model.genre_id;
    _videoInfoView.selectedIndex = self.selectedIndex;
    _videoInfoView.playUrlArray = tempArray;
    [_videoInfoView addContentView];
    _videoInfoView.videoNameLabel.text = self.model.name;
    
//    self.videoInfoView.descriptionLabel.text = [NSString stringWithFormat:@"简介：%@",self.model.Description];
    //添加简介 label 的行间距
    CGFloat gap = 5.0;
    NSString *descriptStr = [NSString stringWithFormat:@"简介：%@",self.model.Description];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:descriptStr];
    UIFont *font = [UIFont systemFontOfSize:13.0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    if ([attributeString.string isMoreThanOneLineWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) font:font lineSpaceing:gap]) {
        style.lineSpacing = gap;
    }
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, descriptStr.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, descriptStr.length)];
    
    
    CGFloat boundingRectHeight = [attributeString.string boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) font:font lineSpacing:gap].height;
    NSLog(@"boundingRectHeight----%@",[NSString stringWithFormat:@"%f",boundingRectHeight]);
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.attributedText = attributeString;
    CGSize size = [label sizeThatFits:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX)];
    NSLog(@"通过label计算的文字高度%@",[NSString stringWithFormat:@"%f",size.height]);
    //设置总高度
    _descriptTotalHeight = size.height;
    NSString *modelStr = [self getDeviceName];
    if ([modelStr hasSuffix:@"iPhone X"] || [modelStr hasSuffix:@"Plus"]) {
        if (size.height > 56.666) { //超过3行
            [self addShowBtn];
        } else {
            [_videoInfoView addDescriptionView:(size.height + 22)];
            [_videoInfoView addHeadViewOriginalY:CGRectGetMaxY(_videoInfoView.view3.frame)];
            self.headerInfoHeight = _videoInfoView.totalHeight;
        }
    } else {
        if (size.height > 57) { //超过3行
            [self addShowBtn];
        } else {
            [_videoInfoView addDescriptionView:(size.height + 22)];
            [_videoInfoView addHeadViewOriginalY:CGRectGetMaxY(_videoInfoView.view3.frame)];
            self.headerInfoHeight = _videoInfoView.totalHeight;
        }
    }
    
    _videoInfoView.delegate = self;
//    self.headerInfoHeight = _videoInfoView.totalHeight;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PlayVCContentView class]]) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:_videoInfoView];
    
    //赋值
    NSString *tempStr = [self.model.eps integerValue] <= responseData.vimeo_responseDataArray.count ? @"共" : @"更新至";
    _videoInfoView.totalEpisodeLabel.text = [NSString stringWithFormat:@"%@%ld集",tempStr,responseData.vimeo_responseDataArray.count];
    _videoInfoView.directorLabel.text = [NSString stringWithFormat:@"导演：%@",self.model.director];
    if (self.model.cast4.length > 0) {
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@,%@,%@",self.model.cast1,self.model.cast2,self.model.cast3,self.model.cast4];
    } else if(self.model.cast3.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@,%@",self.model.cast1,self.model.cast2,self.model.cast3];
    } else if(self.model.cast2.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@",self.model.cast1,self.model.cast2];
    } else if(self.model.cast1.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@",self.model.cast1];
    } else {
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员："];
    }
    self.videoInfoView.descriptionLabel.attributedText = attributeString;
}

//添加展开的按钮
- (void) addShowBtn {
    [_videoInfoView addDescriptionView:78];
    _videoInfoView.showDescriptionBtn.frame = CGRectMake(0, 0, ScreenWidth, 20);
    [_videoInfoView addHeadViewOriginalY:CGRectGetMaxY(_videoInfoView.view4.frame)];
    self.headerInfoHeight = _videoInfoView.totalHeight + 20;
}

//点击展开或者收缩按钮的相应事件
- (void) showMoreDescript:(UIButton *)btn {
    _videoInfoView.showDescriptionBtn.selected = !_videoInfoView.showDescriptionBtn.selected;
    if (_videoInfoView.showDescriptionBtn.selected) { // 展开
        self.headerInfoHeight = _videoInfoView.totalHeight - 56.6 + _descriptTotalHeight;
        _videoInfoView.descriptionLabel.frame = CGRectMake(_videoInfoView.descriptionLabel.frame.origin.x, _videoInfoView.descriptionLabel.frame.origin.y, _videoInfoView.descriptionLabel.frame.size.width, _videoInfoView.descriptionLabel.frame.size.height - 56.6 + _descriptTotalHeight);
        _videoInfoView.view3.frame = CGRectMake(_videoInfoView.view3.frame.origin.x, _videoInfoView.view3.frame.origin.y, _videoInfoView.view3.frame.size.width, _videoInfoView.view3.frame.size.height - 56.6 + _descriptTotalHeight);
        _videoInfoView.view4.frame = CGRectMake(0, CGRectGetMaxY(_videoInfoView.view3.frame), ScreenWidth, 20);
        _videoInfoView.headView.frame = CGRectMake(_videoInfoView.headView.frame.origin.x, _videoInfoView.headView.frame.origin.y - 56.6 + _descriptTotalHeight, _videoInfoView.headView.frame.size.width, _videoInfoView.headView.frame.size.height);
        _videoInfoView.frame = CGRectMake(_videoInfoView.frame.origin.x, _videoInfoView.frame.origin.y, _videoInfoView.frame.size.width, _videoInfoView.frame.size.height - 56.6 + _descriptTotalHeight);
    } else { // 收起
        self.headerInfoHeight = _videoInfoView.totalHeight + 20;
        _videoInfoView.descriptionLabel.frame = CGRectMake(_videoInfoView.descriptionLabel.frame.origin.x, _videoInfoView.descriptionLabel.frame.origin.y, _videoInfoView.descriptionLabel.frame.size.width, _videoInfoView.descriptionLabel.frame.size.height + 56.6 - _descriptTotalHeight);
        _videoInfoView.view3.frame = CGRectMake(_videoInfoView.view3.frame.origin.x, _videoInfoView.view3.frame.origin.y, _videoInfoView.view3.frame.size.width, _videoInfoView.view3.frame.size.height + 56.6 - _descriptTotalHeight);
        _videoInfoView.view4.frame = CGRectMake(0, CGRectGetMaxY(_videoInfoView.view3.frame), ScreenWidth, 20);
        _videoInfoView.headView.frame = CGRectMake(_videoInfoView.headView.frame.origin.x, _videoInfoView.headView.frame.origin.y + 56.6 - _descriptTotalHeight, _videoInfoView.headView.frame.size.width, _videoInfoView.headView.frame.size.height);
        _videoInfoView.frame = CGRectMake(_videoInfoView.frame.origin.x, _videoInfoView.frame.origin.y, _videoInfoView.frame.size.width, _videoInfoView.frame.size.height + 56.6 - _descriptTotalHeight);
    }
}

- (void) selectedEpisode:(UIButton *)selectedBtn {
    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        for (UIView *subView in _videoInfoView.scrollView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                ((UIButton *)subView).selected = NO;
            }
        }
        [self.delegate selectedButton:selectedBtn];
    }
}

- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
#warning 题主呕心沥血总结！！最全面！亲测！全网独此一份！！
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


@end
