//
//  MySayVC.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "HomeModel.h"
@interface MySayVC : RootViewController
@property(nonatomic,strong)HomeModel * model;
@property(nonatomic,copy)NSString * urlStr;
@end
