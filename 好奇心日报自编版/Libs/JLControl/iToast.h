//
//  iToast.h
//  TakeAll
//
//  Created by 沈家林 on 15/9/29.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum
{
    kToastPositionTop,
    kToastPositionCenter,
    kToastPositionBottom,
} ToastPosition;

typedef enum
{
    kToastDurationShort = 3000,
    kToastDurationNormal= 5000,
    kToastDurationLong  =10000,
} ToastDuration;

@interface iToast : NSObject
{
    ToastPosition   toastPosition;
    ToastDuration   toastDuration;
    NSString        *toastText;
    UIView          *view;
}

@property (assign,nonatomic)    ToastPosition toastPosition;
@property (assign,nonatomic)    ToastDuration toastDuration;
@property (retain,nonatomic)    NSString      *toastText;


- (id)initWithText: (NSString *)text;
- (void)show;

+ (iToast *)makeToast: (NSString *)text;


- (void)hideToast: (id)sender;
- (void)onHideToast: (NSTimer *)timer;
- (void)onRemoveToast: (NSTimer *)timer;
- (void)doHideToast;

@end
