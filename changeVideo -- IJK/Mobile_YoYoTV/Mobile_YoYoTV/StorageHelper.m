//
//  StorageHelper.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "StorageHelper.h"

//1.声明一个静态的全局的单例对象指针，初始值为nil
static StorageHelper *single = nil;


@implementation StorageHelper

+ (id)sharedSingleClass{
    //2.调用GCD的once方法  //能够保证block中代码块在整个程序运行搓成中只会被执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//block代码段
        //3：实例化single对象指针
        single = [[StorageHelper alloc]init];
    });
    
//    NSLog(@"single = %p",single);
    
    return  single;//4:返回已经初始化的single指针
}

@end
