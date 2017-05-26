//
//  MusicScoreViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicScoreViewController.h"
#import "MyMusicScoreView.h"
#import "AllMusicScoreView.h"
#import "MusicScoreCategoryViewController.h"

@interface MusicScoreViewController ()<UIScrollViewDelegate,AllMusicScoreViewDelegate>
{
    NSInteger          _nowSelectViewIdx;
    Base_UITableView * _tableview;
    UIView           * _nowSelectLineView;
    UILabel          * _myMusicScoreMenu;        //我的曲谱
    UILabel          * _allMusicScoreMenu;       //曲谱库
    UIScrollView     * _mainScrollView;          //滚动总容器
    UIView           * _menuView;                //菜单视图
    
    MyMusicScoreView  * _myMusicScoreView;        //我的曲谱视图
    AllMusicScoreView * _allMusicScoreView;       //曲谱库视图
}
@end

@implementation MusicScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曲谱";
    
    //初始化变量
    [self initVar];
    
    //获取相应数据
    [self initData];
    
    //创建切换菜单视图
    [self createMenu];
    
    //创建切换总容器
    [self createScrollBox];
    
    //创建内容主视图
    [self createMenuMainView];

}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
}

//初始化变量
-(void)initVar {
    _nowSelectViewIdx = 0;
}


//获取相应数据
-(void)initData {
    
    
}

//创建切换总容器
-(void)createScrollBox {
    
    _mainScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,[_menuView height],D_WIDTH,D_HEIGHT_NO_NAV_STATUS - [_menuView height]))
        .L_bounces(NO)
        .L_pagingEnabled(YES)
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_contentSize(CGSizeMake(D_WIDTH*2,D_HEIGHT_NO_NAV_STATUS - [_menuView height]))
        .L_AddView(self.view);
    }];
    
    
    //设置代理
    _mainScrollView.delegate = self;
}


//创建切换菜单视图
-(void)createMenu {
    
    //切换菜单视图
    _menuView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0, D_WIDTH,36))
        .L_BgColor([UIColor whiteColor])
        .L_shadowOpacity(0.1)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_AddView(self.view);
    }];
    
    //我的曲谱
    _myMusicScoreMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,0,D_WIDTH/2,[_menuView height]))
        .L_Text(@"我的曲谱")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * officialMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _myMusicScoreMenu.tag = 0;
    [_myMusicScoreMenu addGestureRecognizer:officialMenuTap];
    
    //曲谱库
    _allMusicScoreMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/2,0,D_WIDTH/2,[_menuView height]))
        .L_Text(@"曲谱库")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * teacherMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _allMusicScoreMenu.tag = 1;
    [_allMusicScoreMenu addGestureRecognizer:teacherMenuTap];
    
    //当前选中状态线
    _nowSelectLineView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[_menuView height]-1.5,D_WIDTH/2,1.5))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_menuView);
    }];
    
}

//创建内容主视图
-(void)createMenuMainView {
    
    //创建互动视图
    _myMusicScoreView = [[MyMusicScoreView alloc] initWithFrame:CGRectMake(0,0,[_mainScrollView width],[_mainScrollView height])];
    [_mainScrollView addSubview:_myMusicScoreView];
    
    
    //创建伙伴视图
    _allMusicScoreView = [[AllMusicScoreView alloc] initWithFrame:CGRectMake(D_WIDTH,0,[_mainScrollView width],[_mainScrollView height])];
    _allMusicScoreView.delegate = self;
    [_mainScrollView addSubview:_allMusicScoreView];
    
}


#pragma mark - 事件处理
-(void)menuTap:(UITapGestureRecognizer *)tapView {
    
    
    //获取当前点击项
    NSInteger nowTag = tapView.view.tag;
    
    //获取当前选中视图的x轴
    CGFloat nowX = [_nowSelectLineView width] * nowTag;
    
    //移动选中项到当前项
    [UIView animateWithDuration:0.3 animations:^{
        
        [_nowSelectLineView setX:nowX];
        
        [_mainScrollView setContentOffset:CGPointMake(D_WIDTH*nowTag,0)];
        
    }];
    
    _nowSelectViewIdx = nowTag;
    
    //请求数据
    [self initData];
    
}

#pragma mark - 代理事件

//拖动滚动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //在整个视图中的拖动比例
    CGFloat scrollScale = scrollNowX / scrollView.contentSize.width;
    
    //移动选中视图
    [_nowSelectLineView setX:[_menuView width] * scrollScale];
    
    
    
}

//滚动完成时
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = (int)scrollNowX / D_WIDTH;
    
    //设置当前选中视图的索引
    _nowSelectViewIdx = nowIdx;
    
    //当前切换到了第几个视图
    NSLog(@"%ld",(long)nowIdx);
    
    
}

//点击乐谱类别分类
-(void)musicScoreCategoryClick:(NSInteger)categoryId  {
    NSLog(@"%ld",(long)categoryId);
    PUSH_VC(MusicScoreCategoryViewController,YES, @{});
}

@end
