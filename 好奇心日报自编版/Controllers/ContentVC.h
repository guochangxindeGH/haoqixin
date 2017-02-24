//
//  ContentVC.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "LeftVC.h"
#import "ScrollView.h"
typedef void(^ContentBlock)(void);

@interface ContentVC : RootViewController<LeftViewDelegate>

@property(nonatomic,strong)UIView * blackView;
@property(nonatomic,copy)NSString * urlStr;
@property(nonatomic,copy)ContentBlock block;
@property(nonatomic,strong)ScrollView * sv;
@end
