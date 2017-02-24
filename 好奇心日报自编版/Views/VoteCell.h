//
//  VoteCell.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^VoteCellBlock)(NSInteger isClick);
@interface VoteCell : UITableViewCell
@property (nonatomic,copy)VoteCellBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@end
