#import "TeachViewController.h"
#import "OfficialView.h"
#import "IndependenceTeacherView.h"
#import "OfficialStageViewController.h"
#import "IndependenceTeacherDetailViewController.h"

@interface TeachViewController ()<UIScrollViewDelegate,OfficialViewDelegate,IndependenceTeacherViewDelegate>
{
    NSInteger      _nowSelectViewIdx;
    
    UIView       * _navigationBox;       //自定义导航视图
    UIView       * _nowSelectLineView;   //当前选中的菜单项
    UILabel      * _officialMenu;        //官方菜单
    UILabel      * _teacherMenu;         //独立教师菜单
    UIScrollView * _mainScrollView;      //滚动总容器
    UIView       * _menuView;            //菜单视图
    UIView       * _teacherModeView;     //右侧按钮视图区域
    
    OfficialView             * _officialView;               //官方主内容视图
    IndependenceTeacherView  * _independenceTeacherView;    //独立教师主内容视图
}
@end

@implementation TeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];

    //创建切换总容器
    [self createScrollBox];
    
    //创建自定义导航菜单
    [self createNav];

    //创建内容主视图
    [self createMenuMainView];
    
    //初始化数据
    [self initData];
    
    
}

-(void)initVar {
    _nowSelectViewIdx = 0;
}

-(void)initData {
  
    //获取当前是在第几个view,请求相应的view视图的数据
    if(_nowSelectViewIdx == 0){

        //获取官方课程
        [_officialView getData:nil Type:@"init"];
 
    }else{
 
        //获取独立教师
        [_independenceTeacherView getData:nil Type:@"init"];
            
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //隐藏顶部自定义导航条
    [UIView animateWithDuration:0.3 animations:^{
        _navigationBox.alpha  = 0.0;
    } completion:^(BOOL finished) {
        _navigationBox.hidden = YES;
    }];
    
    //导航条阴影
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    //自定义导航条视图
    [self createNav];
    
    NSLog(@"即将进入");
}

#pragma mark - 视图创建相关
//创建内容主视图
-(void)createMenuMainView {
    
    //创建互动视图
    _officialView = [[OfficialView alloc] initWithFrame:CGRectMake(0,[_menuView height],[_mainScrollView width],D_HEIGHT_NO_NAV_STATUS - [_menuView height])];
    _officialView.delegate = self;
    [_mainScrollView addSubview:_officialView];
    
    
    //创建伙伴视图
    _independenceTeacherView = [[IndependenceTeacherView alloc] initWithFrame:CGRectMake(D_WIDTH,[_menuView bottom],[_mainScrollView width],D_HEIGHT_NO_NAV_STATUS - [_menuView height])];
    _independenceTeacherView.delegate = self;
    [_mainScrollView addSubview:_independenceTeacherView];
    
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

//创建自定义导航菜单
-(void)createNav {
    
    //如果有直接显示，不在创建
    if(_navigationBox != nil){
        [UIView animateWithDuration:0.3 animations:^{
            _navigationBox.alpha  = 1;
            _navigationBox.hidden = NO;
            
            //隐藏原有的导航条阴影
            self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
        }];
        
        return;
    }

    //隐藏原有的导航条阴影
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;

    //创建导航条容器视图
    _navigationBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,44))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.navigationController.navigationBar);
    }];
    
    //主标题
    UILabel * navTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Text(@"教学")
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Frame(CGRectMake(0,10,D_WIDTH,TITLE_FONT_SIZE))
        .L_AddView(_navigationBox);
    }];
    
    //导航副标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Text(@"为您提供乐器视频教学服务")
        .L_Font(10)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Frame(CGRectMake(0,[navTitle bottom]+5,D_WIDTH,ATTR_FONT_SIZE))
        .L_AddView(_navigationBox);
    }];
    
    //创建独立教师状态下的右侧菜单按钮
    _teacherModeView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(D_WIDTH - 85,0,70,[_navigationBox height]))
        .L_Alpha(0.0)
        .L_AddView(_navigationBox);
    }];
    
    //默认隐藏
    _teacherModeView.hidden = YES;
    
    //左侧按钮
    UIImageView * modeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,[_navigationBox height]/2 - NAV_ICON_HEIGHT/2, NAV_ICON_WIDTH,NAV_ICON_HEIGHT))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_teacherModeView);
    }];
    
    //中间分割线图标
    UIImageView * middleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([modeIcon right]+5,[_navigationBox height]/2-NAV_ICON_HEIGHT/2,14,NAV_ICON_HEIGHT))
        .L_ImageName(@"test2.jpg")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(_teacherModeView);
    }];
    
    //右侧按钮
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([middleIcon right]+5,[_navigationBox height]/2 - NAV_ICON_HEIGHT/2, NAV_ICON_WIDTH,NAV_ICON_HEIGHT))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_teacherModeView);
    }];
    
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
    _officialMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,0,D_WIDTH/2,[_menuView height]))
        .L_Text(@"官方课程")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];

    
    //为菜单项添加单击手势
    UITapGestureRecognizer * officialMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _officialMenu.tag = 0;
    [_officialMenu addGestureRecognizer:officialMenuTap];
    
    //创建独立教师菜单
    _teacherMenu = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/2,0,D_WIDTH/2,[_menuView height]))
        .L_Text(@"独立教师")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_menuView);
    }];
    
    //为菜单项添加单击手势
    UITapGestureRecognizer * teacherMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
    _teacherMenu.tag = 1;
    [_teacherMenu addGestureRecognizer:teacherMenuTap];
    
    //当前选中状态线
    _nowSelectLineView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,[_menuView height]-1.5,D_WIDTH/2,1.5))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_menuView);
    }];
    
}

#pragma mark - 事件处理
-(void)menuTap:(UITapGestureRecognizer *)tapView {
    
    
    //获取当前点击项
    NSInteger nowTag = tapView.view.tag;
    
    //判断是否显示右侧按钮菜单
    if(nowTag == 0){
        
        [UIView animateWithDuration:0.3 animations:^{
            _teacherModeView.alpha = 0.0;
        }completion:^(BOOL finished) {
            _teacherModeView.hidden = YES;
        }];
        
    }else{
        
        _teacherModeView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _teacherModeView.alpha = 1.0;
        }];
        
    }
    
    
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
-(void)officialCategoryClick:(NSDictionary *)dictData {
    
    OfficialStageViewController * officialStageVC = [[OfficialStageViewController alloc] init];
    officialStageVC.cid   = [dictData[@"cid"] integerValue];
    officialStageVC.cName = dictData[@"cname"];
    
    //跳转
    [self.navigationController pushViewController:officialStageVC animated:YES];
    
    
}

-(void)independenceTeacherClick:(NSDictionary *)dictData {
    
    IndependenceTeacherDetailViewController * independenceTeacherDetailVC = [[IndependenceTeacherDetailViewController alloc] init];
    
    //跳转
    [self.navigationController pushViewController:independenceTeacherDetailVC animated:YES];
    
}

@end
