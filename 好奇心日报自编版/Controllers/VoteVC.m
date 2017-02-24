//
//  VoteVC.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VoteVC.h"
#import "Masonry.h"
#import "VoteCell.h"
#import "HomeView.h"
#import "JLControl.h"
const CGFloat imageViewHeight = 200;
@interface VoteVC ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    UIScrollView *_scrollView;
    UIView *_contentV;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    NSMutableArray *_seletedArray;
}
@end

@implementation VoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray =[NSMutableArray new];
    _seletedArray =[NSMutableArray new];
    NSArray *array=[_model.questions firstObject][@"options"];
    for (NSInteger i=0; i<array.count; i++) {
        optionModel *model=[[optionModel alloc]initWithDictionary:array[i] error:nil ];
        [_dataArray addObject:model];
    }
    
    [self configUI];
}

-(void)configUI{
    [self addBarButtonItemWithTitle:@"LEFT" WithImageName:nil WithPosition:LEFT_BARITEM];
//    self.navigationController.toolbarHidden=NO;
    
    UIButton *shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,60,44)];
    [shareBtn setTitle:@"SHARE" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    
    KWS(ws);
    UIView *fatherView=[UIView new ];
    [self.view addSubview:fatherView];
    [fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.bottom.equalTo(ws.view).offset(0);
    }];
    
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fatherView).offset(0);
        make.left.equalTo(fatherView).offset(0);
        make.right.equalTo(fatherView).offset(0);
        make.bottom.equalTo(fatherView).offset(0);
    }];
    
    _contentV=[UIView new];
    [_scrollView addSubview:_contentV];
    [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(_scrollView);
        make.width.equalTo(fatherView);
    }];
    
    UIImageView *imageView=[UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.post.image]];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    imageView.backgroundColor=kYELLOW;
    [_contentV addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentV).offset(0);
        make.left.equalTo(_contentV).offset(0);
        make.right.equalTo(_contentV).offset(0);
        make.height.mas_equalTo(@200);
    }];
    
    UILabel *titleLabel=[UILabel new];
    titleLabel.text=_model.post.title;
    titleLabel.textColor=kYELLOW;
    titleLabel.font=[UIFont boldSystemFontOfSize:22];
    [_contentV addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.left.equalTo(_contentV).offset(20);
        make.right.equalTo(_contentV).offset(-20);
    }];
    
    UILabel *descLabel=[UILabel new];
    descLabel.text=_model.post.description1;
    descLabel.numberOfLines=0;
    descLabel.font=[UIFont systemFontOfSize:12];
    descLabel.textColor=[UIColor grayColor];
    [_contentV addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_contentV).offset(20);
        make.right.equalTo(_contentV).offset(-20);
    }];
    
    UIView *line=[UIView new];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.2;
    [_contentV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(10);
        make.left.equalTo(_contentV).offset(20);
        make.right.equalTo(_contentV).offset(-20);
        make.height.mas_equalTo(@1);
    }];
    
    
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerNib:[UINib nibWithNibName:@"VoteCell" bundle:nil] forCellReuseIdentifier:@"VoteCell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_contentV addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(_contentV).offset(20);
        make.right.equalTo(_contentV).offset(-20);
        make.height.mas_equalTo(@(_dataArray.count *80));
    }];


    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(60*RATE, SCREEN_HEIGHT-70, 60, 39)];
    [btn setImage:[UIImage imageNamed:@"lab_vote_button_normal"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(10);
        make.right.equalTo(_contentV).offset(-140);
        make.height.mas_equalTo(@53);
        make.width.mas_equalTo(@86);
    }];
    
    [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(20);
    }];
    
}

#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    optionModel *model=_dataArray[indexPath.row];
    VoteCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VoteCell" forIndexPath:indexPath];
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.contentLabel.text=model.content;
    cell.block=^(NSInteger isClick){
        if (isClick) {
            if (![_seletedArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
                 [_seletedArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
            }
        }else{
            if([_seletedArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]){
                [_seletedArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
            }
        }
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_seletedArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
}



-(void)addVoteItem:(NSString *)str{
    [_seletedArray addObject:str];
}

-(void)rightClick{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)btnClick:(UIButton *)btn{
    NSLog(@"投票");
    NSLog(@"%@",_seletedArray);
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"你选择的有%@",_seletedArray]];
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareClick{
    NSLog(@"分享按钮被点击");
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:@"分享" shareImage:nil shareToSnsNames:@[UMShareToDouban,UMShareToQQ,UMShareToSina] delegate:self];
}

#pragma mark -
#pragma mark UMSocialUIDelegate
//结束分享之后调用（回调）的方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
//    NSLog(@"%@",response);
}
//在分享之前调用的方法，socialData是我们分享的数据 platformName是分享的平台
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if ([platformName isEqualToString:UMShareToDouban]) {
        socialData.title=@"我的分享";
        socialData.shareText=@"test";
    }else if([platformName isEqualToString:UMShareToEmail]){
        socialData.shareText=@"我的分享";
//        socialData.title=@"123";
    }else if([platformName isEqualToString:UMShareToSina]){
        socialData.title=@"我的分享";
        socialData.shareText=_model.post.appview;
        socialData.shareImage=[UIImage imageNamed:@"AppIcon40x40@2x"];
    }else{}
//    NSLog(@"platform: %@ \n content :%@",platformName,socialData.shareText);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
