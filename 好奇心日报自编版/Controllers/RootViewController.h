//
//  RootViewController.h
//  FavoriteLimit(老师版)
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Define.h"
#import "HttpManager.h"
#import "UIImageView+WebCache.h"
#import "IANshowLoading.h"
#import "UMSocial.h"
//#import "UMSocial.h"
@interface RootViewController : UIViewController<UIGestureRecognizerDelegate>//<UMSocialUIDelegate>
@property(nonatomic,assign)NSInteger isLoved;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
//添加titleView
-(void)addTitleView:(NSString *)title;
//设置导航栏左右按钮（只能是一个）
-(void)addBarButtonItemWithTitle:(NSString *)title WithImageName:(NSString *)imageName WithPosition:(NSInteger)position;
-(void)addNavLeftView:(NSString *)imageName;

-(void)leftClick;
-(void)rightClick;
@end
