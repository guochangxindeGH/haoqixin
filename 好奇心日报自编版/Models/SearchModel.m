//
//  SearchModel.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"author.id":@"avatarId",@"author.avatar":@"avatar",@"author.background_image":@"background_image",@"author.description":@"avatardescription",@"author.id":@"authorId",@"author.name":@"name",@"author.show":@"show",
                                                       @"post.appview":@"appview",
                                                       @"post.comment_count":@"comment_count",
                                                       @"post.description":@"description1",
                                                       @"post.genre":@"genre",
                                                       @"post.id":@"id1",
                                                       @"post.praise_count":@"praise_count",
                                                       @"post.publish_time":@"publish_time",
                                                       @"post.title":@"title",
                                                       @"post.category.id":@"id2",
                                                       @"post.category.image":@"image",
                                                       @"post.category.image_small":@"image_small",
                                                       @"post.category.title":@"title1"
                                                       ,
                                                       @"post.category.white_image":@"white_image"

                                                       }];
}
@end
