//
//  ScrollView.h
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

typedef void(^ScrollViewBlock)(HomeModel *model);

@interface ScrollView : UIView<UIScrollViewDelegate>
@property(nonatomic,copy)ScrollViewBlock  block;
- (instancetype)initWithFrame:(CGRect) frame withImageNameArray:(NSArray *)array ;

@end
