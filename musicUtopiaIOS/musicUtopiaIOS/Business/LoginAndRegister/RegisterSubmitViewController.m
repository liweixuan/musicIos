//
//  RegisterSubmitViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RegisterSubmitViewController.h"
#import "MusciCategorySelectView.h"
#import "MenuTabBarController.h"
#import "AppDelegate.h"

@interface RegisterSubmitViewController ()<MusciCategorySelectViewDelegate>
{
    UIScrollView * _scrollBoxView;
    UITextField  * _nicknameInput;
    
    NSString  * _cname;
    NSInteger   _cid;
}
@end

@implementation RegisterSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择擅长乐器";
    
    [self initVar];
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"立即注册",registerSubmit)
    
    //设置滚动父容器
    [self createScrollView];
    
    //创建视图
    [self createView];
    
}

-(void)initVar {
    _cname = @"";
    _cid   = 0;
}

-(void)createScrollView {
    
    _scrollBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        
        view
        .L_Frame(self.view.frame)
        .L_contentSize(CGSizeMake(D_WIDTH,1000))
        .L_AddView(self.view);
        
    }];
    
}

//创建视图
-(void)createView {

    
    
    NSArray * categoryArr = [LocalData getStandardMusicCategory];
    
    MusciCategorySelectView * musicCategorySelectView = [[MusciCategorySelectView alloc] init];
    musicCategorySelectView.delegate = self;
    NSDictionary * musicCategoryDict = [musicCategorySelectView createViewBoxWidth:D_WIDTH - CARD_MARGIN_LEFT * 2  CategoryArr:categoryArr];
    
    
    //主擅长乐器容器
    UIView * beGoodBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT * 2,[musicCategoryDict[@"height"] floatValue]))
        .L_AddView(_scrollBoxView);
    }];
    
    [beGoodBox addSubview:musicCategoryDict[@"view"]];
    
}

#pragma mark - 事件
-(void)registerSubmit {
    
    NSLog(@"%@",self.phone);
    NSLog(@"%@",self.nickname);
    NSLog(@"%ld",(long)self.sex);
    NSLog(@"%@",self.password);
    NSLog(@"%@",_cname);
    NSLog(@"%ld",_cid);
    NSLog(@"%@",self.headerUrl);
    NSDictionary * registerParams = @{
        @"u_username":self.phone,
        @"u_password":self.password,
        @"u_sex":@(self.sex),
        @"u_header_url":self.headerUrl,
        @"u_nickname":self.nickname,
        @"u_good_instrument":[NSString stringWithFormat:@"%ld|%@",(long)_cid,_cname]
    };
    
    [self startActionLoading:@"注册中..."];
    [NetWorkTools POST:API_USER_REGISTER params:registerParams successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"注册成功");
        
        //注册成功后处理
        NSLog(@"%@",array);
        NSDictionary * dictData = (NSDictionary *)array;
        
        [UserData saveUserInfo:dictData];
        
 
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MenuTabBarController *menuTabController = [[MenuTabBarController alloc] init];
        menuTabController.selectedIndex = DEFAULT_TAB_INDEX;
        appDelegate.window.rootViewController = menuTabController;
  
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
        
    }];
    
    
}


-(void)categoryClick:(NSString *)c_name Cid:(NSInteger)c_id {
    _cname = c_name;
    _cid   = c_id;
}

@end
