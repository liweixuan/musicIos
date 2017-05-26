#import "SelectAddressView.h"

@interface SelectAddressView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView        * _maskView;
    UIView        * _selectAddressView;
    UIPickerView  * _pickView;
    NSArray       * _locationData;
    UIView        * _locationLoadingView;
    MBProgressHUD * _hud;
    
    NSMutableArray  * _pArr;  //省份
    NSMutableArray  * _cArr;  //城市
    NSMutableArray  * _dArr;  //区域
    
    NSInteger         _pid;
    NSInteger         _cid;
    NSInteger         _did;
    
    NSString        * _pName;
    NSString        * _cName;
    NSString        * _dName;
    
    
}
@end

@implementation SelectAddressView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        NSLog(@"66666666");
        
        //初始化数据
        [self initVar];
        
        
        //创建遮罩
        [self createMaskView];
 
        //创建视图
        [self createView];
        
        
        //创建加载遮罩
        [self startLocationMask];
        

        //获取省市区
        [self initData];

        
        
    }
    return self;
}

-(void)initVar {
    _locationData = [NSArray array];
    
    _pArr = [NSMutableArray array];
    _cArr = [NSMutableArray array];
    _dArr = [NSMutableArray array];
}

//创建加载遮罩
-(void)startLocationMask {
 
    _locationLoadingView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0, 0, [_selectAddressView width],[_selectAddressView height]))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_radius(5)
        .L_AddView(_selectAddressView);
    }];

}

-(void)initData {
   
    [self startLocationLoading];
    
    //获取省市区信息
    [LocalData getLocationInfoResult:^(BOOL results, NSArray *locationArr) {
        
        [self endLocationLoading];
        
        if(!results){
            
            //省市区信息获取失败
            SHOW_HINT(@"省市区信息获取失败");
            return;
            
        }

        //获取地理位置信息
        _locationData = locationArr;

        //获取所有省份信息
        [self formatLocation];

        //更新数据源
        [_pickView reloadAllComponents];
     
    }];
    
    
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
    
    _selectAddressView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[self height]/2 - 400/2,[self width] - CARD_MARGIN_LEFT*2,400))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_radius(5)
        .L_AddView(_maskView);
    }];
    
    //创建标题
    UILabel * titleLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,20,[_selectAddressView width],20))
        .L_Font(18)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"选择位置")
        .L_AddView(_selectAddressView);
    }];
    
    //选择视图容器
    UIView * selectBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[titleLabel bottom]+15,[_selectAddressView width] - CARD_MARGIN_LEFT * 2,280))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_BgColor([UIColor whiteColor])
        .L_AddView(_selectAddressView);
    }];
    
    //closeSelectLocation
    
    //选择容器标题容器
    UIView * selectMenuTitleView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,[selectBox width],45))
        .L_raius_location(UIRectCornerTopLeft|UIRectCornerTopRight,5)
        .L_AddView(selectBox);
    }];
    
    //创建菜单
    NSArray * menuTitle = @[@"省",@"市",@"区\\县"];
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
    
    //下边线
    [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0, [selectMenuTitleView bottom] - 1, [selectMenuTitleView width], 1))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(selectMenuTitleView);
    }];
    
    
    //确定按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_selectAddressView width]/2 - 120/2,[selectBox bottom]+15, 120, 35))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_Title(@"确定",UIControlStateNormal)
        .L_TargetAction(self,@selector(submitBtnClick),UIControlEventTouchUpInside)
        .L_radius(5)
        .L_AddView(_selectAddressView);
    } buttonType:UIButtonTypeCustom];
}

//选择地址确定
-(void)submitBtnClick {
 
    NSLog(@"省份ID:%ld",(long)_pid);
    NSLog(@"城市ID:%ld",(long)_cid);
    NSLog(@"区域ID:%ld",(long)_did);
    
    NSLog(@"省份:%@",_pName);
    NSLog(@"城市:%@",_cName);
    NSLog(@"区域:%@",_dName);
    
    NSDictionary * locationData = @{
                                @"pid":@(_pid),
                                @"cid":@(_cid),
                                @"did":@(_did),
                                @"pName":_pName,
                                @"cName":_cName,
                                @"dName":_dName};

    
    [self.delegate selectLocation:locationData];

}

