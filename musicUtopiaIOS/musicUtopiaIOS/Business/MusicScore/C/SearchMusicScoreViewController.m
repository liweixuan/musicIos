//
//  SearchMusicScoreViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SearchMusicScoreViewController.h"

@interface SearchMusicScoreViewController ()<UITextFieldDelegate>

@end

@implementation SearchMusicScoreViewController

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建顶部菜单容器
    UIView * topView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH,64))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.view);
    }];
    
    //搜索框
    UITextField * searchField = [UITextField TextFieldInitWith:^(UITextField *text) {
       text
        .L_Frame(CGRectMake(5,20 + (44/2 - 32/2),D_WIDTH-5*2 - 40,32))
        .L_PaddingLeft(10)
        .L_Placeholder(@"请输入曲谱名称")
        .L_ReturnKey(UIReturnKeySearch)
        .L_BgColor([UIColor whiteColor])
        .L_ClearButtonMode(UITextFieldViewModeWhileEditing)
        .L_Font(12)
        .L_radius_NO_masksToBounds(5)
        .L_borderWidth(1)
        .L_borderColor(HEX_COLOR(@"#eeeeee"))
        .L_AddView(topView);
    }];
    searchField.delegate = self;
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(D_WIDTH - 40,[searchField top],40,[searchField height]))
        .L_Title(@"取消",UIControlStateNormal)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_TargetAction(self,@selector(cancelBtnClick),UIControlEventTouchUpInside)
        .L_AddView(topView);
    } buttonType:UIButtonTypeCustom];
    
    
    
    
    
    
}

#pragma mark - 事件
-(void)cancelBtnClick {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
