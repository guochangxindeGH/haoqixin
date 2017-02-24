//
//  HomeModel.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HomeModel.h"

@implementation optionModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@""}];
}
@end


@implementation questionModel
@end



@implementation PostModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"cover.image":@"cover.title",@"category.id":@"id2",@"category.image":@"image2",@"category.image_small":@"image_small",@"category.title":@"title1",@"category.white_image":@"white_image",@"description":@"description1",
                                                       @"id":@"id1",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@""}];
}

@end

@implementation HomeModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"cover.image":@"image1",@"cover.title":@"title",@"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@"",
                                                       @"":@"",@"":@""}];
}
@end
