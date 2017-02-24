//
//  BlackCell.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollView.h"
@interface BlackCell : UICollectionViewCell
@property(nonatomic,strong)ScrollView * sv;
-(void)loadScrollPageViewWithArray:(NSArray *)array;
@end
