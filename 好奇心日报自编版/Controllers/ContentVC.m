//
//  ContentVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//可以射一个计数器如果type的个数为奇数，就删一个

#import "ContentVC.h"
#import "LeftVC.h"
#import "ContentVC.h"
#import "ScrollView.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "HomeBannerCell.h"
#import "ScrollView.h"
#import "BlackCell.h"
#import "HomeView.h"
#import "VoteVC.h"
#import "MySayVC.h"
#import "MJRefresh.h"
#import "HomeCell2.h"
#import "ListViewController.h"
#import "WYPopoverController.h"
#import "HHRefreshHeader.h"
#import "ADCell.h"
#import "LoveVC.h"
#import "MagicalRecord.h"
#import "LoveModel.h"
#import "DOFavoriteButton.h"
@interface ContentVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HomeViewDelegate,UIScrollViewDelegate,WYPopoverControllerDelegate>
{
    UIScrollView *_scrollView;
    UICollectionViewFlowLayout *_flowLayout;
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray1;
    NSInteger _haveMore;
    NSString *_page;
    NSMutableArray *_scrollPageArray;//轮播页数组
    
    HomeView *_homeView;//
    BOOL _loadScrollViewOK;
    UIImageView *_scrollLine;//navigationbar上的滑条
    BOOL _Index;
    WYPopoverController *_popover;//pop设置视图
    NSMutableArray *_loveArray;//用于存lovemodel的数组
    RootViewController *_vc;//用于homecell，homebannercell的详情页
    NSInteger _homeModelIndex;//为详情页 提供model的编号
}
@end

@implementation ContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=@"0";
    _dataArray1=[NSMutableArray new];
    _loveArray=[NSMutableArray new];
    _Index=NO;
    [self configUI];
    [self loadData];
}

-(void)configUI{
//    [IANshowLoading showLoadingForView:self.view];
    
    [self addBarButtonItemWithTitle:@"MENU" WithImageName:nil WithPosition:LEFT_BARITEM];
    [self addBarButtonItemWithTitle:@"SET" WithImageName:nil WithPosition:RIGHT_BARITEM];
    _scrollLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44-3, 100*RATE, 3)];
    _scrollLine.backgroundColor=kYELLOW;
    
    NSArray *array=@[@"slidebar_cell_home_highlighted",@"slidebar_cell_lab_normal"];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200*RATE, 44)];
    imageView.userInteractionEnabled=YES;
       for (NSInteger i=0; i<array.count; i++) {
           UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake((30+100*i)*RATE,5, 35*RATE, 35)];
           view.userInteractionEnabled=YES;
           view.contentMode=2;
           view.image=[UIImage imageNamed:array[i]];
           view.tag=1000+i;
           UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
           [view addGestureRecognizer:tap];
           [imageView addSubview:view];
       }
    [imageView addSubview:_scrollLine];
    self.navigationItem.titleView=imageView;
 
    self.automaticallyAdjustsScrollViewInsets=NO;
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64+200)];
    _scrollView.contentSize=CGSizeMake(2*SCREEN_WIDTH,SCREEN_HEIGHT-64 ) ;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.bounces=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.backgroundColor=[UIColor purpleColor];
