//
//  Define.h
//  FavoriteLimit
//
//  Created by 沈家林 on 15/9/21.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#ifndef FavoriteLimit_Define_h
#define FavoriteLimit_Define_h

//#define 

//颜色的宏定义
#define  kCOLOR(r,g,b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
//titleView的颜色
#define kTITVIEWCOLOR kCOLOR(40,149,224)

//颜色
#define kBLACK kCOLOR(42,42,42)
#define kYELLOW  kCOLOR(255,206,33)

//title的key
#define TITLE @"TITLE"
//navgationBar的title的key
#define NAV_TITLE @"NAV_TITLE"
//tabar的title的key
#define TAB_TITLE @"TAB_TITLE"
//tabarItem 图片
#define TABAR_ITEM_IMAGE @"TABAR_ITEM_IMAGE"
#define TABLEVIEW_COLOR [UIColor colorWithRed:30/255.0 green:160/255.0 blue:230/255.0 alpha:1]

//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//宽的比例
#define RATE SCREEN_WIDTH/320.0





//item的左边按钮
#define LEFT_BARITEM 1
//item的右边按钮
#define RIGHT_BARITEM 2

#define KWS(weakSelf) __weak __typeof(&*self) weakSelf=self

//字体大小
#define FONTMIDSIZE 14

//友盟的key
#define UMKEY @"56171e5867e58eed0a0003c9"

#pragma mark 请求的链接


#define KHOMEURL @"http://app.qdaily.com/app/homes/index/%@.json?"


#endif
