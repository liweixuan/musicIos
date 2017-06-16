//
//  MusicCategoryPopView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicCategoryPopView.h"
#import "MusciCategorySelectView.h"

@interface MusicCategoryPopView()<MusciCategorySelectViewDelegate>
{
    UIView * _maskView;
    UIView * _categroyBoxView;
    
    NSString * _categoryName;
    NSInteger  _categoryId;
}
@end

@implementation MusicCategoryPopView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //创建遮罩视图
        _maskView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(0,0,[self width],[self height]))
            .L_BgColor([UIColor blackColor])
            .L_Click(self,@selector(maskViewClick))
            .L_Alpha(0.4)
            .L_AddView(self);
        }];
        
        //创建放置分类总容器
        _categroyBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[self height]/2 - 400/2,[self width] - CARD_MARGIN_LEFT*2,0))
            .L_BgColor(HEX_COLOR(VC_BG))
            .L_Alpha(0.0)
            .L_radius(5)
            .L_AddView(self);
        }];
        
        
        
        //分类标题
        UILabel * titleLabel = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,20,[_categroyBoxView width],30))
            .L_Font(20)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentCenter)
            .L_Text(@"选择分类")
            .L_AddView(_categroyBoxView);
        }];

        
        //乐器类别数据
        NSArray * categoryArr = [LocalData getMusicCategory];
        
        //创建乐器类别容器
        MusciCategorySelectView * musciCategorySelectView = [[MusciCategorySelectView alloc] init];
        musciCategorySelectView.delegate = self;
        NSDictionary * musicCategoryDict = [musciCategorySelectView createViewBoxWidth:[_categroyBoxView width] - 20 *2 CategoryArr:categoryArr];
        
        
        //分类容器
        UIView * categoryView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(20, [titleLabel bottom]+CONTENT_PADDING_TOP, [_categroyBoxView width] - 20 *2 ,[musicCategoryDict[@"height"] floatValue]))
            .L_AddView(_categroyBoxView);
        }];

        [categoryView addSubview:musicCategoryDict[@"view"]];
        
        //创建底部操作视图
        UIView * actionView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(0,[categoryView bottom]+20,[_categroyBoxView width],50))
            .L_BgColor([UIColor whiteColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.1)
            .L_ShadowColor([UIColor grayColor])
            .L_AddView(_categroyBoxView);
        }];
        
        
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake([actionView width]/2 - 120/2,[actionView height]/2 - 30/2,120,30))
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_Title(@"确定",UIControlStateNormal)
            .L_TargetAction(self,@selector(submitBtnClick),UIControlEventTouchUpInside)
            .L_radius(5)
            .L_AddView(actionView);
        } buttonType:UIButtonTypeCustom];

        [_categroyBoxView setHeight:[actionView bottom]];
        [_categroyBoxView setY:[self height]/2 - [_categroyBoxView height]/2];
        
        [UIView animateWithDuration:0.2 animations:^{
            _categroyBoxView.alpha = 1;
        }];
  
        
    }
    return self;
}

-(void)submitBtnClick {
    
    [self.delegate categorySelected:_categoryName Cid:_categoryId];
    [self removeFromSuperview];
    
}

-(void)maskViewClick {
    [self removeFromSuperview];

}

#pragma mark - 代理
-(void)categoryClick:(NSString *)c_name Cid:(NSInteger)c_id {
    _categoryName = c_name;
    _categoryId   = c_id;
}
@end