#pragma mark - 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(component == 0){
        
        return _pArr.count;
        
    }else if(component == 1){
        
        return _cArr.count;
        
    }else if(component == 2){
        
        return _dArr.count;
        
    }
    
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0){
        
        NSDictionary * dict = _pArr[row];
        return dict[@"l_name"];
        
    }else if(component == 1){
        
        NSDictionary * dict = _cArr[row];
        return dict[@"l_name"];
        
    }else if(component == 2){
        
        NSDictionary * dict = _dArr[row];
        return dict[@"l_name"];
        
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if(component == 0){
        
        //获取选择的省份ID
        NSDictionary * pDict = _pArr[row];
        _pid   = [pDict[@"l_id"] integerValue];
        _pName = pDict[@"l_name"];
        
        //获取城市数据
        _cArr = [self getloctaion:_pid];
        
        //获取第一个城市对应的区域
        NSDictionary * cDict = _cArr[0];
        _cid   = [cDict[@"l_id"] integerValue];
        _cName = cDict[@"l_name"];
        _dArr  = [self getloctaion:_cid];
        
        //获取第一个区域
        if(_dArr.count>0){
            NSDictionary * dDict = _dArr[0];
            _did   = [dDict[@"l_id"] integerValue];
            _dName = dDict[@"l_name"];
        }else{
            _did   = 0;
            _dName = @"";

        }
        
        [_pickView selectRow:0 inComponent:1 animated:YES];
        [_pickView selectRow:0 inComponent:2 animated:YES];
        
        [_pickView reloadComponent:1];
        [_pickView reloadComponent:2];
        
    }else if(component == 1){
        
        //获取城市ID
        NSDictionary * cDict = _cArr[row];
        _cid = [cDict[@"l_id"] integerValue];
        _cName = cDict[@"l_name"];
        
        //获取区域数据
        _dArr = [self getloctaion:_cid];
        
        //获取区域ID
        if(_dArr.count > 0){
            NSDictionary * dDict = _dArr[0];
            _did   = [dDict[@"l_id"] integerValue];
            _dName = dDict[@"l_name"];
        }else{
            _did = 0;
            _dName = @"";
        }
        

        
        [_pickView reloadComponent:2];
        
        [_pickView selectRow:0 inComponent:2 animated:YES];

    }else if(component == 2){
        
        //获取区域ID
        NSDictionary * dDict = _dArr[row];
        _did   = [dDict[@"l_id"] integerValue];
        _dName = dDict[@"l_name"];
        
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



#pragma mark - 私有方法
//格式化省市区数据
-(void)formatLocation {

    for(NSDictionary * dict in _locationData){
        
        if([dict[@"l_type"] integerValue] == 0){
            [_pArr addObject:dict];
        }
    }
    
    //获取第一个省份的城市
    NSDictionary * pDict = _pArr[0];
    _pid   = [pDict[@"l_id"] integerValue];
    _pName = pDict[@"l_name"];
    _cArr  = [self getloctaion:_pid];

    //获取第一个城市的区域
    NSDictionary * cDict = _cArr[0];
    _cid   = [cDict[@"l_id"] integerValue];
    _cName = cDict[@"l_name"];
    _dArr  = [self getloctaion:_cid];
    
    //获取区域ID
    NSDictionary * dDict = _dArr[0];
    _did   = [dDict[@"l_id"] integerValue];
    _dName = dDict[@"l_name"];
    

}

-(void)maskViewClick {
    [self.delegate closeSelectLocation];
}

//获取位置信息
-(NSMutableArray *)getloctaion:(NSInteger)fid {
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    for(int i=0;i<_locationData.count;i++){
        
        NSDictionary * dictData = _locationData[i];
        
        if([dictData[@"l_fid"] integerValue] == fid){
           [tempArr addObject:dictData];
        }
        
    }
    
    
    [tempArr insertObject:@{@"l_id":@(0),@"l_name":@"不限"} atIndex:0];
    
    return tempArr;
    
}


//获取地理信息请求遮罩
-(void)startLocationLoading {
    
    _hud = [[MBProgressHUD alloc] initWithView:_locationLoadingView];
    [_locationLoadingView addSubview:_hud];
    _hud.label.text = @"正在获取位置信息...";
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
}

-(void)endLocationLoading {
    [_hud removeFromSuperview];
    [_locationLoadingView removeFromSuperview];
}


@end
