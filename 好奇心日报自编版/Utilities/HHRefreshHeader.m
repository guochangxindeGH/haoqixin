//
//  HHRefreshHeader.m
//  MJRefresh
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HHRefreshHeader.h"

@implementation HHRefreshHeader

//重写prepare方法
-(void)prepare{
    //需要调用父类的prepare方法
    [super prepare];
    self.lastUpdatedTimeLabel.hidden=YES;
    self.stateLabel.hidden=YES;
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reveal_refresh_foreground"]];
    
    NSMutableArray *idImage=[NSMutableArray array];
    for (NSUInteger i=1; i < 5; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat: @"list_loading_00%ld",(unsigned long)i]];
        [idImage addObject:image];
    }
    //设置闲置状态的图片
    [self setImages:idImage forState:MJRefreshStateIdle];
  
    
    NSMutableArray *pullImage=[NSMutableArray new];
    for (NSInteger i=10; i<19; i++) {
        UIImage *image= [UIImage imageNamed:[NSString stringWithFormat:@"list_loading_0%ld",(long)i]];
        [pullImage addObject:image];
    }
    //松开即将刷新的时候的样式
    [self setImages:pullImage forState:MJRefreshStatePulling];
    
    
    
    NSMutableArray *refreshArray=[NSMutableArray new];
    for (NSInteger i=10; i<19; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"list_loading_0%ld",(long)i]];
        [refreshArray addObject:image];
    }
    //设置正在刷新时候的图片
    [self setImages:refreshArray forState:MJRefreshStateRefreshing];
}

@end
