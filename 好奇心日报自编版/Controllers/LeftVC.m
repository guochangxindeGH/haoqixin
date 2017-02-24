//
//  LeftVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LeftVC.h"
#import "LeftCell.h"
#import "LeftCellModel.h"
#import "UIButton+WebCache.h"
const CGFloat BackGroupHeight = 200;
@interface LeftVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_imageArray;
    UIImageView *_imageBG;
}
@end

@implementation LeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _imageArray=[NSMutableArray new];
    _dataArray=[NSMutableArray new];
//    self.navigationController.hidesBarsOnSwipe=YES;
//    self.navigationController.hidesBarsOnTap=YES;
    [self configUI];
    [self loadData];
}

-(void)configUI{
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"new_features_1_960"]];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIImageView *searchView=[[UIImageView alloc] initWithFrame:CGRectMake(-20, 10, SCREEN_WIDTH-50*RATE, 30)];
    searchView.image=[UIImage imageNamed:@"SlderBar_SearchBar"];
    searchView.contentMode=1;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTap)];
    [searchView addGestureRecognizer:tap];
    searchView.userInteractionEnabled=YES;
    [footView addSubview:searchView];
    _tableView.tableFooterView=footView;
 
    _imageBG=[[UIImageView alloc]init];
    _imageBG.frame=CGRectMake(0, -BackGroupHeight, 280, BackGroupHeight);
    _imageBG.image=[UIImage imageNamed:@"rate_title_image_normal"];
    [_tableView addSubview:_imageBG];
     _imageBG.contentMode=UIViewContentModeScaleAspectFill;
    _imageBG.clipsToBounds=YES;
//    _tableView.tableHeaderView=imageView;
    _tableView.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    [_tableView addSubview:_imageBG];
    
    [self.view addSubview:_tableView];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"LeftCell" bundle:nil] forCellReuseIdentifier:@"LeftCell"];
}

-(void)loadData{

    [[HttpManager shareManager] requestWithUrl:@"http://app.qdaily.com/app/homes/left_sidebar.json?" withDictionary:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *array1=@[@"首页",@"奇奇研究所",@"收藏"];
        for (NSInteger i=0; i<3; i++) {
            LeftCellModel *model=[[LeftCellModel alloc] initWithDictionary:@{@"title":array1[i]} error:nil];
            [_dataArray addObject:model];
        }
        NSArray *array=responseObject[@"response"];
        for (NSInteger i=0; i<array.count; i++) {
            LeftCellModel *model=[[LeftCellModel alloc] initWithDictionary:array[i] error:nil];
            [_dataArray addObject:model];
//            NSLog(@"%@",model);
        }
        [_tableView reloadData];
    } withFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"LeftCell";
    LeftCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    LeftCellModel *model=_dataArray[indexPath.row];
    if (indexPath.row==0) {
        cell.headerView.image=[UIImage imageNamed:@"slidebar_cell_home_highlighted"];
    }else if(indexPath.row==1){
        cell.headerView.image=[UIImage imageNamed:@"slidebar_cell_lab_highlighted"];
    }else if(indexPath.row==2){
        cell.headerView.image=[UIImage imageNamed:@"slidebar_cell_fav_highlighted"];
    }else{
        [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.image_highlighted]];
    }
    cell.tag=100+indexPath.row;
    cell.titleLabel.text=model.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",[_dataArray[indexPath.row] title]);
    LeftCellModel *model= _dataArray[indexPath.row];

    if ([model.title isEqualToString:@"首页"]) {
        if (_delegate) {
            [_delegate sendUrlStr:KHOMEURL];
        }
    }
    if ([model.title isEqualToString:@"奇奇研究所"]) {
        if (_delegate) {
            [_delegate sendUrlStr:@"haoqixin"];
        }
    }
    if ([model.title isEqualToString:@"收藏"]) {
        if (_delegate) {
            [_delegate sendUrlStr:@"shouchang"];
        }
    }
    if ([model.title isEqualToString:@"长文章"]) {
        if (_delegate) {
            [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"Top 15"]) {
        if (_delegate) {
             [_delegate sendUrlStr:@"http://app.qdaily.com/app/categories/index/22/%@.json?"] ;
        }
    }
    if ([model.title isEqualToString:@"10 个图"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"商业"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"智能"]) {
        if (_delegate) {
            [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"设计"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"时尚"]) {
        if (_delegate) {
            [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"娱乐"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"城市"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"游戏"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    if ([model.title isEqualToString:@"好莱坞计划"]) {
        if (_delegate) {
             [_delegate sendUrlStr:[[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%@",model.id1]stringByAppendingString:@"/%@.json?"]] ;
        }
    }
    
    if (_block) {
        _block();
    }
    
}


-(void)searchViewTap{
    Class class=NSClassFromString(@"searchVC");
    RootViewController *vc=[class new];
    vc.title=@"奇奇更多";
    vc.modalTransitionStyle=1;
    [self presentViewController:vc animated:YES completion:^{
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    //下拉图片变大
    if (yOffset < -BackGroupHeight) {
        CGRect rect = _imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = 280 + fabs(xOffset)*2;
        _imageBG.frame = rect;
    }
    // 透明度
    CGFloat alpha = (yOffset+BackGroupHeight)/BackGroupHeight;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor colorWithRed:62/250.0 green:176/250.0 blue:193/250.0 alpha:0]colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
//    _titleLabel.alpha=alpha;
    alpha=fabs(alpha);
    alpha=fabs(1-alpha);
    alpha=alpha<0.2? 0:alpha-0.2;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
