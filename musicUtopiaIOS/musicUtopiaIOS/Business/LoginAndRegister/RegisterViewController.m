//
//  RegisterViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterSubmitViewController.h"


@interface RegisterViewController ()
{
    UITextField * _phoneInput;
    UITextField * _codeInput;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册/绑定手机";
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"下一步",registerNext)
    
    //创建注册视图
    [self createView];
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
        .L_ImageName(ICON_DEFAULT);
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
        .L_ImageName(ICON_DEFAULT);
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
        .L_Frame(CGRectMake(0,0,14,TEXTFIELD_HEIGHT))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"test2.jpg")
        .L_AddView(rightView);
    }];
    
    //左侧按钮文字
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([leftLine right]-5,0,90,TEXTFIELD_HEIGHT))
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
    
}

-(void)registerNext {
    
    PUSH_VC(RegisterSubmitViewController,YES,@{});
    
}
@end
