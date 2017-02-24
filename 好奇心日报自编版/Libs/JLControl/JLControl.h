//
//  JLControl.h
//  BigPrivateSchool
//
//  Created by 沈家林 on 15/9/29.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
@interface JLControl : NSObject
+ (void)showMessage:(NSString *)msg Type:(NSInteger)type;     //消息提示 0系统样式 1自定义样式 2菊花样式
+ (void)cancelWebCache;                                 //清除UIWebView的缓存
+ (BOOL)checkPhoneNumber:(NSString *)str;               //验证手机号码是否合法
+ (void)saveLocalData:(id)obj forKey:(NSString *)key;   //保存数据到本地
+ (void)removeLocalData:(NSString *)key;                //移除本地数据
+ (id)getLocalData:(NSString *)key;                     //读取本地数据
+ (void)makeCall:(UIView *)view phoneNum:(NSString *)str;
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; //根据尺寸压缩图片

#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;

#pragma mark 对字符串的判断 对nil进行了处理
+ (BOOL)isNumber:(NSString*)string;
+ (BOOL)isNumberAndString:(NSString*)string;
+ (BOOL)isContainChinese:(NSString*)string;


#pragma mark 返回字体尺寸
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont *)font MaxSize:(CGSize)maxSize;

#pragma mark 搭建UI
//字体颜色是黑色，字体是默认字体，对齐方式是居中,不换行
-(UILabel *)addLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame;
//字体颜色是黑色，对齐方式是居中，不换行
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame;
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font isLineBreak:(BOOL)isLB frame:(CGRect)frame;
-(UILabel *)addLabelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font textAligment:(NSTextAlignment )textAligment isLineBreak:(BOOL)isLB frame:(CGRect)frame;


@end
