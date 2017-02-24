//
//  MySayModel.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface MySayModel : JSONModel
@property(nonatomic,copy)NSString<Optional> * content;
@property(nonatomic,copy)NSString<Optional> * id1;
@property(nonatomic,copy)NSString<Optional> * image;
@property(nonatomic,copy)NSString<Optional> * perfect;
@property(nonatomic,copy)NSString<Optional> * praise_count;

@property(nonatomic,copy)NSString<Optional> * avatar;
@property(nonatomic,copy)NSString<Optional> * background_image;
@property(nonatomic,copy)NSString<Optional> * description1;
@property(nonatomic,copy)NSString<Optional> * avatarId;
@property(nonatomic,copy)NSString<Optional> * name;
@property(nonatomic,copy)NSString<Optional> * show;


@end
