//
//  RootViewController.m
//  FavoriteLimit(老师版)
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "Define.h"



@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic[NAV_TITLE]) {
            self.navigationItem.title=dic[NAV_TITLE];}
        if (dic[TITLE]) {
             self.title=dic[TITLE];}
        if (dic[TAB_TITLE]) {
            self.tabBarItem.title=dic[TAB_TITLE];}
        self.tabBarItem.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:dic[TABAR_ITEM_IMAGE] ofType:@"png"]];
        NSString *str=[NSString stringWithFormat:@"%@_press",dic[TABAR_ITEM_IMAGE]];
        self.tabBarItem.selectedImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
    }
    return self;
}
    
//设置titleView
-(void)addTitleView:(NSString *)title{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    label.text=title;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=kYELLOW;
    label.font=[UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView=label;
}

-(void)addBarButtonItemWithTitle:(NSString *)title WithImageName:(NSString *)imageName WithPosition:(NSInteger)position{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    if (title.length>0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    if (imageName.length>0) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    if (position==LEFT_BARITEM) {
        self.navigationItem.leftBarButtonItem=barBtn;
        [btn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.navigationItem.rightBarButtonItem=barBtn;
        [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addNavLeftView:(NSString *)imageName{
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(0,0 , 75, 50)];
    view.image=[UIImage imageNamed:imageName];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:view];
}

-(void)leftClick{
    NSLog(@"子类需要重写leftClick");
}

-(void)rightClick{
    NSLog(@"子类需要重写rightClick");
}
    
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
