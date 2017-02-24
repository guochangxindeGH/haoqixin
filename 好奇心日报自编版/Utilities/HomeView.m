//
//  HomeView.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HomeView.h"
#import "Define.h"
#import "HttpManager.h"
#import "HomeCell2.h"
#import "HomeModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "VoteVC.h"
#import "HHRefreshHeader.h"
@implementation HomeView
{
     UITableView*_tableView;
        NSMutableArray *_dataArray;
    NSString *_page;
     NSInteger _haveMore;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _dataArray=[NSMutableArray new];
        _page=@"0";
        [self configUI];
        [self loadData];
    }
    return self;
}

-(void)configUI{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    HHRefreshHeader *hhHeader=[HHRefreshHeader new ];
    hhHeader=[HHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.header=hhHeader;
//    _tableView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.separatorColor=[UIColor clearColor];
    [self addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HomeCell2" bundle:nil] forCellReuseIdentifier:@"HomeCell2"];
}

-(void)refreshData{
    NSLog(@"开始下拉刷新数据");
    _page=@"0";
    [self loadData];
}

-(void)loadMoreData{
    if (_haveMore) {
        [self loadData];
    }else
        NSLog(@"没有更多");
}

-(void)loadData{
    [[HttpManager shareManager] requestWithUrl:[NSString stringWithFormat:@"http://app.qdaily.com/app/papers/index/%@.json",_page] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if ([_page isEqualToString:@"0"]) {
            [_dataArray removeAllObjects];
        }
        if((BOOL)(responseObject[@"response"][@"feeds"][@"has_more"])==YES){
            _haveMore=YES;
            _page=[NSString stringWithFormat:@"%@",responseObject[@"response"][@"feeds"][@"last_time"]];
            NSLog(@"%@",responseObject[@"response"][@"feeds"][@"last_time"]);
        }else{
            NSLog(@"没有更多");
        }
        NSArray *array= responseObject[@"response"][@"feeds"][@"list"];
        for (NSInteger i=0; i<array.count; i++) {
            HomeModel *model=[[HomeModel alloc] initWithDictionary:array[i] error:nil];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     HomeModel *model=_dataArray[indexPath.row];
    CGFloat height= [model.post.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size.height+[model.post.description1 boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+160;
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"HomeCell2";
    HomeCell2 *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    HomeModel *model=_dataArray[indexPath.row];
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.post.image]];
    cell.titleLabel.text=model.post.title;
    cell.descLabel.text=model.post.description1;
    [cell.typeView sd_setImageWithURL:[NSURL URLWithString:model.post.image_small]];
        cell.recordLabel.text=[NSString stringWithFormat:@"%@人", model.post.record_count];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model=_dataArray[indexPath.row];
    if ([model.post.title1 isEqualToString:@"投票"]) {
        NSLog(@"投票%@",model.post.id1);
        if (_delegate) {
            [[HttpManager shareManager]requestWithUrl:[NSString stringWithFormat:@"http://app.qdaily.com/app/papers/detail/%@.json?",model.post.id1] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                HomeModel *model1=[[HomeModel alloc] initWithDictionary:responseObject[@"response"] error:nil];
                [_delegate createVC:@"投票" model:model1 withUrlStr:nil];
            } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        }
    }else{
        NSLog(@"我说%@",model.post.id1);
        if (_delegate) {
            NSString *url=[[NSString stringWithFormat:@"http://app.qdaily.com/app/options/index/%@",model.post.id1] stringByAppendingString:@"/%@.json?"];
                [_delegate createVC:@"我说" model:model withUrlStr:url];
        }
    }
}

-(void)loadDetialModel:(HomeModel *)model{
   }

@end
