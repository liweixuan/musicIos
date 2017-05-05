//
//  RegisterSubmitViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RegisterSubmitViewController.h"
#import "MusciCategorySelectView.h"

@interface RegisterSubmitViewController ()
{
    UITextField * _nicknameInput;
}
@end

@implementation RegisterSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"立即注册",registerSubmit)
    
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
    _nicknameInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,0,[inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"用户昵称")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_PaddingLeft(15)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(inputBox);
    }];
    
    //主擅长乐器标题
    UILabel * beGoodTitle = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,[inputBox bottom],D_WIDTH,SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_Text(@"主擅长乐器")
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
    //乐器类别数据
    NSArray * categoryArr = @[
                              @{@"icon":ICON_DEFAULT,@"text":@"民谣吉他"},
                              @{@"icon":ICON_DEFAULT,@"text":@"古典吉他"},
                              @{@"icon":ICON_DEFAULT,@"text":@"电声吉他"},
                              @{@"icon":ICON_DEFAULT,@"text":@"钢琴"},
                              @{@"icon":ICON_DEFAULT,@"text":@"小提琴"},
                              @{@"icon":ICON_DEFAULT,@"text":@"二胡"},
                              @{@"icon":ICON_DEFAULT,@"text":@"大提琴"},
                              @{@"icon":ICON_DEFAULT,@"text":@"小号"},
                              @{@"icon":ICON_DEFAULT,@"text":@"电声贝斯"},
                              @{@"icon":ICON_DEFAULT,@"text":@"长笛"},
                              @{@"icon":ICON_DEFAULT,@"text":@"长笛"},
                              @{@"icon":ICON_DEFAULT,@"text":@"长笛"},
                              @{@"icon":ICON_DEFAULT,@"text":@"长笛"},
                              ];
    
    NSDictionary * musicCategoryDict = [MusciCategorySelectView createViewBoxWidth:D_WIDTH - CARD_MARGIN_LEFT * 2  CategoryArr:categoryArr];
    
    
    //主擅长乐器容器
    UIView * beGoodBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[beGoodTitle bottom]+20,D_WIDTH - CARD_MARGIN_LEFT * 2,[musicCategoryDict[@"height"] floatValue]))
        .L_AddView(self.view);
    }];
    
    [beGoodBox addSubview:musicCategoryDict[@"view"]];
    
}

#pragma mark - 事件
-(void)registerSubmit {
    
}


@end
