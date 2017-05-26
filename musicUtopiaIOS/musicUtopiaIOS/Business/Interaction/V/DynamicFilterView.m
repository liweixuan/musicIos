//
//  DynamicFilterView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DynamicFilterView.h"
#import "MusciCategorySelectView.h"

@interface DynamicFilterView()
{
    CGFloat _typeItemMaxY; //动态类型最大Y轴
    
    UIScrollView * _filterScrollView;  //滚动区域
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
        .L_ImageName(IMAGE_DEFAULT)
        .L_AddView(_filterScrollView);
        
    }];
    
    //标题内容
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([musciTypeIcon right] + CONTENT_MARGIN_LEFT,[musciTypeIcon top],200,BIG_ICON_SIZE))
        .L_Text(@"乐器类型")
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(_filterScrollView);
        
    }];
    
    //乐器类别数据
    NSArray * categoryArr = [LocalData getMusicCategory];
    
    MusciCategorySelectView * musicCategorySelectView = [[MusciCategorySelectView alloc] init];
    NSDictionary * musicCategoryDict = [musicCategorySelectView createViewBoxWidth:[self width] - CONTENT_PADDING_LEFT * 2  CategoryArr:categoryArr];
    
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
        .L_ImageName(ICON_DEFAULT)
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
              @{@"icon":IMAGE_DEFAULT,@"text":@"文字"},
              @{@"icon":IMAGE_DEFAULT,@"text":@"图片"},
              @{@"icon":IMAGE_DEFAULT,@"text":@"音频"},
              @{@"icon":IMAGE_DEFAULT,@"text":@"视频"}
    ];
    
    //y轴
    CGFloat typeItemY = [typeIcon bottom]+15;
    
    
    for(int i =0;i<4;i++){
        
        //数据
        NSDictionary * dictData = typeArr[i];
 
        //创建选项
        UIView * typeItemView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,typeItemY,[self width] - CONTENT_PADDING_LEFT * 2,42))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(_filterScrollView);
        }];
        
        //图标
        UIImageView * iconImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,42/2-SMALL_ICON_SIZE/2,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
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
        [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake([typeItemView width] - CONTENT_PADDING_LEFT * 2 - CONTENT_PADDING_LEFT ,45/2-MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_BgColor([UIColor grayColor])
            .L_BtnImageName(ICON_DEFAULT,UIControlStateNormal)
            .L_AddView(typeItemView);
            
        } buttonType:UIButtonTypeCustom];
        
        typeItemY = [typeItemView bottom] + 6;
        
    }
    
    _typeItemMaxY = typeItemY;
    
}

@end
