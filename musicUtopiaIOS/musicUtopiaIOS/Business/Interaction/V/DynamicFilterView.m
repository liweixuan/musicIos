//
//  DynamicFilterView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DynamicFilterView.h"
#import "MusciCategorySelectView.h"

@interface DynamicFilterView()<MusciCategorySelectViewDelegate>
{
    CGFloat _typeItemMaxY; //动态类型最大Y轴
    
    UIScrollView * _filterScrollView;  //滚动区域
    
    NSMutableArray * _typeBtnArr;
    
    NSMutableDictionary * _dynamicFilterParams; //筛选条件
    
    MusciCategorySelectView * _musicCategorySelectView;
}
@end

@implementation DynamicFilterView

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
    _typeBtnArr          = [NSMutableArray array];
    _dynamicFilterParams = [NSMutableDictionary dictionary];
}


-(void)createFilterView {
    
    //创建滚动主容器
    [self createScrollView];
    
    //创建底部按钮视图
    [self createBottomBtnView];
    
    //创建动态类型选择
    [self createDynamicTypeSelectView];
    
    //创建乐器类型选择
    [self createMusicType];
    
    
    
}

-(void)createScrollView{
    
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

-(void)createBottomBtnView{
    
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

-(void)createMusicType{
    
    //标题图标
    UIImageView * musciTypeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,_typeItemMaxY + 20,BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(@"yueqileixing")
        .L_AddView(_filterScrollView);
        
    }];
    
    //标题内容
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([musciTypeIcon right] + CONTENT_MARGIN_LEFT,[musciTypeIcon top],200,BIG_ICON_SIZE))
        .L_Text(@"动态类型")
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_filterScrollView);
        
    }];
    
    //乐器类别数据
    NSArray * categoryArr = [LocalData getMusicCategory];
    
    _musicCategorySelectView = [[MusciCategorySelectView alloc] init];
    _musicCategorySelectView.delegate = self;
    NSDictionary * musicCategoryDict = [_musicCategorySelectView createViewBoxWidth:[self width] - CONTENT_PADDING_LEFT * 2  CategoryArr:categoryArr];
    
    //创建乐器选择视图
    UIView * cView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_PADDING_LEFT,[musciTypeIcon bottom]+CONTENT_MARGIN_TOP,[self width] - CONTENT_PADDING_LEFT * 2,[musicCategoryDict[@"height"] floatValue])];
    [cView addSubview:musicCategoryDict[@"view"]];

    CGFloat dh = 0.0;
    if(IS_IPHONE_5){
        dh = 30;
    }else if(IS_IPHONE_6){
        dh = 90;
    }else if(IS_IPHONE_6_PLUS){
        dh = 130;
    }
    
    [_filterScrollView setContentSize:CGSizeMake([self width],[cView bottom] + dh)];
    [_filterScrollView addSubview:cView];

    
    
}

-(void)createDynamicTypeSelectView {
    
    //标题图标
    UIImageView * typeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,0,BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(@"dongtai")
        .L_AddView(_filterScrollView);
        
    }];
    
    //标题内容
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([typeIcon right] + CONTENT_MARGIN_LEFT,[typeIcon top],200,BIG_ICON_SIZE))
        .L_Text(@"动态类型")
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_filterScrollView);
    
    }];
    
    //类型项
    NSArray * typeArr = @[
              @{@"icon":@"shaixuanwenzi",@"text":@"文字"},
              @{@"icon":@"shaixuantupian",@"text":@"图片"},
              @{@"icon":@"shaixuanshipin",@"text":@"视频"}
    ];
    
    //y轴
    CGFloat typeItemY = [typeIcon bottom]+15;
    
    
    for(int i =0;i<3;i++){
        
        //数据
        NSDictionary * dictData = typeArr[i];
 
        //创建选项
        UIView * typeItemView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,typeItemY,[self width] - CONTENT_PADDING_LEFT * 2,42))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_tag(i)
            .L_Click(self,@selector(dynamicTypeClick:))
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(_filterScrollView);
        }];
        
        //图标
        UIImageView * iconImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,42/2-MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(dictData[@"icon"])
            .L_AddView(typeItemView);
        }];
        
        //标题内容
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([iconImageView right] + CONTENT_MARGIN_LEFT,0,100,42))
            .L_Text(dictData[@"text"])
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(typeItemView);
            
        }];
        
        //默认未选中图标
        UIButton * typeBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake([typeItemView width] - CONTENT_PADDING_LEFT * 2 - CONTENT_PADDING_LEFT ,45/2-MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_BtnImageName(@"weixuanzhong",UIControlStateNormal)
            .L_BtnImageName(@"xuanzhong",UIControlStateSelected)
            .L_AddView(typeItemView);
            
        } buttonType:UIButtonTypeCustom];
        
        [_typeBtnArr addObject:typeBtn];
        
        typeItemY = [typeItemView bottom] + 6;
        
    }
    
    _typeItemMaxY = typeItemY;
    
}

//选择类型
-(void)dynamicTypeClick:(UITapGestureRecognizer *)tap {
    NSInteger tagValue = tap.view.tag;
    
    for(int i = 0;i<_typeBtnArr.count;i++){
        
        UIButton * tempBtn = _typeBtnArr[i];
        if(tagValue == i){
            tempBtn.selected = YES;
            
            [_dynamicFilterParams setObject:@(i) forKey:@"d_type"];
            
        }else{
            tempBtn.selected = NO;
        }
    }

}

//开始搜索
-(void)filterSubmit {
    NSLog(@"%@",_dynamicFilterParams);
    
    if([_dynamicFilterParams allKeys].count<=0){
        SHOW_HINT(@"您未选择任何条件");
    }

    
    [self.delegate dynamicFilterResult:_dynamicFilterParams];
 
    //重置条件
    [self filterReset];
    
    
}

//条件重置
-(void)filterReset {
    
    [_dynamicFilterParams removeAllObjects];
    
    for(int i = 0;i<_typeBtnArr.count;i++){
        UIButton * tempBtn = _typeBtnArr[i];
        tempBtn.selected = NO;
    }
    
    [_musicCategorySelectView resetCategorySelectView];
    
}

//选择乐器类别
-(void)categoryClick:(NSString *)c_name Cid:(NSInteger)c_id {
    
    [_dynamicFilterParams setObject:@(c_id) forKey:@"d_cid"];
 
}
@end
