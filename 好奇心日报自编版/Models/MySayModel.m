//
//  MySayModel.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MySayModel.h"

@implementation MySayModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"id1",@"author.avatar":@"avatar",@"author.background_image":@"background_image",@"author.description":@"description1",@"author.id":@"authorId",@"author.name":@"name",@"author.show":@"show"}];
}

            
            @end
