//
//  VoteCell.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VoteCell.h"



@implementation VoteCell
{
    NSInteger _isClick;
}

- (void)awakeFromNib {
    
}

- (IBAction)BtnClick:(UIButton *)sender {
    _isClick=!_isClick;
    if (_isClick==YES) {
         [sender setImage:[UIImage imageNamed:@"lab_detail_vote_chosen"] forState:UIControlStateNormal];
    }else{
         [sender setImage:[UIImage imageNamed:@"lab_detail_vote_chose"] forState:UIControlStateNormal];
    }
    _block(_isClick);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
