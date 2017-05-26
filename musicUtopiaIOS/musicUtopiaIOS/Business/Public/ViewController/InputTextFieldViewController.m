//
//  InputTextFieldViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "InputTextFieldViewController.h"

@interface InputTextFieldViewController ()
{
    UITextField * _valueInput;
}
@end

@implementation InputTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.VCTitle;
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"保存",saveSubmit)
    
    //创建视图
    [self createView];
}

//创建视图
-(void)createView {
    
    //创建输入容器框
    UIView * inputBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT *2,80))
        .L_AddView(self.view);
    }];
    
    //昵称输入框
    _valueInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,0,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder([NSString stringWithFormat:@"请输入%@",self.VCTitle])
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_PaddingLeft(15)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];
    
    [_valueInput becomeFirstResponder];
    
}

-(void)saveSubmit {
    
    
    
    NSString * inputValue = _valueInput.text;
    
    if([inputValue isEqualToString:@""]){
        return;
    }
    
    [self.view endEditing:YES];
    
    
    //发送数据通知信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INPUT_RESULT_VALUE" object:self userInfo:@{@"inputValue":inputValue,@"inputTag":@(self.inputTag)}];
    [self.navigationController popViewControllerAnimated:YES];
    
 
}

@end
