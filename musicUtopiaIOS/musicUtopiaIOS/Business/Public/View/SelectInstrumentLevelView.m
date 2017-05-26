//
//  SelectInstrumentLevelView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SelectInstrumentLevelView.h"

@interface SelectInstrumentLevelView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView         * _maskView;
    UIView         * _selectInstrumentLevelView;
    NSMutableArray * _sexBtnArr;
    UIView         * _locationLoadingView;
    UIPickerView   * _pickView;
    MBProgressHUD  * _hud;
    NSMutableArray * _categoryArr;
    
    NSDictionary   * _instrumentLevelDict;
    NSInteger        _instrument;
    NSString       * _instrumentStr;
    NSInteger        _level;
}
@end

@implementation SelectInstrumentLevelView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        
        //初始化数据
        [self initVar];
        
        //创建遮罩
        [self createMaskView];
   
        //创建视图
        [self createView];

        //创建加载遮罩
        [self startLocationMask];
        
        //获取乐器与级别
        [self initData];
        
    }
    return self;
}

-(void)initVar {
    _instrumentStr = @"";
    _categoryArr   = [NSMutableArray array];
}

-(void)initData {
    
    [self startLocationLoading];

    _categoryArr = [LocalData getStandardMusicCategory];
    
    [self endLocationLoading];
    
    //设置默认选中
    NSDictionary * dictData =  [_categoryArr firstObject];
    _instrument    = [dictData[@"c_id"] integerValue];
    _instrumentStr = dictData[@"c_name"];
    _level         = 0;

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

//创建加载遮罩
-(void)startLocationMask {
    
    _locationLoadingView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0, 0, [_selectInstrumentLevelView width],[_selectInstrumentLevelView height]))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_radius(5)
        .L_AddView(_selectInstrumentLevelView);
    }];
    
}

-(void)createView {
    _selectInstrumentLevelView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[self height]/2 - 400/2,[self width] - CARD_MARGIN_LEFT*2,400))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_radius(5)
        .L_AddView(_maskView);
    }];
    
    //创建标题
    UILabel * titleLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,20,[_selectInstrumentLevelView width],20))
        .L_Font(18)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"选择乐器及级别")
        .L_AddView(_selectInstrumentLevelView);
    }];
    
    //选择视图容器
    UIView * selectBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[titleLabel bottom]+15,[_selectInstrumentLevelView width] - CARD_MARGIN_LEFT * 2,280))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_BgColor([UIColor whiteColor])
        .L_AddView(_selectInstrumentLevelView);
    }];
    
    //选择容器标题容器
    UIView * selectMenuTitleView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,[selectBox width],45))
        .L_raius_location(UIRectCornerTopLeft|UIRectCornerTopRight,5)
        .L_AddView(selectBox);
    }];
    
    //创建菜单
    NSArray * menuTitle = @[@"乐器",@"级别"];
    CGFloat menuWidth = ([selectMenuTitleView width]/menuTitle.count);
    for(int i = 0;i<menuTitle.count;i++){
        
        UIView * menuView = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_Frame(CGRectMake(i*menuWidth,0,menuWidth, [selectMenuTitleView height]))
            .L_AddView(selectMenuTitleView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,0,[menuView width],[menuView height]))
            .L_Font(TITLE_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Text(menuTitle[i])
            .L_AddView(menuView);
        }];
        
    }
    
    //创建选择容器
    UIView * pickBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[selectMenuTitleView height],[selectMenuTitleView width], [selectBox height] - [selectMenuTitleView height]))
        .L_raius_location(UIRectCornerBottomLeft|UIRectCornerBottomRight,5)
        .L_AddView(selectBox);
    }];
    
    //创建滚动容器
    _pickView  = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,[pickBox width],[pickBox height])];
    _pickView.delegate        = self;
    _pickView.dataSource      = self;
    _pickView.showsSelectionIndicator = YES;
    [pickBox addSubview:_pickView];
    
    //确定按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_selectInstrumentLevelView width]/2 - 120/2,[selectBox bottom]+15, 120, 35))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_Title(@"确定",UIControlStateNormal)
        .L_TargetAction(self,@selector(submitBtnClick),UIControlEventTouchUpInside)
        .L_radius(5)
        .L_AddView(_selectInstrumentLevelView);
    } buttonType:UIButtonTypeCustom];

}


#pragma mark - 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(component == 0){
        
        return _categoryArr.count;
        
    }else if(component == 1){
        
   
        return 11;
        
    }
    
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0){
        
        NSDictionary * dict = _categoryArr[row];
        return dict[@"c_name"];
        
    }else if(component == 1){
        
        if(row == 0){
            return @"全部级别";
        }else{
            return [NSString stringWithFormat:@"%ld 级",row];
        }

        
        
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(component == 0){
        
        NSDictionary * dict = _categoryArr[row];
        
        _instrument    = [dict[@"c_id"] integerValue];
        _instrumentStr = dict[@"c_name"];
        _level         = 0;
        [_pickView selectRow:0 inComponent:1 animated:YES];
    }else if(component == 1){
        _level = row;
    }
    
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


-(void)submitBtnClick {
    NSLog(@"%ld",(long)_instrument);
    NSLog(@"%@",_instrumentStr);
    NSLog(@"%ld",_level);
    
    NSDictionary * dictData = @{@"instrument":@(_instrument),@"instrumentStr":_instrumentStr,@"level":@(_level)};
    
    [self.delegate selectInstrumentLevel:dictData];
}

-(void)maskViewClick {
    [self.delegate closeSelectInstrumentLevel];
}


//获取地理信息请求遮罩
-(void)startLocationLoading {
    
    _hud = [[MBProgressHUD alloc] initWithView:_locationLoadingView];
    [_locationLoadingView addSubview:_hud];
    _hud.label.text = @"正在获取乐器级别信息...";
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
}

-(void)endLocationLoading {
    [_hud removeFromSuperview];
    [_locationLoadingView removeFromSuperview];
}

@end
