//
//  MatchPrizeDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchPrizeDetailViewController.h"

@interface MatchPrizeDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView  * _mainScrollView;
    UIPageControl * _pageControl;
}
@end

@implementation MatchPrizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比赛奖品详细";
    
    [self initVar];
    
    [self createView];
    
    NSLog(@"%@",self.prizeArr);
    NSLog(@"%ld",(long)self.nowIdx);
}

-(void)initVar {
    
}

-(void)createView {
    
    _mainScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_pagingEnabled(YES)
        .L_contentSize(CGSizeMake(D_WIDTH*3,D_HEIGHT))
        .L_AddView(self.view);
    }];
    _mainScrollView.delegate = self;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, D_HEIGHT_NO_NAV-55, D_WIDTH,50)];
    _pageControl.numberOfPages = self.prizeArr.count;
    _pageControl.currentPage   = self.nowIdx;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = HEX_COLOR(APP_MAIN_COLOR);
    [self.view addSubview:_pageControl];
    
    
    for(int i=0;i<self.prizeArr.count;i++){
        
        NSDictionary * dictData = self.prizeArr[i];
        
        UIView * matchPrizeViewBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(i*D_WIDTH, 0,D_WIDTH,D_HEIGHT))
            .L_AddView(_mainScrollView);
        }];


        //奖品
        UIView * prizeView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15, D_WIDTH - CARD_MARGIN_LEFT *2,D_HEIGHT_NO_NAV - 80))
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_BgColor([UIColor whiteColor])
            .L_AddView(matchPrizeViewBox);
        }];

        
        NSString * prizeImageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"image"]];
        
        //奖品图
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(0,0,[prizeView width],[prizeView height]-80))
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_ImageUrlName(prizeImageUrl,IMAGE_DEFAULT)
            .L_raius_location(UIRectCornerTopLeft|UIRectCornerTopRight,5)
            .L_AddView(prizeView);
        }];
        
        //奖品说明
        UIView * prizetTextView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(0,[prizeView height] - 80,[prizeView width],80))
            .L_BgColor([UIColor blackColor])
            .L_Alpha(0.8)
            .L_raius_location(UIRectCornerBottomLeft|UIRectCornerBottomRight,5)
            .L_AddView(prizeView);
        }];
        
        
        //奖品排名
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,0,[prizeView width],50))
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
            .L_Text([NSString stringWithFormat:@"第 [ %d ] 名奖品",(i+1)])
            .L_textAlignment(NSTextAlignmentCenter)
            .L_raius_location(UIRectCornerTopRight|UIRectCornerTopLeft,5)
            .L_alpha(0.8)
            .L_AddView(prizeView);
        }];

        
        UILabel * prizeName = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,20,D_WIDTH,SUBTITLE_FONT_SIZE))
            .L_Text(dictData[@"text"])
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
            .L_textAlignment(NSTextAlignmentCenter)
            .L_AddView(prizetTextView);
        }];
        
        NSString * rank;
        if([dictData[@"rank"] isEqualToString:@""]){
            rank = @"无";
        }else{
            rank = dictData[@"rank"];
        }
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,[prizeName bottom]+10,D_WIDTH,SUBTITLE_FONT_SIZE))
            .L_Text([NSString stringWithFormat:@"头衔奖励：%@",rank])
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(@"CCCCCC"))
            .L_textAlignment(NSTextAlignmentCenter)
            .L_AddView(prizetTextView);
        }];
        

        [_mainScrollView setContentOffset:CGPointMake(self.nowIdx * D_WIDTH,0)];
        
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = (int)scrollNowX / D_WIDTH;
    
    _pageControl.currentPage = nowIdx;
    
}

@end
