//
//  ListViewController.m
//  WYPoppverViewController
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ListViewController.h"
#import "Define.h"
#import "WHCustomStatusBar.h"
#import "SDImageCache.h"
#import "JLControl.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,WYPopoverControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    WHCustomStatusBar *_customStatus;
}
@end

@implementation ListViewController
- (WHCustomStatusBar *)customStatus
{
    if(_customStatus ==nil)
    {
        _customStatus = [[WHCustomStatusBar alloc] init];
    }
    return _customStatus;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray new];
    _dataArray=[NSMutableArray arrayWithObjects:@"清理缓存",@"打个赏？",@"关于我们", nil];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text=_dataArray[indexPath.row];
    cell.textLabel.textColor=kYELLOW;
    cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_dataArray[indexPath.row] isEqualToString:@"清理缓存"]) {
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.customStatus setBackgroundColor:[UIColor grayColor]];
                [self.customStatus setTextColor:[UIColor whiteColor]];
                [self.customStatus setTextAlignment:NSTextAlignmentCenter];
                [self.customStatus showStatusWithMessage:[NSString stringWithFormat:@"已成功清理%.2fM缓存",totalSize/1024.0/1024.0]];
            }];
        }];
    }else if([_dataArray[indexPath.row] isEqualToString:@"打个赏？"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/hao-qi-xin-ri-bao-ni-tou-tiao/id919052037?mt=8"]];
    }else if ([_dataArray[indexPath.row] isEqualToString:@"关于我们"]){
        [SVProgressHUD showInfoWithStatus:@"制作人邮箱：291976422@qq.com\n欢迎一起改进"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
