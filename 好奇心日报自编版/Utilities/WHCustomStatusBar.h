//
//  WHCustomStatusBar.h
//  StatusBarNotificationDemo
//
//  Created by 周少文 on 15/10/30.
//  Copyright © 2015年 ZheJiangWangHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCustomStatusBar : UIWindow

@property (nonatomic,strong) UIColor *statusColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign) NSTextAlignment textAlignment;
@property (nonatomic,strong) UIFont *textFont;


- (void)showStatusWithMessage:(NSString *)text;

@end