//    _scrollView.scrollsToTop=YES;
    [self.view addSubview:_scrollView];
    
    _flowLayout=[[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumInteritemSpacing=0;
    _flowLayout.minimumLineSpacing=0;
//
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:_flowLayout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    
    
    HHRefreshHeader *hhHeader=[HHRefreshHeader new ];
    hhHeader=[HHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _collectionView.header=hhHeader;
    
//    _collectionView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _collectionView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
  
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeBannerCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBannerCell"];
    [_collectionView registerClass:[BlackCell class] forCellWithReuseIdentifier:@"BlackCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCell2" bundle:nil] forCellWithReuseIdentifier:@"HomeCell2"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ADCell" bundle:nil] forCellWithReuseIdentifier:@"ADCell"];
    
    _blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [_collectionView addSubview:_blackView];
    
    [_scrollView addSubview:_collectionView];

    _homeView=[[HomeView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _homeView.delegate=self;
    [_scrollView addSubview:_homeView];
    
    [self loadScrollPageView];
}

-(void)createVC:(NSString *)type model:(HomeModel *)model withUrlStr:(NSString *)url{
    if ([type isEqualToString:@"投票"]) {
        NSLog(@"创建投票视图");
        VoteVC *vc=[VoteVC new];
        vc.model=model;
        [vc addTitleView:@"投票"];
        [self.navigationController pushViewController:vc animated:YES];
//        [self presentViewController:vc animated:YES completion:nil];
    }else{
        NSLog(@"创建我说视图");
        MySayVC *vc=[MySayVC new];
        vc.urlStr=url;
        vc.model=model;
        [vc addTitleView:@"我说"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)refreshData{
    _page=@"0";
    [self loadData];
}

-(void)loadMoreData{
    if (_haveMore) {
         [self loadData];
    }else
        NSLog(@"没有更多");
}

-(void)loadScrollPageView{
       [[HttpManager shareManager] requestWithUrl:[NSString stringWithFormat:KHOMEURL,@"0"] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        NSArray *array2=responseObject[@"response"][@"banners"][@"list"];
        _scrollPageArray=[NSMutableArray new];
        for (NSInteger i=0; i<array2.count; i++) {
            HomeModel *model=[[HomeModel alloc] initWithDictionary:array2[i] error:nil];
            [_scrollPageArray addObject:model];
        }
           KWS(ws);
           _sv=[[ScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) withImageNameArray:[_scrollPageArray copy]];
           _sv.block=^(HomeModel *model){
              
               UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
               NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:model.post.appview]];
               [web loadRequest:request];
               RootViewController *vc=[[RootViewController alloc] init];
               [vc.view addSubview:web];
               vc.modalTransitionStyle=2;
                [vc addTitleView:@"发现好奇心"];
              
               DOFavoriteButton *heartButton = [[DOFavoriteButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44) image: [UIImage imageNamed:@"heart"]];
               heartButton.imageColorOn = [UIColor colorWithRed:254/255.0f green:110/255.0f blue:111/255.0f alpha:1.0];
               heartButton.circleColor = [UIColor colorWithRed:254/255.0f green:110/255.0f blue:111/255.0f alpha:1.0];
               heartButton.lineColor = [UIColor colorWithRed:226/255.0f green:96/255.0f blue:96/255.0f alpha:1.0];
               [heartButton addTarget:ws action:@selector(tappedButton2:) forControlEvents:UIControlEventTouchUpInside];
               vc.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:heartButton];
               
//               NSLog(@"%@",model);
               if ([LoveModel MR_findByAttribute:@"id1" withValue:model.post.id1].count>0) {
                   [heartButton select];
               }else{
                   [heartButton deselect];
               }
               [ws.navigationController pushViewController:vc animated:YES];
           };
           [_blackView addSubview:_sv];
    } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
    }];
}

-(void)loadData{
    if (_urlStr==nil ||_page==nil ) {
        _urlStr=KHOMEURL;
        _page=@"0";
    }
        [[HttpManager shareManager] requestWithUrl:[NSString stringWithFormat:_urlStr,_page] withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_collectionView.header endRefreshing];
            [_collectionView.footer endRefreshing];
            if ([_page isEqual:@"0"]) {
                [_dataArray1 removeAllObjects];
                HomeModel *model=[[HomeModel alloc]initWithDictionary:@{@"title":@"空",@"type":@"2"} error:nil];
                [_dataArray1 addObject:model];
            }
            if((BOOL)(responseObject[@"response"][@"feeds"][@"has_more"])==YES){
                _haveMore=YES;
                _page=[NSString stringWithFormat:@"%@",responseObject[@"response"][@"feeds"][@"last_time"]];
                NSLog(@"%@",responseObject[@"response"][@"feeds"][@"last_time"]);
            }
            NSArray *array1= responseObject[@"response"][@"feeds"][@"list"];
            for (NSInteger i=0; i<array1.count; i++) {
                HomeModel *model=[[HomeModel alloc] initWithDictionary:array1[i] error:nil];
                [_dataArray1 addObject:model];
            }
            NSArray *array2=responseObject[@"response"][@"ad_feeds"][@"list"];
            if (array2.count>0) {
                for (NSInteger i=0;i<array2.count ; i++) {
                     HomeModel *model=[[HomeModel alloc] initWithDictionary:array2[i] error:nil];
                    [_dataArray1 addObject:model];
                    NSLog(@"%@",model);
                }
            }
            [_collectionView reloadData];
        } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_collectionView.header endRefreshing];
            [_collectionView.footer endRefreshing];
        }];
}

