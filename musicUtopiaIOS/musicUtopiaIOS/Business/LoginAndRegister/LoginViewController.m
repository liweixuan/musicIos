#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "MenuTabBarController.h"
#import "AppDelegate+Expand.h"

@interface LoginViewController ()
{
    UIScrollView * _scrollBoxView;
    UITextField  * _usernameInput;
    UITextField  * _passwordInput;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    //设置滚动父容器
    [self createScrollView];
    
    //创建右侧按钮
    [self createNavigationRightBtn];
    
    //创建视图
    [self createView];
    
}

//设置滚动父容器
-(void)createScrollView {
    
    _scrollBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        
        view
        .L_Frame(self.view.frame)
        .L_contentSize(CGSizeMake(D_WIDTH,1000))
        .L_Click(self,@selector(bgClick))
        .L_AddView(self.view);
        
    }];
    
  
}

//创建视图容器
-(void)createView {
    
    //Logo容器
    UIView * logoView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(D_WIDTH/2 - 150/2,40, 150,150))
        .L_AddView(_scrollBoxView);
    }];
    
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(15,15,120,120))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"yue_logo")
        .L_AddView(logoView);
    }];
    
    //创建输入容器框
    UIView * inputBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[logoView bottom]+40,D_WIDTH - CARD_MARGIN_LEFT *2,130))
        .L_AddView(_scrollBoxView);
    }];
    
    //帐号图标
    UIImageView * usernameIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"zhanghao");
    }];
    
    //输入框
    _usernameInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,0,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"用户帐号")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(usernameIcon)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];
    
    //密码图标
    UIImageView * passwordIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"mima");
    }];
    
    //输入框
    _passwordInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,[_usernameInput bottom]+10,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"用户密码")
        .L_BgColor([UIColor whiteColor])
        .L_LeftView(passwordIcon)
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];
    
    //登录按钮
    UIButton * loginBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[inputBox bottom],D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"登录",UIControlStateNormal)
        .L_TargetAction(self,@selector(loginClick),UIControlEventTouchUpInside)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_ShadowColor([UIColor grayColor])
        .L_radius_NO_masksToBounds(20)
        .L_AddView(_scrollBoxView);
    } buttonType:UIButtonTypeCustom];
    
    //忘记密码+注册容器
    UIView * ForgetPasswordAndRegsiterBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[loginBtn bottom]+10,D_WIDTH - CARD_MARGIN_LEFT * 2,ATTR_FONT_SIZE))
        .L_AddView(_scrollBoxView);
    }];
    
    //注册提示文字
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(10,0,100,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_isEvent(YES)
        .L_Text(@"还未注册？")
        .L_Click(self,@selector(registerClick))
        .L_AddView(ForgetPasswordAndRegsiterBox);
    }];
    
    //忘记密码提示文字
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([ForgetPasswordAndRegsiterBox width] - 110,0,100,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentRight)
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"忘记密码")
        .L_Click(self,@selector(forgetClick))
        .L_AddView(ForgetPasswordAndRegsiterBox);
    }];
    
    
    //第三方登录容器
    UIView * threeLoginBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[ForgetPasswordAndRegsiterBox bottom]+30,D_WIDTH - CARD_MARGIN_LEFT * 2,130))
        .L_AddView(_scrollBoxView);
    }];
    
    //登录标题
    UILabel * threeTitleLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,0,[threeLoginBox width],ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"第三方登录")
        .L_AddView(threeLoginBox);
    }];
    
    //三方登录的类型
    
    CGFloat tw = [threeLoginBox width] / 3;
    
    CGFloat ty = [threeTitleLabel bottom] + 30;
    
    NSArray * iconArr = @[@"qq",@"weixin",@"weibo"];
    
    for(int i =0;i<iconArr.count;i++){
        
        CGFloat tx = i * tw;
        
        UIView * threeItemView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(tx, ty, tw, 60))
            .L_AddView(threeLoginBox);
        }];
 
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(tw/2 - 60/2, 0, 60,60))
            .L_ImageName(iconArr[i])
            .L_Event(YES)
            .L_tag(i)
            .L_Click(self,@selector(threeIconClick:))
            .L_radius(30)
            .L_AddView(threeItemView);
        }];
        
    }
    

    //设置滚动容器
    _scrollBoxView.contentSize = CGSizeMake(D_WIDTH, [threeLoginBox bottom]+64);

}


-(void)createNavigationRightBtn {
    R_NAV_TITLE_BTN(@"R",@"注册",registerClick)
}

#pragma mark - 事件

//登录
-(void)loginClick {
    NSLog(@"登录");
    
    if([_usernameInput.text isEqualToString:@""]){
        SHOW_HINT(@"帐号不能为空");
        return;
    }
    
    if([_passwordInput.text isEqualToString:@""]){
        SHOW_HINT(@"密码不能为空");
        return;
    }
    
    [self startActionLoading:@"登录中..."];
    [NetWorkTools POST:API_USER_LOGIN params:@{@"u_username":_usernameInput.text,@"u_password":_passwordInput.text} successBlock:^(NSArray *array) {

        NSDictionary * dictData = (NSDictionary *)array;
        
        NSLog(@"&&&&&%@",dictData);
        
        [UserData saveUserInfo:dictData];
  
        //获取TOKEN所需参数
        NSDictionary * params = @{
                                  @"userId"      : dictData[@"u_username"],
                                  @"name"        : dictData[@"u_nickname"],
                                  @"portraitUri" : dictData[@"u_header_url"],
                                  };
        
        //获取融云连接TOKEN
        [NetWorkTools POST:API_RONGCLOUD_TOKEN params:params successBlock:^(NSArray *array) {
            
            NSLog(@"融云TOKEN获取成功");
            
            NSDictionary * dictData = (NSDictionary *)array;
            
            NSLog(@"^^^^%@",dictData);
            
            //融云TOKEN
            NSString * rToken = dictData[@"rongCloudToken"];
            
       
            //保存在本地
            [UserData saveRongCloudToken:rToken];
            
            //直接连接融云
            [[RCIMClient sharedRCIMClient] connectWithToken:rToken
                                                    success:^(NSString *userId) {
                                                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                                        
                                                        [self endActionLoading];
                                                        
                                                        MenuTabBarController *menuTabController = [[MenuTabBarController alloc] init];
                                                        menuTabController.selectedIndex = DEFAULT_TAB_INDEX;
                                                        
                                                        AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                                        
                                                        dispatch_sync(dispatch_get_main_queue(), ^{
                                                            appDelegate.window.rootViewController = menuTabController;
                                                        });
                                                        
                                                    } error:^(RCConnectErrorCode status) {
                                                        NSLog(@"登陆的错误码为:%ld", (long)status);
                                                    } tokenIncorrect:^{
                                                        NSLog(@"token错误");
                                                    }];
            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            NSLog(@"%@",error);
        }];

        
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
}

//注册
-(void)registerClick {
    NSLog(@"注册");
    PUSH_VC(RegisterViewController, YES, @{});
    
}

//忘记密码
-(void)forgetClick {
    NSLog(@"忘记密码");
}

-(void)threeIconClick:(UITapGestureRecognizer *)tap {
    NSInteger vTag = tap.view.tag;
    NSLog(@"%ld",(long)vTag);
}

-(void)bgClick {
    [self.view endEditing:YES];
}

@end
