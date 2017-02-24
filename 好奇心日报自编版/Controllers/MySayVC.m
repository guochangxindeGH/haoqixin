//
//  MySayVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MySayVC.h"
#import "MySayModel.h"
#import "MySayCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "JLControl.h"
#import "Masonry.h"

@interface MySayVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    NSMutableArray *_dataArray;
    NSString *_page;
    BOOL _hasMore;
    UIImageView *_imageView;
}
@end

@implementation MySayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _hasMore=NO;
    _page=@"0";
    _dataArray=[NSMutableArray new];
    [self configUI];
    [self loadData];
}

-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor grayColor];
//    self.navigationController.hidesBarsOnSwipe=YES;
//    self.navigationController.hidesBarsOnTap=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 140)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.post.image]];
    _imageView.contentMode=2;
    _imageView.clipsToBounds=YES;
    _collectionView.clipsToBounds=YES;
//    [self.view addSubview:_imageView];

    KWS(ws);
      UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*RATE, 64+10, SCREEN_WIDTH-2*20*RATE, 30)];
    titleLabel.text=_model.post.title;
    titleLabel.numberOfLines=2;
    titleLabel.font=[UIFont boldSystemFontOfSize:23];
    titleLabel.textColor=kYELLOW;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(40);
        make.left.equalTo(ws.view).offset(20);
        make.right.equalTo(ws.view).offset(-20);
    }];
    
    UILabel *descLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*RATE, 64+40, SCREEN_WIDTH-2*20*RATE, 30)];
    descLabel.font=[UIFont boldSystemFontOfSize:16];
    descLabel.textColor=[UIColor whiteColor];
    descLabel.text=_model.post.description1;
    descLabel.numberOfLines=0;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.left.equalTo(ws.view).offset(20);
        make.right.equalTo(ws.view).offset(-20);
    }];
    

        _flowLayout=[UICollectionViewFlowLayout new];
    _flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _flowLayout.minimumInteritemSpacing=0;
    _flowLayout.minimumLineSpacing=0;
//    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-480, SCREEN_WIDTH,500) collectionViewLayout:_flowLayout];
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-480, SCREEN_WIDTH,500) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor=[UIColor grayColor] ;
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.bounces=NO;
//    _collectionView.pagingEnabled=YES;
    _collectionView.footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_collectionView addSubview:_scrollView];
    [_collectionView registerNib:[UINib nibWithNibName:@"MySayCell" bundle:nil] forCellWithReuseIdentifier:@"MySayCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(20);
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.height.mas_equalTo(500);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20*RATE, SCREEN_HEIGHT-60*RATE, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"avatar_default_icon_opem"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"favorite_default_empty_night"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
}

-(void)refreshData{
    _page=@"0";
    [self loadData];
}

-(void)loadMoreData{
    if (_hasMore==YES && _page!=nil) {
        [self loadData];
    }else
    {
         [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        [_collectionView.footer endRefreshing];
    }
}

-(void)loadData{
        [[HttpManager shareManager] requestWithUrl:[NSString stringWithFormat:_urlStr,_page] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_collectionView.header endRefreshing];
            [_collectionView.footer endRefreshing];
            if ((BOOL)(responseObject[@"response"][@"options"][@"has_more"])==YES && responseObject[@"response"][@"options"][@"last_time"]!=nil) {
                _hasMore=YES;
                _page=(NSString *)(responseObject[@"response"][@"options"][@"last_time"]);
                if ([_page isEqual:[NSNull new]]) {
                    _hasMore=NO;
                }
                 NSLog(@"_page-------------------%@,%ld",(NSString *)_page,(long)_hasMore);
                NSArray *array= responseObject[@"response"][@"options"][@"list"];
                for (NSInteger i=0; i<array.count; i++) {
                    MySayModel *model=[[MySayModel alloc] initWithDictionary:array[i] error:nil];
                    [_dataArray addObject:model];
                }
            }else if((BOOL)(responseObject[@"response"][@"options"][@"has_more"])==NO) {
                NSLog(@"没有更多啦");
                _hasMore=NO;
                _page=@"0";
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            }
            [_collectionView reloadData];
        } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_collectionView.header endRefreshing];
            [_collectionView.footer endRefreshing];
        }];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2, 150);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"MySayCell";
    MySayCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    MySayModel *model=_dataArray[indexPath.row];
    [cell.bkView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    cell.nameLabel.text=model.name;
    cell.contentLabel.text=model.content;
    [cell.loveBtn setTitle:[NSString stringWithFormat:@"有%@支持",model.praise_count] forState:UIControlStateNormal];
    cell.backgroundColor=[UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:0.2];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView==_collectionView) {
//        NSLog(@"%f",_collectionView.contentOffset.y);
//        CGFloat offset=_collectionView.contentOffset.y/200;
//        CGRect frame= _imageView.frame;
//        if (offset<0) {
//            CGRect frame1= CGRectMake(frame.origin.x, 0, frame.size.width-offset, frame.size.height-offset);
//            _imageView.frame=frame1;
//        }else if(offset>=700){
//            _imageView.frame=frame;
//        }
//    }

}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.hidesBarsOnSwipe=NO;
    self.navigationController.hidesBarsOnTap=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