#pragma mark -
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model=_dataArray1[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        return CGSizeMake(SCREEN_WIDTH/2, 200);
    }
    else if([model.type isEqualToString:@"2"]){
        if ([model.post.title1 isEqualToString:@"这个设计了不起"]) {
         return CGSizeMake(0, 0);
        }else{
         return CGSizeMake(SCREEN_WIDTH, 200);
        }
    }else {//投票或者我说类型
        return CGSizeMake(0, 0);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model=_dataArray1[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        if ([model.post.title1 isEqualToString:@"广告"]) {
            ADCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"ADCell" forIndexPath:indexPath];
            [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.post.image_small]];
            [cell.bkView sd_setImageWithURL:[NSURL URLWithString:model.image]];
              cell.cateLabel.text=model.post.title1;
            return cell;
        }else {
            HomeCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
             cell.loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal.png"];
            [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:model.image]];
            cell.label1.text=model.post.description1;
            [cell.cateView sd_setImageWithURL:[NSURL URLWithString: model.post.image_small]];
            cell.commentLabel.text=model.post.comment_count;
            cell.loveLabel.text=model.post.praise_count;
            cell.cateLabel.text=model.post.title1;
            cell.block=^(BOOL isPress ){
               [self love:isPress homeModel:model];
            };
            if ([LoveModel MR_findByAttribute:@"id1" withValue:model.post.id1].count>0) {
                cell.loveView.image=[UIImage imageNamed:@"comment_toolbar_favor_highlighted"];
            }else{
                cell.loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal.png"];
            }
            return cell;
        }
    }
    else if([model.type isEqualToString:@"2"]){
        if ([model.post.title1 isEqualToString:@"这个设计了不起"]) {
            HomeBannerCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
            cell.backgroundColor=[UIColor redColor];
            return cell;
        }else{
            HomeBannerCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
            cell.loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal"];
            [cell.bkView sd_setImageWithURL:[NSURL URLWithString:model.image]];
            [cell.cateView sd_setImageWithURL:[NSURL URLWithString:model.post.image_small]];
            cell.cateLabel.text=model.post.title1;
            cell.titleLabel.text=model.post.title;
            cell.commentLabel.text=model.post.comment_count;
            cell.loveLabel.text=model.post.praise_count;
            cell.block=^(BOOL isPress ){
                [self love:isPress homeModel:model];
            };
            if ([LoveModel MR_findByAttribute:@"id1" withValue:model.post.id1].count>0) {
                cell.loveView.image=[UIImage imageNamed:@"comment_toolbar_favor_highlighted"];
            }else{
                cell.loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal.png"];
            }
            return cell;
        }
    }else //if(model.type ==nil){//投票或者我说类型
    { HomeBannerCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor redColor];
        return cell;
    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray1.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    _homeModelIndex=indexPath.row;
    
    UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    NSString *urlStr=[[_dataArray1[indexPath.row] post] appview];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [web loadRequest:request];
    _vc=[[RootViewController alloc] init];
    _vc.automaticallyAdjustsScrollViewInsets=NO;
    [_vc.view addSubview:web];
    [_vc addTitleView:@"发现好奇心"];
    UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [leftBtn setTitle:@"LEFT" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _vc.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    DOFavoriteButton *heartButton = [[DOFavoriteButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44) image: [UIImage imageNamed:@"heart"]];
    heartButton.imageColorOn = [UIColor colorWithRed:254/255.0f green:110/255.0f blue:111/255.0f alpha:1.0];
    heartButton.circleColor = [UIColor colorWithRed:254/255.0f green:110/255.0f blue:111/255.0f alpha:1.0];
    heartButton.lineColor = [UIColor colorWithRed:226/255.0f green:96/255.0f blue:96/255.0f alpha:1.0];
    [heartButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    _vc.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:heartButton];
  
    if ([LoveModel MR_findByAttribute:@"id1" withValue:[[_dataArray1[indexPath.row] post] id1]].count>0) {
        [heartButton select];
    }else{
        [heartButton deselect];
    }

    [self.navigationController pushViewController:_vc animated:YES];
}
-(void)tappedButton:(id)sender {
    DOFavoriteButton *button = (DOFavoriteButton *)sender;
    if (button.selected) {
        [button deselect];
        [self love:NO homeModel:_dataArray1[_homeModelIndex]];
    } else {
        [button select];
        [self love:YES homeModel:nil];
    }
    _homeModelIndex=0;
    [_collectionView reloadData];
}
-(void)tappedButton2:(id)sender {
    DOFavoriteButton *button = (DOFavoriteButton *)sender;
    if (button.selected) {
        [button deselect];
        [self love:NO homeModel:nil];
    } else {
        [button select];
        [self love:YES homeModel:_scrollPageArray[_homeModelIndex]];
    }
    _homeModelIndex=0;
    [_collectionView reloadData];
}

