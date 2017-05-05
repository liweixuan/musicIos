#import "InteractionViewController.h"
#import "DynamicView.h"
#import "DynamicFilterView.h"
#import "PartnerView.h"
#import "OrganizationView.h"
#import "MatchView.h"
#import "CreateInteractionViewController.h"
#import "InteractionCommentViewController.h"
#import "UserDetailViewController.h"
#import "CreatePartnerViewController.h"
#import "OrganizationDetailViewController.h"
#import "MatchDetailViewController.h"
#import "CreateOrganizationViewController.h"

@interface InteractionViewController ()<UIScrollViewDelegate,DynamicViewDelegate,PartnerViewDelegate,OrganizationViewDelegate,MatchViewDelegate>
{
    
    NSArray      * _menuArr;                 //菜单项数组
    NSInteger      _nowSelectViewIdx;        //当前选中项的视图索引
    
    UIView       * _selectMenuView;          //菜单选中时视图
    UIView       * _leftMenuBox;             //左侧菜单视图
    UIScrollView * _interactionScrollBox;    //互动滚动总容器
    UITableView  * _interactionTableView;    //动态列表视图
    UIButton     * _addBtn;                  //添加按钮
    UIView       * _maskBoxView;             //遮罩总视图
    UIView       * _navigationBox;           //顶部自定义导航条

    
    DynamicView       * _dynamicView;
    DynamicFilterView * _dynamicFilterView;
    
    PartnerView       * _partnerView;
    
    OrganizationView  * _organizationView;
    
    MatchView         * _matchView;
}
@end

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化变量
    [self initVar];
   
    //创建主容器框
    [self createScrollBox];
    
    //创建菜单内容主视图
    [self createMenuMainView];
    
    //创建全局添加按钮
    [self createAddBtn];
    
    //创建全局遮罩视图
    [self createMaskView];
    
    //创建各个菜单的筛选视图
    [self createMenuFilterView];
    
    //初始化数据
    [self initData];
    

    
}

-(void)viewWillDisappear:(BOOL)animated {
  
    //隐藏顶部自定义导航条
    [UIView animateWithDuration:0.3 animations:^{
        _navigationBox.alpha  = 0.0;
    } completion:^(BOOL finished) {
        _navigationBox.hidden = YES;
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    
    //自定义导航条视图
    [self createCustomNavigationView];
    
    NSLog(@"即将进入");
}

#pragma mark - 初始化部分

//初始化变量
-(void)initVar {
    
    _menuArr          = @[@"动态",@"伙伴",@"团体",@"比赛"];
    _nowSelectViewIdx = 0;
    
}

//初始化数据
-(void)initData {
    
    //获取当前是在第几个view,请求相应的view视图的数据
    if(_nowSelectViewIdx == 0){
        
         [self showAddBtn];
        
        //获取动态数据
        [_dynamicView getData:nil Type:@"init"];
    
    }else if(_nowSelectViewIdx == 1){
        
         [self showAddBtn];
        
        //获取找伙伴数据
        [_partnerView getData:nil Type:@"init"];
 
    }else if(_nowSelectViewIdx == 2){
        
        [self showAddBtn];
        
        //获取找团体数据
        [_organizationView getData:nil Type:@"init"];
        
    }else{
        
        [self hidenAddBtn];
        
        //获取找比赛数据
        [_matchView getData:nil Type:@"init"];
        
        
 
    }
    
}


#pragma mark - 视图创建部分

//创建主容器框
-(void)createScrollBox {
    
    _interactionScrollBox = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor clearColor])
        .L_bounces(NO)
        .L_pagingEnabled(YES)
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_contentSize(CGSizeMake(D_WIDTH*_menuArr.count,D_HEIGHT))
        .L_AddView(self.view);
    }];
    
    //设置代理
    _interactionScrollBox.delegate = self;

}

