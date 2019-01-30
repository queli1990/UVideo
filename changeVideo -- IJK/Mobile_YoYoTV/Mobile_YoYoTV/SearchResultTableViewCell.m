//
//  SearchResultTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2018/9/4.
//  Copyright © 2018年 li que. All rights reserved.
//

#import "SearchResultTableViewCell.h"

const CGFloat labelHeight = 18.0;
const CGFloat horGap = 16.0;//水平间隙
const CGFloat verGap = 6.0;//竖直间隙
const CGFloat leftGap = 15.0;//默认的最左端的间距
const CGFloat totalHeight = 90.0;//总高

@implementation SearchResultTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //height = 90
        self.sumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, (totalHeight-72)/2, 125, 72)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sumImageView.frame)+horGap, (totalHeight-18*2-verGap)/2, ScreenWidth-CGRectGetMaxX(_sumImageView.frame)-horGap-leftGap, 18)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+verGap, _titleLabel.frame.size.width, 18)];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _timeLabel.textColor = UIColorFromRGB(0x9B9B9B, 1.0);
        
        [self.contentView addSubview:_sumImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_timeLabel];
        
        // VIP、1080P等字段
        // 更新至多少集
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
    }
    return self;
}

- (void)setModel:(SearchResultModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    _timeLabel.text = model.subtitle.length > 0 ? model.subtitle : model.Description;
    
    NSString *urlString = [model.landscape_poster_s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [self.sumImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder_16_9"]];
    
    
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
    
    //设置_attributeLabel的底部圆角，不能再初始化的时候设置，因为初始化的时候并没有给出frame
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attributeLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)]; // UIRectCornerBottomRight通过这个设置
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _attributeLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _attributeLabel.layer.mask = maskLayer;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
