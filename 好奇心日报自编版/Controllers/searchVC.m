//
//  searchVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "searchVC.h"
#import "MJRefresh.h"
#import "JLControl.h"
#import "SearchModel.h"
#import "SearchCell.h"
@interface searchVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *_searchBtn;
    UITextField *_searchBar;
    NSString *_page;
    BOOL _hasMore;
    NSString *_total_number;
    RootViewController *_vc;
}
@end

@implementation searchVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray new];
    _page=@"0";
    _hasMore=NO;
    [self configUI];
}

-(void)configUI{
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    searchView.backgroundColor=kYELLOW;
    [self.view addSubview:searchView];
    
    _searchBar=[[UITextField alloc] initWithFrame:CGRectMake(10*RATE, 20, 250*RATE, 30)];
    _searchBar.layer.borderColor=[UIColor whiteColor].CGColor;
    _searchBar.layer.borderWidth=1;
    _searchBar.layer.cornerRadius=5;
      _searchBar.layer.masksToBounds=YES;
    _searchBar.backgroundColor=[UIColor whiteColor];
    UIImageView *leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    leftView.contentMode=1;
    leftView.clipsToBounds=YES;
    leftView.image=[UIImage imageNamed:@"UMS_find@2x"];
    _searchBar.leftView=leftView;
    _searchBar.leftViewMode=UITextFieldViewModeAlways;
    _searchBar.clearButtonMode=UITextFieldViewModeAlways;
    _searchBar.returnKeyType=UIReturnKeySearch;
    _searchBar.delegate=self;
    _searchBar.placeholder=@"请输入你的好奇心";
    [searchView addSubview:_searchBar];

    _searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(260*RATE, 25, 50*RATE, 20)];
    [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.backgroundColor=[UIColor clearColor];
    [searchView addSubview:_searchBtn];
    [_searchBar becomeFirstResponder];
    [self createTableView];
}

-(void)btnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else if ([btn.titleLabel.text isEqualToString:@"搜索"]){
        [self search];
    }
}

-(void)search{
    NSLog(@"search %@",_searchBar.text);
    [self reload];
}

-(void)createTableView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    _tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
}


-(void)loadData{
    if ([_searchBar.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"搜索不能为空"];
        return;
    }if (_page==nil) {
        _page=@"0";
        return;
    }
    NSString *urlStr=[NSString stringWithFormat:@"http://app.qdaily.com/app/searches/post_list?search=%@&last_time=%@",[_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_page ];
//    NSLog(@"%@",urlStr);窝
    [self.view endEditing:YES];
    [[HttpManager shareManager] requestWithUrl:urlStr withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if ([_page isEqualToString:@"0"]) {
            [_dataArray removeAllObjects];
        }
        if ((BOOL)responseObject[@"response"][@"searches"][@"has_more"]==YES) {
            _hasMore=YES;
            _page=[NSString stringWithFormat:@"%@", responseObject[@"response"][@"searches"][@"last_time"]];
//            NSLog(@"_page :%@ _hasMore:%ld ",_page,(NSInteger)_hasMore);
        }else{
            _hasMore=NO;
            _page=@"0";
        }
//        _total_number=responseObject[@"response"][@"searches"][@"total_number"];
//        if ([_page isEqualToString:@"0"]) {
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"共搜索到结果%@条",@"111"] ];
//        }
        NSArray *array= responseObject[@"response"][@"searches"][@"list"];
        for (NSInteger i=0; i<array.count; i++) {
            SearchModel *model=[[SearchModel alloc] initWithDictionary:array[i] error:nil];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

-(void)loadMore{
    if (_hasMore==YES) {
        if ([_page isEqualToString:@"0"]) {
             [SVProgressHUD showInfoWithStatus:@"没有更多"];
            [_tableView.footer endRefreshing];
        }else{
            [self loadData];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"没有更多"];
        [_tableView.footer endRefreshing];
    }

}

-(void)reload{
    _page=@"0";
    [self loadData];

}

#pragma mark-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"SearchCell";
    SearchCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    SearchModel *model=_dataArray[indexPath.row];
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.image_small]];
    cell.cateLabel.text=model.title1;
    cell.authorLabel.text=model.name;
    cell.dateLabel.text=model.publish_time ;
    cell.titleLabel.text=model.title;
    cell.contentLabel.text=model.description1;
    cell.titleLabel.preferredMaxLayoutWidth=SCREEN_WIDTH-2*20*RATE;
    cell.contentLabel.preferredMaxLayoutWidth=SCREEN_WIDTH-2*20*RATE;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SearchCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:self options:nil] firstObject];
//    cell.titleLabel.preferredMaxLayoutWidth=SCREEN_WIDTH-2*20*RATE;
//    cell.contentLabel.preferredMaxLayoutWidth=SCREEN_WIDTH-2*20*RATE;
//    CGFloat height1=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    SearchModel *model=_dataArray[indexPath.row];
    
    CGFloat height= [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size.height+[model.description1 boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+60;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSString *urlStr=[_dataArray[indexPath.row]  appview];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [web loadRequest:request];
    _vc=[[RootViewController alloc] init];
    [_vc.view addSubview:web];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20*RATE, SCREEN_HEIGHT-60*RATE, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"avatar_default_icon_opem"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"favorite_default_empty_night"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_vc.view addSubview:btn];
   
    _vc.modalTransitionStyle=3;
    [self presentViewController:_vc animated:YES completion:^{
    }];
}


#pragma mark-

//搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    [_searchBar endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(void)backClick{
    [_vc dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
