//
//  WHCustomStatusBar.m
//  StatusBarNotificationDemo
//
//  Created by 周少文 on 15/10/30.
//  Copyright © 2015年 ZheJiangWangHang. All rights reserved.
//

#import "WHCustomStatusBar.h"

@interface WHCustomStatusBar ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation WHCustomStatusBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        //UIWindow 有三个层级，分别是Normal ,StatusBar,Alert.输出他们三个层级的值，我们发现从左到右依次是0，1000，2000
        //设置window的显示层级高于UIWindowLevelStatusBar.
        self.windowLevel = UIWindowLevelStatusBar +1.0f;
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = NO;
        self.alpha = 0;
        [self createLabel];
        //makeKeyAndVisible不会使window的引用计数+1,所以在使用的时候一定要将window设置成全部变量,如果是个局部变量window在执行完makeKeyAndVisible方法之后会被释放,不会显示出来.
        [self makeKeyAndVisible];
    }
    return self;
}

- (void)createLabel
{
    _label = [[UILabel alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentRight;
    [self addSubview:_label];
}

- (void)showStatusWithMessage:(NSString *)text
{
    _label.text = text;
    if(self.alpha == 1)
    {
        //当WHCustomStatusBar已经显示出来了,再连续点击显示按钮,取消延时执行,不让window隐藏.
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWindow:) object:nil];
    }
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(hideWindow:) withObject:nil afterDelay:1.0f];
    }];
}

- (void)hideWindow:(id)object
{
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 0;
    }];
}

- (void)setStatusColor:(UIColor *)statusColor
{
    _statusColor  =statusColor;
    self.backgroundColor = statusColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    _label.textAlignment = textAlignment;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    _label.font = textFont;
}


@end
