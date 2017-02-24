//
//  HomeView.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@protocol HomeViewDelegate <NSObject>
-(void)createVC:(NSString *)type model:(HomeModel *)model withUrlStr:(NSString *)url;
@end

@interface HomeView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)id<HomeViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;

@end
