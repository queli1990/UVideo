//
//  BHInfiniteScrollViewCell.m
//  BHInfiniteScrollView
//
//  Created by libohao on 16/3/6.
//  Copyright © 2016年 libohao. All rights reserved.
//
/*
 *********************************************************************************
 *
 * 如果您使用轮播图库的过程中遇到Bug,请联系我,我将会及时修复Bug，为你解答问题。
 * QQ讨论群 :  206177395 (BHInfiniteScrollView讨论群)
 * Email:  375795423@qq.com
 * GitHub: https://github.com/qylibohao
 *
 *
 *********************************************************************************
 */

#import "BHInfiniteScrollViewCell.h"

#if __has_include(<UIImageView+WebCache.h>)
#import <UIImageView+WebCache.h>
#else 
#import "UIImageView+WebCache.h"
#endif

@interface BHInfiniteScrollViewCell()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel *attributeLabel;

@end

@implementation BHInfiniteScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        
        //添加黑色的遮罩层
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 30, [UIScreen mainScreen].bounds.size.width, 30)];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
        //颜色分配:四个一组代表一种颜色(r,g,b,a)
        layer.colors = @[(__bridge id) [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0].CGColor,
                         (__bridge id) [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor];
        //起始点
        layer.startPoint = CGPointMake(1, 0.1);
        //结束点
        layer.endPoint = CGPointMake(1, 0.9);
        [bgView.layer addSublayer:layer];
        
        [self addSubview:bgView];
        
        [self addSubview:self.titleView];
    }
    return self;
}


- (void)setupWithUrlString:(NSString*)url placeholderImage:(UIImage*)placeholderImage {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0];
    CGSize labelSize = [self.attributes sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    self.attributeLabel.frame = CGRectMake(self.imageView.frame.size.width-12-10-labelSize.width, 0, labelSize.width+12, 16);
    _attributeLabel.text = self.attributes;
    // 给imageview添加右上角的标识
    if (self.attributes.length > 0) {
        [self.imageView addSubview:_attributeLabel];
        _attributeLabel.hidden = NO;
    } else {
        _attributeLabel.hidden = YES;
    }
    // 判断给出标识的背景颜色
    if ([self.attributes isEqualToString:@"VIP"]) {
        _attributeLabel.backgroundColor = [UIColor colorWithRed:((float)((0xE83A00 & 0xFF0000) >> 16))/255.0 green:((float)((0xE83A00 & 0xFF00) >> 8))/255.0 blue:((float)(0xE83A00 & 0xFF))/255.0 alpha:1.0];
        
    } else {
        _attributeLabel.backgroundColor = [UIColor colorWithRed:((float)((0xFF8000 & 0xFF0000) >> 16))/255.0 green:((float)((0xFF8000 & 0xFF00) >> 8))/255.0 blue:((float)(0xFF8000 & 0xFF))/255.0 alpha:1.0];
    }
    //设置_attributeLabel的底部圆角，不能再初始化的时候设置，因为初始化的时候并没有给出frame
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attributeLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)]; // UIRectCornerBottomRight通过这个设置
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _attributeLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _attributeLabel.layer.mask = maskLayer;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
    
}

- (void)setupWithImageName:(NSString*)imgName placeholderImage:(UIImage*)placeholderImage {
    if ([self.attributes isEqualToString:@"VIP"]) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0];
        CGSize labelSize = [self.attributes sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width-12-10, 0, labelSize.width+12, 16)];
        attributeLabel.textColor = [UIColor colorWithRed:((float)((0xE83A00 & 0xFF0000) >> 16))/255.0 green:((float)((0xE83A00 & 0xFF00) >> 8))/255.0 blue:((float)(0xE83A00 & 0xFF))/255.0 alpha:1.0];
        attributeLabel.font = [UIFont systemFontOfSize:11.0];
        attributeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.imageView addSubview:attributeLabel];
    }
    UIImage* image = [UIImage imageNamed:imgName];
    if (!image) {
        image  = placeholderImage;
    }
    self.imageView.image = image;
}

- (void)setupWithImage:(UIImage*)img placeholderImage:(UIImage*)placeholderImage {
    if (img) {
        self.imageView.image = img;
    }else {
        self.imageView.image = placeholderImage;
    }
    
}

- (void)setupImageView {
    [self.contentView addSubview:self.imageView];
}

// 将titleView添加在cell上
- (BHInfiniteScrollViewTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[BHInfiniteScrollViewTitleView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.frame) - 25, CGRectGetWidth(self.frame), 20)];
        _titleView.textColor = [UIColor whiteColor];
    }
    return _titleView;
}

/*右上角的小logo，VIP,1080P,720P等等*/
- (UILabel *)attributeLabel{
    if (!_attributeLabel) {
        _attributeLabel = [[UILabel alloc] init];
        _attributeLabel.font = [UIFont systemFontOfSize:11.0];
        _attributeLabel.textAlignment = NSTextAlignmentCenter;
        _attributeLabel.textColor = [UIColor whiteColor];
        _attributeLabel.layer.masksToBounds = YES;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attributeLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)]; // UIRectCornerBottomRight通过这个设置
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _attributeLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _attributeLabel.layer.mask = maskLayer;
        
    }
    return _attributeLabel;
}

- (UIImageView* )imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (void)setContentMode:(UIViewContentMode)pageViewContentMode {
    _contentMode = pageViewContentMode;
    self.imageView.contentMode = pageViewContentMode;
}

@end
