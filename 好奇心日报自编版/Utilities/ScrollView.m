//
//  ScrollView.m
//  仿网易
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ScrollView.h"
#import "UIImageView+WebCache.h"
#import "HomeModel.h"
#import "Define.h"
#import "RootViewController.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define TIMELENGTH 3
#import "LoveModel.h"
#import "MagicalRecord.h"

@implementation ScrollView
{
     NSArray *_array;//图片的名字数组
     UIScrollView *_scrollView;
     NSInteger _currentIndex;//记录当前页的，默认是0
     NSTimer *_timer;
    NSMutableArray *_imageViewArray;
    NSInteger _lastOffsetX;
    UIPageControl *_pc;
}

-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}
-(instancetype)initWithFrame:(CGRect)frame withImageNameArray:(NSArray *)array {
    if (self=[super initWithFrame:frame]) {
        _imageViewArray=[NSMutableArray new];
        _array=[NSArray arrayWithArray:array];
        [self configUI];
        [self addTimer];
    }
    return self;
}
-(void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:TIMELENGTH target:self selector:@selector(timeOn:) userInfo:nil repeats:YES];
}

-(void)timeOn:(NSTimer *)timer{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset=CGPointMake(_scrollView.contentOffset.x+SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_scrollView];
    }];
}

-(void)configUI{
    _scrollView=[[UIScrollView alloc]initWithFrame:self.frame];
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.bounces=NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    NSLog(@"传入的图片个数为%ld",_array.count);
//    NSLog(@"%@",_array);

    for (NSInteger i=0; i<_array.count; i++) {
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i+1), 0, SCREEN_WIDTH, 200)];
        [view sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[i] image]]];
        [_imageViewArray addObject:view];

    }
    //存第一张图
    UIImageView *view1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [view1 sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[4] image]]];
    [_imageViewArray insertObject:view1 atIndex:0];
    
    //存最后一张图
    UIImageView *view2=[[UIImageView alloc] initWithFrame:CGRectMake(6*SCREEN_WIDTH, 0, SCREEN_WIDTH, 200)];
    [view2 sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[0] image]]];
    [_imageViewArray addObject:view2];
    
    for (NSInteger i=0; i<_imageViewArray.count; i++) {
        UIImageView *imageView=_imageViewArray[i];
        imageView.userInteractionEnabled=YES;
        imageView.tag=500+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        HomeModel *model;
        if (i==0) {
            model=_array[_array.count-1];
        }else if(i==_imageViewArray.count-1){
            model=_array[0];
        }else{
            model=_array[i-1];
        }
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*RATE, 60, SCREEN_WIDTH-2*20*RATE, 100)];
        titleLabel.numberOfLines=3;
        titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont boldSystemFontOfSize:25];
        titleLabel.text=[[model post] title];
        [imageView addSubview:titleLabel];
        
        UILabel *cateLabel=[[UILabel alloc] initWithFrame:CGRectMake(50*RATE, 20, 100*RATE, 20)];
        cateLabel.text=[[model post] title1];
        cateLabel.textColor=kYELLOW;
        [imageView addSubview:cateLabel];
        
        UIImageView *cateView=[[UIImageView alloc] initWithFrame:CGRectMake(10*RATE, 10, 40, 40)];
        [cateView sd_setImageWithURL: [NSURL URLWithString: model.post.image_small]];
        [imageView addSubview:cateView];
        
        UIImageView *commentView=[[UIImageView alloc] initWithFrame:CGRectMake(20*RATE, 200-20, 15*RATE, 15)];
        commentView.image=[UIImage imageNamed:@"Comment_Normal_h.png"];
        commentView.contentMode=UIViewContentModeScaleAspectFill;
        [imageView addSubview:commentView];
        
        UILabel *commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(40*RATE, 200-20, 30*RATE, 20)];
        commentLabel.text=model.post.comment_count;
        commentLabel.textColor=[UIColor whiteColor];
        commentLabel.font=[UIFont systemFontOfSize:12];
        [imageView addSubview:commentLabel];
        
        UIImageView *loveView=[[UIImageView alloc] initWithFrame:CGRectMake(70*RATE, 200-20, 15*RATE, 15)];
//        loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal.png"];
        loveView.contentMode=2;
        [imageView addSubview:loveView];
        
        if ([LoveModel MR_findByAttribute:@"id1" withValue:model.post.id1].count>0) {
            loveView.image=[UIImage imageNamed:@"comment_toolbar_favor_highlighted"];
        }else{
            loveView.image=[UIImage imageNamed:@"articlefeed_cell_praise_normal"];
        }
        loveView.userInteractionEnabled=NO;

        
        UILabel *loveLabel=[[UILabel alloc] initWithFrame:CGRectMake(90*RATE, 200-20, 30*RATE, 20)];
        loveLabel.text=model.post.praise_count;
        loveLabel.textColor=[UIColor whiteColor];
        loveLabel.font=[UIFont systemFontOfSize:12];
        [imageView addSubview:loveLabel];
        
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*_imageViewArray.count, 0);
    _scrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
    
    _pc=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 200-25, SCREEN_WIDTH, 25)];
    _pc.numberOfPages=_array.count;
    _pc.currentPage=0;
    [self addSubview:_pc];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        NSInteger nowOffsetX=_scrollView.contentOffset.x;
        NSLog(@"%f",_scrollView.contentOffset.x/SCREEN_WIDTH);
        _pc.currentPage=_scrollView.contentOffset.x/SCREEN_WIDTH-1;
        
        if (nowOffsetX-_lastOffsetX>=0) {//右移
            NSLog(@"右移");
            if (_scrollView.contentOffset.x/SCREEN_WIDTH==5) {
                CGPoint point= CGPointMake(0, 0);
                _scrollView.contentOffset=point;
                _lastOffsetX=-1;
                return;
            }
        }
        else if(nowOffsetX-_lastOffsetX<=0 ){//左移
            NSLog(@"左移");
            if (_scrollView.contentOffset.x/SCREEN_WIDTH==0) {
                _pc.currentPage=4;
                CGPoint point= CGPointMake(SCREEN_WIDTH*5, 0);
                _scrollView.contentOffset=point;
            }
        }
        _lastOffsetX=nowOffsetX;
    }
}