//创建内容主视图
-(void)createMenuMainView {
    
    //创建互动视图
    _dynamicView = [[DynamicView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT_NO_NAV_STATUS)];
    _dynamicView.delegate = self;
    [_interactionScrollBox addSubview:_dynamicView];

    
    //创建伙伴视图
    _partnerView = [[PartnerView alloc] initWithFrame:CGRectMake(D_WIDTH,0,D_WIDTH,D_HEIGHT_NO_NAV_STATUS)];
    _partnerView.delegate = self;
    [_interactionScrollBox addSubview:_partnerView];
    
    //创建团体视图
    _organizationView = [[OrganizationView alloc] initWithFrame:CGRectMake(D_WIDTH*2,0,D_WIDTH,D_HEIGHT_NO_NAV_STATUS)];
    _organizationView.delegate = self;
    [_interactionScrollBox addSubview:_organizationView];
    
    //创建比赛视图
    _matchView = [[MatchView alloc] initWithFrame:CGRectMake(D_WIDTH*3,0,D_WIDTH,D_HEIGHT_NO_NAV_STATUS)];
    _matchView.delegate = self;
    [_interactionScrollBox addSubview:_matchView];
}

//创建自定义导航条
-(void)createCustomNavigationView {
  
    //如果有直接显示，不在创建
    if(_navigationBox != nil){
        [UIView animateWithDuration:0.3 animations:^{
            _navigationBox.alpha  = 1;
            _navigationBox.hidden = NO;
        }];
        
        return;
    }
    
    //创建导航条容器视图
    _navigationBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,NAV_HEIGHT))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.navigationController.navigationBar);
    }];
    
    //创建右侧筛选图标视图
    UIView * filterView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(D_WIDTH - 50,0,50,NAV_HEIGHT))
        .L_Click(self,@selector(filterClick))
        .L_AddView(_navigationBox);
    }];
    
    //右侧分割线图标
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,[filterView height]/2-NAV_ICON_HEIGHT/2,14,NAV_ICON_HEIGHT))
        .L_ImageName(@"test2.jpg")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(filterView);
    }];
    
    //右侧筛选图标
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(15,[filterView height]/2-NAV_ICON_HEIGHT/2,NAV_ICON_WIDTH,NAV_ICON_HEIGHT))
        .L_ImageName(@"test1.jpg")
        .L_AddView(filterView);
    }];

    
    //创建左侧菜单视图
    _leftMenuBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH - [filterView width],NAV_HEIGHT))
        .L_AddView(_navigationBox);
    }];
 
    //菜单项视图宽度
    CGFloat menuViewWidth = [_leftMenuBox width]/_menuArr.count;
    
    //创建左侧菜单项
    for(int i=0;i<_menuArr.count;i++){
        
        //x坐标位置
        CGFloat menuX = i * menuViewWidth;
        
        //菜单项视图
        UIView * menuItemView = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_Frame(CGRectMake(menuX,0,menuViewWidth,NAV_HEIGHT))
            .L_AddView(_leftMenuBox);
            
        }];
        
        //菜单标题
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,0,menuViewWidth,NAV_HEIGHT))
            .L_textAlignment(NSTextAlignmentCenter)
            .L_Text(_menuArr[i])
            .L_Font(NAV_FONT_SIZE_COLOR)
            .L_TextColor(HEX_COLOR(NAV_FONT_COLOR))
            .L_AddView(menuItemView);
        }];
        
        //为菜单项添加单击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap:)];
        menuItemView.tag = i;
        [menuItemView addGestureRecognizer:tap];
        
    }
    
    //创建选中时视图
    _selectMenuView = [UIView ViewInitWith:^(UIView *view) {
        
        view
        .L_Frame(CGRectMake(0,NAV_HEIGHT-1.5,menuViewWidth,1.5))
        .L_BgColor([UIColor blackColor])
        .L_AddView(_leftMenuBox);
        
    }];
    
}

//创建全局添加按钮
-(void)createAddBtn {
    
    _addBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake(D_WIDTH - 65,self.view.frame.size.height - 185,56,56))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"创建",UIControlStateNormal)
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_TargetAction(self,@selector(createBtnClick),UIControlEventTouchUpInside)
        .L_radius_NO_masksToBounds(28)
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_AddView(self.view);
        
    } buttonType:UIButtonTypeCustom];
    
   
    
    
}