-(void)love:(BOOL)isPress homeModel:(HomeModel *) model{
    if (isPress ==YES) {
         LoveModel *myModel=[LoveModel MR_createEntity];
        myModel.cate=model.post.title1;
        myModel.cateView=model.post.image_small;
        myModel.author=@"";
        myModel.time=@"";
        myModel.title=model.post.title;
        myModel.desc=model.post.description1;
        myModel.appView=model.post.appview;
        myModel.id1=model.post.id1;
        [_loveArray addObject:myModel];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        NSLog(@"已经成功添加一个收藏");
    }else if (isPress==NO){
        NSArray *array=[LoveModel MR_findByAttribute:@"id1" withValue:model.post.id1];
        if (array.count>0) {
            for (NSInteger i=0; i<array.count; i++) {
                [array[i] MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            }
        }
    }
}

#pragma mark -
#pragma mark leftViewDelegate
-(void)sendUrlStr:(NSString *)urlStr{
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([urlStr isEqualToString:@"haoqixin"]) {
        ((UIImageView *)([self.navigationItem.titleView viewWithTag:1000])).image=[UIImage imageNamed:@"slidebar_cell_home_normal"];
        ((UIImageView *)([self.navigationItem.titleView viewWithTag:1001])).image=[UIImage imageNamed:@"slidebar_cell_lab_highlighted"];
        _urlStr=KHOMEURL;
        _page=@"0";
        _Index=YES;
        [self tapClick:nil];
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
        }];
        
    }else if([urlStr isEqualToString:@"shouchang"] ){
        LoveVC *vc=[LoveVC new];
        [vc addTitleView:@"收藏"];
        [vc.tableView reloadData];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ((UIImageView *)([self.navigationItem.titleView viewWithTag:1000])).image=[UIImage imageNamed:@"slidebar_cell_home_highlighted"];
         ((UIImageView *)([self.navigationItem.titleView viewWithTag:1001])).image=[UIImage imageNamed:@"slidebar_cell_lab_normal"];
        _urlStr=urlStr;
        _page=@"0";
        [self loadData];
        _Index=NO;
        [self tapClick:nil];
        [UIView animateWithDuration:0.5 animations:^{
            _collectionView.contentOffset=CGPointMake(0, 0);
        }];
    }
}

#pragma mark-
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftClick{
    NSLog(@"left");
    _block();
}

-(void)rightClick{
    NSLog(@"right");
    ListViewController *vc=[ListViewController new];
    //poppver用VC的preferredContextSize来约束自己的大小
    vc.preferredContentSize=CGSizeMake(100*RATE, 132);
    vc.view.backgroundColor=[UIColor yellowColor];
    //创建popover
    _popover=[[WYPopoverController alloc] initWithContentViewController:vc];
    //设置代理
    _popover.delegate=self;
    [_popover presentPopoverFromRect:CGRectMake(SCREEN_WIDTH-30*RATE, 30, 0, 0) inView:self.navigationController.navigationBar permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",(long)tap.view.tag);
    if (tap.view.tag==1001 ||_Index==YES)
    {
        NSLog(@"滑到 好奇心研究所界面");
        UIImageView *view1=(UIImageView *)(UIImageView *)[self.navigationController.navigationBar viewWithTag:1001];
        view1.image=[UIImage imageNamed:@"slidebar_cell_lab_highlighted"];
        UIImageView *view2=(UIImageView *)[self.navigationController.navigationBar viewWithTag:1000];
        view2.image=[UIImage imageNamed:@"slidebar_cell_home_normal"];
       
        [UIView animateWithDuration:0.5 animations:^{
            _scrollLine.frame=CGRectMake(100*RATE, 44-3, 100*RATE, 3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _scrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
    else if(tap.view.tag==1000 ||_Index==NO)
    {
        NSLog(@"滑到 首页界面");
        UIImageView *view1=(UIImageView *)(UIImageView *)[self.navigationController.navigationBar viewWithTag:1000];
        view1.image=[UIImage imageNamed:@"slidebar_cell_home_highlighted"];
        UIImageView *view2=(UIImageView *)[self.navigationController.navigationBar viewWithTag:1001];
        view2.image=[UIImage imageNamed:@"slidebar_cell_lab_normal"];
        [UIView animateWithDuration:0.5 animations:^{
            _scrollLine.frame=CGRectMake(0, 44-3, 100*RATE, 3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                 _scrollView.contentOffset=CGPointMake(0, 0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

#pragma mark -
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
//        NSLog(@"%f",_scrollView.contentOffset.x);
        if (_scrollView.contentOffset.x==0) {
            _Index=NO;
            [self tapClick:nil];
            [UIView animateWithDuration:0.5 animations:^{
                 _scrollLine.frame=CGRectMake(0, 44-3, 100*RATE, 3);
            } completion:^(BOOL finished) {
            }];
        }else if(_scrollView.contentOffset.x==SCREEN_WIDTH){
            _Index=YES;
            [self tapClick:nil];
            _Index=NO;
            [UIView animateWithDuration:0.5 animations:^{
                _scrollLine.frame=CGRectMake(100*RATE, 44-3, 100*RATE, 3);
            } completion:^(BOOL finished) {
            }];
        }
    }
}


#pragma mark poppverDelegate
//当点击蒙层的时候会调用这个方法，返回Yes代表可以隐藏popover
-(BOOL)popoverControllerShouldDismiss:(WYPopoverController *)popoverController{
    return YES;
}

//当popover消失的时候调用的方法
-(void)popoverControllerDidDismiss:(WYPopoverController *)popoverController{
    NSLog(@"我已经消失了");
    _popover.delegate=nil;
    _popover=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
