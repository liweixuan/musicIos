//
//  GuideViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "CustomNavigationController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _guideScrollView;
    UIPageControl * _pageControl;
    NSArray      * _guideArr;
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initVar];
    
    //创建视图
    [self createView];
    
    
    
    
    
}

-(void)initVar {
    
    _guideArr = @[
                  @{@"bg":@"guide_1_bg",@"icon":@"guide_1_icon",@"border":@"border_1",@"title":@"guide_1_title",@"text":@"突出提供全国互动圈，团体组织，线下互动，官方比赛等特色"},
                  @{@"bg":@"guide_2_bg",@"icon":@"guide_2_icon",@"border":@"border_2",@"title":@"guide_2_title",@"text":@"突出社交的多样化，地理查找，听听查找，乐器筛选，并且都是乐器属性的小伙伴喔"},
                  @{@"bg":@"guide_3_bg",@"icon":@"guide_3_icon",@"border":@"border_3",@"title":@"guide_3_title",@"text":@"最专业的手机曲谱库，让您随时随地可以进行乐谱的查找与演奏"}
    ];
    
}

-(void)createView {
    
    _guideScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_contentSize(CGSizeMake(D_WIDTH * _guideArr.count,D_HEIGHT))
        .L_pagingEnabled(YES)
        .L_bounces(NO)
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_AddView(self.view);
    }];
    _guideScrollView.delegate = self;
    
    //创建跳过按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(D_WIDTH - 80,20,60,20))
        .L_BgColor([UIColor whiteColor])
        .L_Font(12)
        .L_Title(@"跳过",UIControlStateNormal)
        .L_TitleColor([UIColor blackColor],UIControlStateNormal)
        .L_TargetAction(self,@selector(goLogin),UIControlEventTouchUpInside)
        .L_Alpha(0.3)
        .L_radius(5)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
    //循环创建每一项
    for(int i = 0;i<_guideArr.count;i++){
        
        NSDictionary * dictData = _guideArr[i];
        
        UIView * guideItemBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(i*D_WIDTH,0,D_WIDTH,D_HEIGHT))
            .L_AddView(_guideScrollView);
        }];
        
        //背景图片
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(0,0, D_WIDTH, D_HEIGHT))
            .L_ImageName(dictData[@"bg"])
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(guideItemBox);
        }];
        
        //标题文字
        UIImageView * titleImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - (D_WIDTH*0.5)/2,D_HEIGHT * 0.12, D_WIDTH*0.5,40))
            .L_ImageName(dictData[@"title"])
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(guideItemBox);
        }];
        
        CGFloat borderX = 0.0;
        if(i == 0){
            borderX = 15;
        }else if(i == 1){
            borderX = 30;
        }else{
            borderX = 45;
        }
        
        //内容框
        UIImageView * borderImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(borderX,[titleImage bottom]+15,D_WIDTH - 60,160))
            .L_ImageName(dictData[@"border"])
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(guideItemBox);
        }];
        
        
        CGFloat contentLabelX = 0.0;
        CGFloat contentLabelY = 0.0;
        CGFloat contentLabelW = 0.0;
        if(i == 0){
            contentLabelX = 70;
            contentLabelY = 15;
            contentLabelW = [borderImage width] - contentLabelX - 10;
        }else if(i== 1){
            contentLabelX = 50;
            contentLabelY = 30;
            contentLabelW = [borderImage width] - contentLabelX * 2;
        }else{
            contentLabelX = 30;
            contentLabelY = 10;
            contentLabelW = [borderImage width] - contentLabelX * 4;
        }
        
        //放置内容
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(contentLabelX,contentLabelY,contentLabelW,[borderImage height]))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
            .L_Text(dictData[@"text"])
            .L_lineHeight(10)
            .L_numberOfLines(0)
            .L_AddView(borderImage);
        }];
        
        
        CGFloat iconImageW = 0.0;
        CGFloat iconImageH = 0.0;
        CGFloat iconImageX = 0.0;
        CGFloat iconImageY = 0.0;
        if(i == 0){
            iconImageX = D_WIDTH/2 - (D_WIDTH * 0.7)/2 + 15;
            iconImageH = D_WIDTH * 0.7;
            iconImageW = D_WIDTH * 0.7;
            iconImageY = D_HEIGHT - D_WIDTH * 0.7 - 70;
        }else if(i == 1){
            iconImageX = 0;
            iconImageH = D_WIDTH * 0.7;
            iconImageW = D_WIDTH;
            iconImageY = D_HEIGHT - D_WIDTH * 0.7 - 70;
        }else{
            iconImageX = D_WIDTH/2 - (D_WIDTH * 0.7)/2 + 20;
            iconImageH = D_WIDTH * 0.6;
            iconImageW = D_WIDTH * 0.6;
            iconImageY = D_HEIGHT - D_WIDTH * 0.7 - 90;
        }
        
        //图标
        UIImageView * iconImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(iconImageX,iconImageY,iconImageW,iconImageH))
            .L_ImageName(dictData[@"icon"])
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(guideItemBox);
        }];

        //添加立即体验按钮
        if(i == 2){
            
            [UIButton ButtonInitWith:^(UIButton *btn) {
                btn
                .L_Frame(CGRectMake(D_WIDTH/2 -120/2,[iconImage bottom]+20,120,35))
                .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
                .L_Font(CONTENT_FONT_SIZE)
                .L_Title(@"立即体验",UIControlStateNormal)
                .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
                .L_TargetAction(self,@selector(goLogin),UIControlEventTouchUpInside)
                .L_Alpha(0.8)
                .L_radius(5)
                .L_AddView(guideItemBox);
            } buttonType:UIButtonTypeCustom];
            
        }
        
        
    }
    
  
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, D_HEIGHT - 50, D_WIDTH,30)];
    _pageControl.numberOfPages = _guideArr.count;
    _pageControl.currentPage   = 0;
    _pageControl.pageIndicatorTintColor = HEX_COLOR(APP_MAIN_COLOR);
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
    
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = (int)scrollNowX / D_WIDTH;
    
    _pageControl.currentPage = nowIdx;
    
}


//去登录界面
-(void)goLogin {
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    CustomNavigationController * customNav = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window makeKeyAndVisible];
    [UIView transitionFromView:window.rootViewController.view toView:customNav.navigationController.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        window.rootViewController = customNav;
    }];
    
}
@end
