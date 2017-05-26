#import "MusciCategorySelectView.h"
#import "UIView+AddClickedEvent.h"

@interface MusciCategorySelectView()
{
    NSMutableArray  * _categoryBtnArr;
}
@end

@implementation MusciCategorySelectView

-(NSDictionary *)createViewBoxWidth:(CGFloat)boxWidth CategoryArr:(NSArray *)cArr{
    
    _categoryBtnArr = [NSMutableArray array];

    //创建视图
    UIView * boxView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,boxWidth,0));
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
            .L_tag(i)
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(boxView);
            
        }];
        
        [cItemView addClickedBlock:^(id obj) {
            
            NSInteger idx = ((UIView *)obj).tag;
            
            NSDictionary * dictData = cArr[idx];
            
            for(int i = 0;i<_categoryBtnArr.count;i++){
                ((UIButton *)_categoryBtnArr[i]).selected = NO;
            }
            
            ((UIButton *)_categoryBtnArr[idx]).selected = YES;
            
            
            [self.delegate categoryClick:dictData[@"c_name"] Cid:[dictData[@"c_id"] integerValue]];
 
        }];
        
        //创建图标
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(cItemWidth/2 - cItemWidth * 0.4/2,cItemWidth/2-cItemWidth * 0.4/2 - 5,cItemWidth * 0.4,cItemWidth * 0.4))
            .L_ImageName(dictData[@"icon"])
            .L_AddView(cItemView);
        }];
        
        //创建文字
        [UILabel LabelinitWith:^(UILabel *la) {
           
            la
            .L_Frame(CGRectMake(0,[icon bottom],cItemWidth,20))
            .L_Text(dictData[@"c_name"])
            .L_Font(12)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(cItemView);
            
        }];
        
        
        //创建选择图标
        UIButton * categorySelectedBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake([cItemView width] - MIDDLE_ICON_SIZE - 5,5,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_BtnImageName(@"weixuanzhong",UIControlStateNormal)
            .L_BtnImageName(@"xuanzhong",UIControlStateSelected)
            .L_AddView(cItemView);
            
        } buttonType:UIButtonTypeCustom];
        
        
        [_categoryBtnArr addObject:categorySelectedBtn];
        
        if(i == cArr.count - 1){

            [boxView setHeight:[cItemView bottom]];
       
        }
        
        
    }

    
    return @{ @"view" : boxView , @"height" : @([boxView height]) };
    
}
@end
