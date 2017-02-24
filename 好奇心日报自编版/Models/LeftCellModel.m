//
//  LeftCellModel.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LeftCellModel.h"

@implementation LeftCellModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"id1"}];
}
@end
