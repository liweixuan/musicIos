#import "FriendViewController.h"
#import "FriendView.h"
#import "ConcernView.h"
#import "MyOrganizationView.h"
#import "FindFriendViewController.h"

@interface FriendViewController ()<UIScrollViewDelegate,FriendViewDelegate>
{
    NSInteger      _nowSelectViewIdx;
    UIScrollView * _mainScrollView;      //滚动总容器
    UIView       * _menuView;            //菜单视图
    UIView       * _navigationBox;       //自定义导航视图
    UILabel      * _friendMenu;          //好友菜单
    UILabel      * _concernMenu;         //关注菜单
    UILabel      * _organizationMenu;    //团体菜单
    UIView       * _nowSelectLineView;   //当前选中的菜单项
    
    FriendView         * _friendView;
    ConcernView        * _concernView;
    MyOrganizationView * _myOrganizationView;
    
    
}
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友";
    
    //初始化变量
    [self initVar];
    
    //创建自定义导航菜单
    [self createNav];
    
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
    
    
    //初始化数据
    [self initData];
}

//初始化变量
-(void)initVar {
    _nowSelectViewIdx = 0;
}

//初始化数据
-(void)initData {
    
    //获取当前是在第几个view,请求相应的view视图的数据
    if(_nowSelectViewIdx == 0){
        
        //好友
        [_friendView getData:@{@"u_username":[UserData getUsername]} Type:@"init"];
        
    }else if(_nowSelectViewIdx == 1){
        
        //关注
        [_concernView getData:nil Type:@"init"];
        
    }else{
        
        //团体
        [_myOrganizationView getData:nil Type:@"init"];
        
    }
    
}

//创建主容器视图
-(void)createMenuMainView {
    
    //创建好友视图
    _friendView = [[FriendView alloc] initWithFrame:CGRectMake(0,0,[_mainScrollView width], [_mainScrollView height])];
    _friendView.delegate = self;
    [_mainScrollView addSubview:_friendView];
    
    
    //创建关注视图
    _concernView = [[ConcernView alloc] initWithFrame:CGRectMake(D_WIDTH,0,[_mainScrollView width], [_mainScrollView height])];
    [_mainScrollView addSubview:_concernView];
    
    
    //创建团体视图
    _myOrganizationView = [[MyOrganizationView alloc] initWithFrame:CGRectMake(D_WIDTH*2,0,[_mainScrollView width],[_mainScrollView height])];
    [_mainScrollView addSubview:_myOrganizationView];
    
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
        .L_contentSize(CGSizeMake(D_WIDTH*3,D_HEIGHT_NO_NAV_STATUS - [_menuView height]))
        .L_AddView(self.view);
    }];
    
    
    //设置代理
    _mainScrollView.delegate = self;
    
}

//创建自定义导航菜单
-(void)createNav {
    
 
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
    
    //创建官方课程菜单
    _friendMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,0,D_WIDTH/3,[_menuView height]))
        .L_Text(@"好友")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * firnedMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _friendMenu.tag = 0;
    [_friendMenu addGestureRecognizer:firnedMenuTap];
    
    //创建独立教师菜单
    _concernMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/3,0,D_WIDTH/3,[_menuView height]))
        .L_Text(@"关注")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * concernMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _concernMenu.tag = 1;
    [_concernMenu addGestureRecognizer:concernMenuTap];
    
    
    //创建团体菜单
    _organizationMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/3 * 2,0,D_WIDTH/3,[_menuView height]))
        .L_Text(@"我的团体")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * organizationMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _organizationMenu.tag = 2;
    [_organizationMenu addGestureRecognizer:organizationMenuTap];
    
    //当前选中状态线
    _nowSelectLineView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[_menuView height]-1.5,D_WIDTH/3,1.5))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_menuView);
    }];
    
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
//进入发现好友界面
-(void)findFriendClick {
    PUSH_VC(FindFriendViewController, YES, @{});
}
@end
