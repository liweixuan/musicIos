#import "MusciCategorySelectView.h"

@implementation MusciCategorySelectView

+(NSDictionary *)createViewBoxWidth:(CGFloat)boxWidth CategoryArr:(NSArray *)cArr{
    

    //创建视图
    UIView * boxView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,boxWidth,200));
    }];

    //循环创建乐器类别
    for(int i =0;i<cArr.count;i++){
        
        NSDictionary * dictData = cArr[i];
   
        //宽度计算
        CGFloat cItemWidth = (boxWidth - 30)/4;

        //当前列
        CGFloat col = i % 4;
        
        
        CGFloat marginRight = 0.0;
        
        if(col > 0){
            marginRight = 10;
        }

        //上间距
        CGFloat marginTop = 0.0;
        
        //y位置
        CGFloat row = i / 4;
        
        if(row > 0){
            marginTop = 10;
        }
        
        //x轴
        CGFloat cItemX  = col * (cItemWidth + marginRight);
        
        //y轴
        CGFloat cItemY  = row * (cItemWidth + marginTop);

        //创建视图
        UIView * cItemView = [UIView ViewInitWith:^(UIView *view) {
           
            view
            .L_Frame(CGRectMake(cItemX,cItemY,cItemWidth, cItemWidth))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(boxView);
            
        }];

        
        //创建图标
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(cItemWidth/2 - BIG_ICON_SIZE/2,cItemWidth/2-BIG_ICON_SIZE/2 - 5,BIG_ICON_SIZE,BIG_ICON_SIZE))
            .L_ImageName(dictData[@"icon"])
            .L_AddView(cItemView);
        }];
        
        //创建文字
        UILabel * textLabel = [UILabel LabelinitWith:^(UILabel *la) {
           
            la
            .L_Frame(CGRectMake(0,[icon bottom]+5,cItemWidth,20))
            .L_Text(dictData[@"text"])
            .L_Font(12)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(cItemView);
            
        }];
        
        
        //创建选择图标
        UIButton * selectBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake([cItemView width] - MIDDLE_ICON_SIZE - 5,5,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_BgColor([UIColor grayColor])
            .L_BtnImageName(ICON_DEFAULT,UIControlStateNormal)
            .L_AddView(cItemView);
            
        } buttonType:UIButtonTypeCustom];
        
        if(i == cArr.count){
            
            [boxView setHeight:[cItemView bottom]];
       
        }
        
        
    }

    
    return @{ @"view" : boxView , @"height" : @([boxView height]) };
    
}


@end
