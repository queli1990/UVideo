//
//  HomeHorizontalCollectionViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/12/14.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeHorizontalCollectionViewCell.h"

@implementation HomeHorizontalCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.sumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-(6+20+2+17+12))];
        
        self.totalEpisodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _sumImageView.frame.size.height-17-1, _sumImageView.frame.size.width-10, 17)];
        _totalEpisodeLabel.textAlignment = NSTextAlignmentRight;
        _totalEpisodeLabel.font = [UIFont systemFontOfSize:12.0];
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, _sumImageView.frame.size.height-20, _sumImageView.frame.size.width, 20);
        //颜色分配:四个一组代表一种颜色(r,g,b,a)
        layer.colors = @[(__bridge id) [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0].CGColor,
                         (__bridge id) [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor];
        //起始点
        layer.startPoint = CGPointMake(0.5, 0.15);
        //结束点
        layer.endPoint = CGPointMake(0.5, 0.85);
        [_sumImageView.layer addSublayer:layer];
        
        
        self.attributeLabel = [[UILabel alloc] init];
        _attributeLabel.textColor = [UIColor whiteColor];
        _attributeLabel.font = [UIFont systemFontOfSize:11.0];
        _attributeLabel.textAlignment = NSTextAlignmentCenter;
//        _attributeLabel.layer.masksToBounds = YES;
//        _attributeLabel.layer.cornerRadius = 3.0;
        
        
        [_sumImageView addSubview:_totalEpisodeLabel];
        [_sumImageView addSubview:_attributeLabel];
        [self.contentView addSubview:_sumImageView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_sumImageView.frame)+6, frame.size.width-12*2, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x2F2D30, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+2, frame.size.width-12, 17)];
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textColor = UIColorFromRGB(0x808080, 1.0);
        _subLabel.textAlignment = NSTextAlignmentLeft;
        _subLabel.font = [UIFont systemFontOfSize:12.0];
        
        
        [self.contentView addSubview:_subLabel];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    _subLabel.text = model.subtitle.length ? model.subtitle: model.Description;
//    _subLabel.text = @"这是一个少年和他的小伙伴们的逆袭少时诵诗书所";
    
    
    if (model.genre_id.integerValue == 3) { //电影
        _totalEpisodeLabel.textColor = UIColorFromRGB(0xE83A00, 1.0);
        _totalEpisodeLabel.text = model.score;
//        _totalEpisodeLabel.text = @"9.0";
    } else if (model.genre_id.integerValue == 4) { //综艺
        _totalEpisodeLabel.textColor = UIColorFromRGB(0xFFFFFF, 1.0);
        _totalEpisodeLabel.text = model.update_progress;
//        _totalEpisodeLabel.text = @"20180809期";
    } else { // 电视剧
        _totalEpisodeLabel.textColor = UIColorFromRGB(0xFFFFFF, 1.0);
        _totalEpisodeLabel.text = model.update_progress;
//        _totalEpisodeLabel.text = @"更新至68集";
    }
    
    
//    if (model.attribute == nil) {
//        model.attribute = @"1080P";
//    }
    
    if (model.attributes.length <= 0) {
        _attributeLabel.hidden = YES;
    } else {
        _attributeLabel.hidden = NO;
    }
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0];
    CGSize labelSize = [model.attributes sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    _attributeLabel.frame = CGRectMake(_sumImageView.frame.size.width-labelSize.width-12-10, 0, labelSize.width+12, 16);
    if (model.pay) {
        _attributeLabel.backgroundColor = UIColorFromRGB(0xE83A00, 1.0);
        _attributeLabel.text = @"VIP";
    } else {
        _attributeLabel.backgroundColor = UIColorFromRGB(0xFF8000, 1.0);
        _attributeLabel.text = model.attributes;
    }

    NSString *urlString = [model.landscape_poster_s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [self.sumImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
    
    //设置_attributeLabel的底部圆角，不能再初始化的时候设置，因为初始化的时候并没有给出frame
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attributeLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)]; // UIRectCornerBottomRight通过这个设置
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _attributeLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _attributeLabel.layer.mask = maskLayer;

    //下面的 url 是 gif 图片格式
//    [self.sumImageView sd_setImageWithURL:[NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1979970-9d2b1cc945099612.gif?imageMogr2/auto-orient/strip"] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];

}








@end
