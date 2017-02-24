//
//  LeftCellModel.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface LeftCellModel : JSONModel
@property(nonatomic,copy)NSString<Optional> * id1;
@property(nonatomic,copy)NSString<Optional> * title;
@property(nonatomic,copy)NSString<Optional> * type;
@property(nonatomic,copy)NSString<Optional> * image_highlighted;
@property(nonatomic,copy)NSString<Optional> * image;
@end
