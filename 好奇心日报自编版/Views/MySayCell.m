//
//  MySayCell.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MySayCell.h"
#import "Define.h"
@implementation MySayCell

- (void)awakeFromNib {
    _headerView.layer.cornerRadius=20;
    _headerView.clipsToBounds=YES;
    UIColor *color=kYELLOW;
    _loveBtn.layer.backgroundColor=color.CGColor;
    _bkView.clipsToBounds=YES;
    _bkView.contentMode=2;
}
- (IBAction)btnClick:(UIButton *)sender {
    NSLog(@"..");
}

@end
