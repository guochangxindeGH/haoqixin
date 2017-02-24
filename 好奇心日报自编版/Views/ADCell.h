//
//  ADCell.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *bkView;

@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@end
