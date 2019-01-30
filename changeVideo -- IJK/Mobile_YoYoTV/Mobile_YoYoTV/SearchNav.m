//
//  SearchNav.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SearchNav.h"

@implementation SearchNav

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        CAGradientLayer *layer = [CAGradientLayer layer];
//        layer.frame = frame;
//        //颜色分配:四个一组代表一种颜色(r,g,b,a)
//        layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
//                         (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
//
//        //起始点
//        layer.startPoint = CGPointMake(0.15, 0.5);
//        //结束点
//        layer.endPoint = CGPointMake(0.85, 0.5);
//        [self.layer addSublayer:layer];
        
        self.backgroundColor = UIColorFromRGB(0x2F2D30, 1.0);
        self.searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20+(44-20)/2, 20, 20)];
        _searchImgView.image = [UIImage imageNamed:@"search"];
        [self addSubview:_searchImgView];
        
        
        self.cancelLabel = [[UILabel alloc] init];
        _cancelLabel.text = @"取消";
        UIFont *font = [UIFont fontWithName:@"Arial" size:16];
        _cancelLabel.font = font;
        CGSize size = [_cancelLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        _cancelLabel.frame = CGRectMake(ScreenWidth-15-size.width, 20+(44-20)/2, size.width, 20);
        _cancelLabel.textColor = [UIColor whiteColor];
        _cancelLabel.userInteractionEnabled = YES;
        [self addSubview:_cancelLabel];
        
        
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchImgView.frame)+10, 20+(44-20)/2, ScreenWidth-15-CGRectGetMaxX(_searchImgView.frame)-10-10-size.width, 20)];
        _inputTextField.placeholder = @"输入影片名";
        _inputTextField.backgroundColor = [UIColor clearColor];
        //设置placeholder的颜色
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_inputTextField.placeholder attributes:dict];
        [_inputTextField setAttributedPlaceholder:attribute];
        _inputTextField.textColor = [UIColor whiteColor];
        _inputTextField.font = [UIFont systemFontOfSize:16];
        _inputTextField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:_inputTextField];
        
    }
    return self;
}



@end
