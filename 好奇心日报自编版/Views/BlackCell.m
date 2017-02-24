//
//  BlackCell.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BlackCell.h"
#import "Define.h"
#import "HttpManager.h"
#import "HomeModel.h"
@implementation BlackCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self configUI];
    }
    return self;
}

//-(void)configUI{
//    [self loadScrollPageView];
//}

-(void)loadScrollPageViewWithArray:(NSArray *)array{
//    [[HttpManager shareManager] requestWithUrl:[NSString stringWithFormat:KHOMEURL,@"0"] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *array2=responseObject[@"response"][@"banners"][@"list"];
//        NSMutableArray *scrollPageArray=[NSMutableArray new];
//        for (NSInteger i=0; i<array2.count; i++) {
//            HomeModel *model=[[HomeModel alloc] initWithDictionary:array2[i] error:nil];
//            [scrollPageArray addObject:model];
//        }
//        _sv=[[ScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) withImageNameArray:[scrollPageArray copy]];
//        [self addSubview:_sv];
//    } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
    
    
    _sv=[[ScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) withImageNameArray:array];
    [self addSubview:_sv];
}

@end
