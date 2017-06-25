//
//  OrganizationFilterView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrganizationFilterView.h"

@interface OrganizationFilterView()
{
    CGFloat _typeItemMaxY; //动态类型最大Y轴
    
    UIScrollView * _filterScrollView;  //滚动区域
}
@end

@implementation OrganizationFilterView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建内容视图
        [self createFilterView];
        
        
    }
    return self;
}

-(void)initVar {
    
}

-(void)createFilterView {
    
    //创建滚动主容器
    [self createScrollView];
    
    //创建底部按钮视图
    [self createBottomBtnView];
    
}

-(void)createScrollView {
    _filterScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,20,[self width],[self height] - 49 - 50 - 20))
        .L_bounces(YES)
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_contentSize(CGSizeMake([self width],0))
        .L_AddView(self);
    }];
    
}

-(void)createBottomBtnView {
    
    UIView * btnView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[_filterScrollView bottom],[self width],50))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(-3,-3))
        .L_shadowOpacity(0.2)
        .L_AddView(self);
    }];
    
    //重置按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,50/2-35/2,[btnView width]/2 - CONTENT_PADDING_LEFT * 2,35))
        .L_Title(@"重置",UIControlStateNormal)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_TargetAction(self,@selector(filterReset),UIControlEventTouchUpInside)
        .L_Radius(5)
        .L_borderWidth(1)
        .L_borderColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(btnView);
        
        
    } buttonType:UIButtonTypeCustom];
    
    //提交按钮
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake([btnView width]/2 + CONTENT_PADDING_LEFT,50/2-35/2,[btnView width]/2 - CONTENT_PADDING_LEFT * 2,35))
        .L_Title(@"搜索",UIControlStateNormal)
        .L_TargetAction(self,@selector(filterSubmit),UIControlEventTouchUpInside)
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Radius(5)
        .L_AddView(btnView);
        
        
    } buttonType:UIButtonTypeCustom];
    
}


-(void)filterReset {
    
}

-(void)filterSubmit {
    
}

@end