-(void)tapClick:(UITapGestureRecognizer *)tap{
    HomeModel *model;
    if (tap.view.tag==500 || tap.view.tag==505) {//最后一张
        model=_array[_array.count-1];
    }else if(tap.view.tag==501 || tap.view.tag==506){//第一张
        model=_array[0];
    }else{//502~504
        model=_array[tap.view.tag-500-2];
    }
    if (_block) {
        _block(model);
    }
}
@end


//@implementation ScrollView
//{
//    NSArray *_array;//图片的名字数组
//    
//    UIImageView *_preImageView;//上一张图
//    UIImageView *_currentImageView;//当前的图
//    UIImageView *_nextImageView;//下一张图
//
//    UIScrollView *_scrollView;
//    
//    NSInteger _currentIndex;//记录当前页的，默认是0
//    NSTimer *_timer;
//    
//    UIPageControl *_pageControl;
//}
//
//-(instancetype)initWithFrame:(CGRect)frame withImageNameArray:(NSArray *)array{
//    self=[super initWithFrame:frame];
//    if (self) {
//        _array=[NSArray arrayWithArray:array];
//        [self configUI];
//        [self addTimer];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self prepareImage];
//        //copy 就是深拷贝一份imageArray 防止imageArray在外被干扰
//        //_array = [imageArray copy];
//        [self configUI];
//    }
//    return self;
//}
//
//-(void)dealloc{
//    if (_timer) {
//        [_timer invalidate];
//        _timer=nil;
//    }
//}
//
//-(void)addTimer{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:TIMELENGTH target:self selector:@selector(timeOn:) userInfo:nil repeats:YES];
//}
//
//-(void)timeOn:(NSTimer *)timer{
//    [UIView animateWithDuration:0.3 animations:^{
//        _scrollView.contentOffset=CGPointMake(_scrollView.contentOffset.x+WIDTH, 0);
//    } completion:^(BOOL finished) {
//        [self scrollViewDidEndDecelerating:_scrollView];
//    }];
//    
//}
//
//
//-(void)prepareImage{
////    _array=@[@"image0.png",@"image1.png",@"image2.png",@"image3.png"];
//}
//
//-(void)configUI{
//    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 200)];
//    _scrollView.pagingEnabled=YES;
//    _scrollView.showsHorizontalScrollIndicator=NO;
//    _scrollView.showsVerticalScrollIndicator=NO;
//    _scrollView.bounces=NO;
//    _scrollView.delegate = self;
//    [self addSubview:_scrollView];
//    
//    //有两张以上的图时
//    if (_array.count > 1) {
//        _currentIndex = 0;
//
//        _preImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        [_preImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)[_array lastObject] image]]];
//        [_scrollView addSubview:_preImageView];
//        
//        
//        _currentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
//         [_currentImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)[_array firstObject] image]]];
//        [_scrollView addSubview:_currentImageView];
//        
//        _nextImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*WIDTH, 0, WIDTH, HEIGHT)];
//         [_nextImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[(_currentIndex+1)%_array.count] image]]];
//        [_scrollView addSubview:_nextImageView];
//        
//        _scrollView.contentOffset=CGPointMake(WIDTH, 0);
//        _scrollView.contentSize=CGSizeMake(3*WIDTH, HEIGHT);
//        
//        [self addTimer];
//        
//        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT-30, WIDTH, 30)];
//        _pageControl.currentPage=_currentIndex;
//        _pageControl.numberOfPages = _array.count;
//        [self addSubview:_pageControl];
//    }
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView==_scrollView) {
////    [_timer invalidate];
////    _timer=[NSTimer scheduledTimerWithTimeInterval:TIMELENGTH target:self selector:@selector(timeOn:) userInfo:nil repeats:NO];
//    
//    if (scrollView.contentOffset.x == 2*WIDTH) {
//        scrollView.contentOffset = CGPointMake(WIDTH, 0);
//        
//        _currentIndex=(_currentIndex+1)%_array.count;
//          [_preImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[(_currentIndex-1+_array.count)%_array.count] image]]];
//        
//          [_currentImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[_currentIndex] image]]];
//        
//
//         [_nextImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[(_currentIndex+1)%_array.count] image]]];
//    }
//    else if (scrollView.contentOffset.x ==0) {
//        scrollView.contentOffset=CGPointMake(WIDTH, 0);
//        //0  1  2    _currentIndex=1
//        //3  0  1    _currentIndex=0
//        _currentIndex=(_currentIndex-1+_array.count)%_array.count;
//        
//
//        [_preImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[(_currentIndex-1+_array.count)%_array.count] image]]];
//        
//
//        [_currentImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[_currentIndex] image]]];
//
//
//         [_nextImageView sd_setImageWithURL:[NSURL URLWithString:[(HomeModel *)_array[(_currentIndex+1)%_array.count] image]]];
//    }
//    _pageControl.currentPage=_currentIndex;
//        
//    }
//}
//@end





