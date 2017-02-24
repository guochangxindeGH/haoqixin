//
//  SearchModel.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"
@interface SearchModel : JSONModel

@property(nonatomic,copy)NSString<Optional> * avatar;
@property(nonatomic,copy)NSString<Optional> * background_image;
@property(nonatomic,copy)NSString<Optional> * avatardescription;
@property(nonatomic,copy)NSString<Optional> * avatarId;
@property(nonatomic,copy)NSString<Optional> * name;
@property(nonatomic,copy)NSString<Optional> * show;

@property(nonatomic,copy)NSString<Optional>  * appview;//点进去的链接
@property(nonatomic,copy)NSString<Optional>  * id2;
@property(nonatomic,copy)NSString<Optional>  * image;
@property(nonatomic,copy)NSString<Optional>  * image2;
@property(nonatomic,copy)NSString<Optional>  * image_small;
@property(nonatomic,copy)NSString<Optional>  * title1;//智能
@property(nonatomic,copy)NSString<Optional>  * white_image;
@property(nonatomic,copy)NSString<Optional>  * comment_count;
@property(nonatomic,copy)NSString<Optional>  * description1;//除了泡吧以外，你还可以做点别的
@property(nonatomic,copy)NSString<Optional>  * genre;//类型
@property(nonatomic,copy)NSString<Optional>  * id1;//重要的识别标志
@property(nonatomic,copy)NSString<Optional>  * page_style;
@property(nonatomic,copy)NSString<Optional>  * praise_count;
@property(nonatomic,copy)NSString<Optional>  * publish_time;
@property(nonatomic,copy)NSString<Optional>  * super_tag;//长文章 
@property(nonatomic,copy)NSString<Optional>  * title;//万圣节没朋友指南，用这 21 个技巧让胆小鬼们颤抖吧 | Hack Your Life

@end
