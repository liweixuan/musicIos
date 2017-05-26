//
//  SelectSexView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SelectSexView.h"

@interface SelectSexView()
{
    UIView         * _maskView;
    UIView         * _selectSexView;
    NSMutableArray * _sexBtnArr;
    
    NSDictionary   * _sexDict;
    NSInteger        _selectedSex;
    NSString       * _selectedSexStr;
}
@end

@implementation SelectSexView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        
        //初始化数据
        [self initVar];
    
        //创建遮罩
        [self createMaskView];
        
        //创建视图
        [self createView];
    
    }
    return self;
}

-(void)initVar {
    
    _selectedSex    = 0;
    _selectedSexStr = @"男";
    _sexBtnArr = [NSMutableArray array];
}

-(void)createMaskView {
    
    _maskView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,[self width],[self height]))
        .L_Click(self,@selector(maskViewClick))
        .L_AddView(self);
    }];
    
    _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    
}

-(void)createView {
    
    _selectSexView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[self height]/2 - 200/2,[self width] - CARD_MARGIN_LEFT*2,180))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_radius(5)
        .L_AddView(_maskView);
    }];
    
    //创建标题
    UILabel * titleLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,20,[_selectSexView width],20))
        .L_Font(18)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"选择性别")
        .L_AddView(_selectSexView);
    }];
    
    //选择视图容器
    UIView * selectBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[titleLabel bottom]+15,[_selectSexView width] - CARD_MARGIN_LEFT * 2,60))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_BgColor([UIColor whiteColor])
        .L_AddView(_selectSexView);
    }];
    
    //性别选择区域，男
    UIView * manBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,[selectBox width]/2,[selectBox height]))
        .L_Click(self,@selector(sexBoxClick:))
        .L_tag(0)
        .L_AddView(selectBox);
    }];
    
    
    UIButton * manBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([manBox width]/2 - 24/2 - 5,[manBox height]/2 - 24/2,24,24))
        .L_BtnImageName(@"sex_weixuanzhong",UIControlStateNormal)
        .L_BtnImageName(@"sex_xuanzhong",UIControlStateSelected)
        .L_TargetAction(self,@selector(sexBtnClick:),UIControlEventTouchUpInside)
        .L_tag(0)
        .L_AddView(manBox);
    } buttonType:UIButtonTypeCustom];
    manBtn.selected = YES;
    
    [_sexBtnArr addObject:manBtn];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([manBtn right]+5, [manBox height]/2 - 20/2,20,20))
        .L_Text(@"男")
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_AddView(manBox);
    }];
    
    //性别选择区域，女
    UIView * womanBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake([selectBox width]/2,0,[selectBox width]/2,[selectBox height]))
        .L_Click(self,@selector(sexBoxClick:))
        .L_tag(1)
        .L_AddView(selectBox);
    }];
    
    UIButton * womanBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([womanBox width]/2 - 24/2 - 5,[womanBox height]/2 - 24/2,24,24))
        .L_BtnImageName(@"sex_weixuanzhong",UIControlStateNormal)
        .L_BtnImageName(@"sex_xuanzhong",UIControlStateSelected)
        .L_TargetAction(self,@selector(sexBtnClick:),UIControlEventTouchUpInside)
        .L_tag(1)
        .L_AddView(womanBox);
    } buttonType:UIButtonTypeCustom];
    
    [_sexBtnArr addObject:womanBtn];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([womanBtn right]+5, [womanBox height]/2 - 20/2,20,20))
        .L_Text(@"女")
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_AddView(womanBox);
    }];
    
    //确定按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_selectSexView width]/2 - 120/2,[selectBox bottom]+15, 120, 35))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_Title(@"确定",UIControlStateNormal)
        .L_TargetAction(self,@selector(submitBtnClick),UIControlEventTouchUpInside)
        .L_radius(5)
        .L_AddView(_selectSexView);
    } buttonType:UIButtonTypeCustom];
    
}

-(void)sexBtnClick:(UIButton *)sender {
    NSInteger tagv = sender.tag;
    
    for(int i =0;i<_sexBtnArr.count;i++){
        UIButton * btn = _sexBtnArr[i];
        btn.selected = NO;
    }
    
    UIButton * nowBtn = _sexBtnArr[tagv];
    nowBtn.selected   = YES;
    
    _selectedSex    = tagv;
    _selectedSexStr = tagv == 0 ? @"男" : @"女";
}

-(void)sexBoxClick:(UITapGestureRecognizer *)tap {
    NSInteger tagv = tap.view.tag;
    
    for(int i =0;i<_sexBtnArr.count;i++){
        UIButton * btn = _sexBtnArr[i];
        btn.selected = NO;
    }

    UIButton * nowBtn = _sexBtnArr[tagv];
    nowBtn.selected   = YES;
    
    _selectedSex    = tagv;
    _selectedSexStr = tagv == 0 ? @"男" : @"女";
  
}

-(void)maskViewClick {
    [self.delegate closeSelectSex];
}

-(void)submitBtnClick {
    
    NSDictionary * dictData = @{@"sex":@(_selectedSex),@"sexStr":_selectedSexStr};
    [self.delegate selectSex:dictData];
}
@end
