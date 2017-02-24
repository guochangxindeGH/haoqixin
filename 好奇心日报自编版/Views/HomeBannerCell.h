//
//  HomeBannerCell.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeBannerCellBlock)(BOOL isPress);

@interface HomeBannerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bkView;
@property (weak, nonatomic) IBOutlet UIImageView *cateView;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loveView;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,copy)HomeBannerCellBlock block;
@property(nonatomic,assign)BOOL isPress;
@end
