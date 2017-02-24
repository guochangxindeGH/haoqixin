//
//  LoveVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LoveVC.h"
#import "SearchCell.h"
#import "LoveModel.h"
#import "MagicalRecord.h"
@interface LoveVC ()

@end

@interface LoveVC ()<UITableViewDataSource,UITableViewDelegate>
{
//    UITableView *_tableView;
    NSMutableArray *_dataArray;

}
@end

@implementation LoveVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBarButtonItemWithTitle:@"EDIT" WithImageName:nil WithPosition:RIGHT_BARITEM];
    
    _dataArray =[NSMutableArray arrayWithArray: [LoveModel MR_findAll]];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    [self.view addSubview:_tableView];
    
    UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [leftBtn setTitle:@"LEFT" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"SearchCell";
    SearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    LoveModel *model=_dataArray[indexPath.row];
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.cateView]];
    cell.cateLabel.text=model.cate;
    cell.authorLabel.text=model.author;
    cell.dateLabel.text=model.time ;
    cell.titleLabel.text=model.title;
    cell.contentLabel.text=model.desc;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LoveModel *model=_dataArray[indexPath.row];
    return  [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size.height+[model.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-2*20*RATE, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSString *urlStr=[(LoveModel *)(_dataArray[indexPath.row]) appView];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [web loadRequest:request];
    RootViewController * vc=[[RootViewController alloc] init];
    [vc.view addSubview:web];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20*RATE, SCREEN_HEIGHT-60*RATE, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"avatar_default_icon_opem"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"favorite_default_empty_night"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:btn];
    vc.modalTransitionStyle=3;
    [self presentViewController:vc animated:YES completion:^{
    }];
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick{
    _tableView.editing=!_tableView.editing;
}

// 返回某一行，return YES允许被编辑, return NO 不能被编辑
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Are you sure?";
}
// 返回某一行，return YES允许被编辑, return NO 不能被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
         //删除行(先删除数据，在删除cell)
        LoveModel *model= _dataArray[indexPath.row];
        [model MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        [_dataArray removeObject:model];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
