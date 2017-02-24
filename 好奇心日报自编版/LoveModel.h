//
//  LoveModel.h
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LoveModel : NSManagedObject

@property (nonatomic, retain) NSString * cate;
@property (nonatomic, retain) NSString * cateView;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * appView;
@property (nonatomic, retain) NSString * id1;

@end
