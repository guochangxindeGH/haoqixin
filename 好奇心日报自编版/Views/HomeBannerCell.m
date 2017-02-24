//
//  HomeBannerCell.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HomeBannerCell.h"

@implementation HomeBannerCell

- (void)awakeFromNib {
    // Initialization code
    _loveView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_loveView addGestureRecognizer:tap];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    _isPress=!_isPress;
    if (_isPress==YES) {
        _loveView.image=[UIImage imageNamed:@"comment_toolbar_favor_highlighted"];
    }else{
        _loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal"];
    }
    if (_block) {
        _block(_isPress);
    }
}

@end
