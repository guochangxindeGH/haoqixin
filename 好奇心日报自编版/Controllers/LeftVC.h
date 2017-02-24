//
//  LeftVC.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"

@protocol LeftViewDelegate <NSObject>
-(void)sendUrlStr:(NSString *)urlStr;
@end
typedef void(^LeftViewBlock)(void);

@interface LeftVC : RootViewController
{
    UITableView *_tableView;
}
@property(nonatomic,weak)id<LeftViewDelegate> delegate;
@property(nonatomic,copy)LeftViewBlock block;


@end
