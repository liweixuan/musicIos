#import "RegisterViewController.h"
#import "RegisterPasswordViewController.h"

@interface RegisterViewController ()
{
    UITextField * _phoneInput;
    UITextField * _codeInput;
    NSTimer     * _timer;
    UILabel     * _codeLabel;
    NSInteger     _nowTime;
    BOOL          _isSend;         //是否在发送状态
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册/绑定手机";
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"下一步",registerNext)
    
    [self initVar];
    
    //创建注册视图
    [self createView];
}

-(void)initVar {
    _nowTime = 60;
    _isSend  = NO;
}

//创建注册视图
-(void)createView {
    
    //创建输入容器框
    UIView * inputBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT *2,130))
        .L_AddView(self.view);
    }];

    UIImageView * phoneIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"r_shouji");
    }];
    
    //输入框
    _phoneInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,0,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"手机号码")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(phoneIcon)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];
    
    UIImageView * codeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"r_yanzhengma");
    }];
    
    //右侧发短信按钮视图
    UIView * rightView =[UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,100,TEXTFIELD_HEIGHT))
        .L_raius_location(UIRectCornerTopRight|UIRectCornerBottomRight,20);
    }];
    
    //左侧竖线图
    UIImageView * leftLine = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(0,TEXTFIELD_HEIGHT/2 - 30/2,2,30))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"r_fengexian")
        .L_AddView(rightView);
    }];
    
    //左侧按钮文字
    _codeLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([leftLine right]-2,0,90,TEXTFIELD_HEIGHT))
        .L_Text(@"获取短信")
        .L_isEvent(YES)
        .L_Font(CONTENT_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Click(self,@selector(sendCode))
        .L_AddView(rightView);
    }];
    
    //输入框
    _codeInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,[_phoneInput bottom]+10,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"短信验证码")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(codeIcon)
        .L_RightView(rightView)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];

    
}

#pragma mark - 事件
-(void)sendCode {

    if(!_isSend){

        //发送短信验证码
        [self startActionLoading:@"正在发送短信..."];
        [NetWorkTools POST:API_SMS_REGISTER_CODE params:@{@"phone":_phoneInput.text} successBlock:^(NSArray *array) {
            
            [self endActionLoading];
            
            SHOW_HINT(@"短信已发送");
            
            _isSend = YES;

            _codeLabel.text = [NSString stringWithFormat:@"(%ld)后重发",(long)_nowTime];
            _codeLabel.textColor = HEX_COLOR(@"#CCCCCC");
            
            //启动倒计时
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendCodeAction) userInfo:nil repeats:YES];

            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(error);
        }];
        
    }
    
}

-(void)sendCodeAction {
    
    _nowTime--;
    
    if(_nowTime > 0){
        
        _codeLabel.text = [NSString stringWithFormat:@"(%ld)后重发",(long)_nowTime];
        
    }else{
        
        _codeLabel.text = @"获取短信";
        _codeLabel.textColor = HEX_COLOR(APP_MAIN_COLOR);
        _isSend  = NO;
        _nowTime = 60;
        
        [_timer invalidate];
        
    }
}

-(void)registerNext {

    
    if([_codeInput.text isEqualToString:@""]){
        SHOW_HINT(@"验证码不能为空");
        return;
    }
    
    //验证短信码是否正确
    [self startActionLoading:@"验证中..."];
    [NetWorkTools POST:API_VERIFY_PHONE_CODE params:@{@"phone":_phoneInput.text,@"code":_codeInput.text} successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        PUSH_VC(RegisterPasswordViewController,YES,@{@"phone":_phoneInput.text});
        
    
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
    
}
@end
