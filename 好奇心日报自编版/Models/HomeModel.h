//
//  HomeModel.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol PostModel
@end
@protocol questionModel
@end
@protocol optionModel
@end

@interface optionModel : JSONModel
@property(nonatomic,copy)NSString<Optional>  *content;
@property(nonatomic,copy)NSString<Optional>  *id1;
@property(nonatomic,copy)NSString<Optional>  *image;
@end

@interface  questionModel:JSONModel
@property(nonatomic,copy)NSString<Optional>  * content;
@property(nonatomic,copy)NSString<Optional>  * genre;
@property(nonatomic,copy)NSString<Optional>  * id1;
@property(nonatomic,strong)NSArray<Optional,optionModel>  * options;

@end

@interface PostModel : JSONModel
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
@property(nonatomic,copy)NSString<Optional,questionModel>  * record_count;

@end


@interface HomeModel : JSONModel

@property(nonatomic,copy)NSString<Optional>  * image1;
@property(nonatomic,copy)NSString<Optional>  * title;
@property(nonatomic,copy)NSString<Optional>  * image;//显示的图片
@property(nonatomic,copy)NSString<Optional>  * type;//用来区分cell的类型
@property(nonatomic,strong)PostModel<Optional>  * post;
@property(nonatomic,strong)NSArray<Optional> * questions;
//@property(nonatomic,strong)* ;




@end