//创建全局遮罩视图
-(void)createMaskView {
    _maskBoxView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.navigationController.view);
    }];

    
    
    
}

//创建各个菜单筛选项视图
-(void)createMenuFilterView {
    
    _dynamicFilterView = [[DynamicFilterView alloc] initWithFrame:CGRectMake(D_WIDTH,0,D_WIDTH-80,D_HEIGHT)];
    _dynamicFilterView.backgroundColor = HEX_COLOR(VC_BG);
    [self.navigationController.view addSubview:_dynamicFilterView];
    
    
}

#pragma mark - 事件处理
-(void)menuTap:(UITapGestureRecognizer *)tapView {
    
    //获取当前点击项
    NSInteger nowTag = tapView.view.tag;
    
    //获取当前选中视图的x轴
    CGFloat nowX = [_selectMenuView width] * nowTag;

    //移动选中项到当前项
    [UIView animateWithDuration:0.3 animations:^{
        
        [_selectMenuView setX:nowX];
        
        [_interactionScrollBox setContentOffset:CGPointMake(D_WIDTH*nowTag,0)];
        
    }];

    _nowSelectViewIdx = nowTag;
    
    //请求数据
    [self initData];
 
}

//筛选按钮点击时
-(void)filterClick {
    NSLog(@"筛选...");
    
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.3;
        [_dynamicFilterView setX:80];
    }];
}

//遮罩视图点击时
-(void)maskBoxClick {
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.0;
        [_dynamicFilterView setX:D_WIDTH];
    }];
}

//创建按钮点击时
-(void)createBtnClick {
    
    //判断创建的菜单
    if(_nowSelectViewIdx == 0){
        PUSH_VC(CreateInteractionViewController, YES, @{});
    }else if(_nowSelectViewIdx == 1){
        PUSH_VC(CreatePartnerViewController,YES,@{});
    }else if(_nowSelectViewIdx == 2){
        PUSH_VC(CreateOrganizationViewController, YES, @{});
    }else{
        
    }
    
    
}

//显示添加按钮
-(void)showAddBtn {
    if(_addBtn.hidden){

        [UIView animateWithDuration:0.3 animations:^{
            _addBtn.alpha = 1.0;
            _addBtn.hidden = NO;
        }];
    }
    
    
}

//隐藏添加按钮
-(void)hidenAddBtn {
    
    if(!_addBtn.hidden){
        [UIView animateWithDuration:0.3 animations:^{
            _addBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            _addBtn.hidden = YES;
        }];
    }
    
}

#pragma mark - 代理事件

//拖动滚动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //在整个视图中的拖动比例
    CGFloat scrollScale = scrollNowX / scrollView.contentSize.width;
    
    //移动选中视图
    [_selectMenuView setX:[_leftMenuBox width] * scrollScale];
 
    
    
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

//动态评论按钮点击时
-(void)dynamicCommentClick:(DynamicFrame *)dynamicFrame {
    PUSH_VC(InteractionCommentViewController, YES, @{@"dynamicFrame":dynamicFrame});
}

//动态头像点击时
-(void)publicUserHeaderClick:(NSInteger)userId {
    PUSH_VC(UserDetailViewController, YES, @{@"userId":@(userId)});
}

//点击团体，查看团体详细
-(void)organizationItemClick:(NSInteger)organizationId {
    PUSH_VC(OrganizationDetailViewController, YES, @{@"organizationId":@(organizationId)});
}

//向外传递网络请求错误
-(void)requestFaild:(NSInteger)menuIdx {
    [self startError:@"网络请求错误"];
}

//比赛去投票点击
-(void)voteClick:(NSInteger)matchId {
    PUSH_VC(MatchDetailViewController, YES, @{@"matchId":@(matchId)});
}

//错误后点击重新加载
-(void)dataReset {
    [self initData];
}

@end
