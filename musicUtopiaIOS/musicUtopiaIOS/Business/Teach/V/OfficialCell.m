//
//  OfficialCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OfficialCell.h"

@interface OfficialCell()
{
    UIView      * _cellBox;
    UIImageView * _musicCoverView;
    UIImageView * _musicCategoryIconView;
    UILabel     * _musicCategoryView;
    UILabel     * _musicCategoryDescView;
    UIImageView * _buyCountIconView;
    UILabel     * _buyCountView;
    UIImageView * _iconRightView;
}
@end

@implementation OfficialCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //设置CELL背景
        self.contentView.backgroundColor = HEX_COLOR(VC_BG);
        
        _cellBox = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(self.contentView);
            
        }];
        
        _musicCoverView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           
            imgv
            .L_radius(5)
            .L_AddView(_cellBox);
            
        }];
        
        _musicCategoryIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_AddView(_cellBox);
            
        }];
        
        _musicCategoryView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_AddView(_cellBox);
        
        }];
        
        _musicCategoryDescView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
            
        }];
        
        _buyCountIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _buyCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _iconRightView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(_cellBox);
        }];
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN * 2);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    //乐器类型图片
    _musicCoverView.frame = CGRectMake(CONTENT_PADDING_LEFT,12, 110,80);
    _musicCoverView.L_ImageName(@"gangqin.jpg");

    //乐器类别名称
    _musicCategoryView.frame = CGRectMake([_musicCoverView right]+CONTENT_PADDING_LEFT,[_musicCoverView top] + 15,80,TITLE_FONT_SIZE);
    _musicCategoryView.L_Text(dictData[@"c_name"]);

    //乐器图标
    _musicCategoryIconView.frame = CGRectMake([_musicCategoryView right]+ICON_MARGIN_CONTENT, [_musicCategoryView top]-3, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
    _musicCategoryIconView.L_ImageName(ICON_DEFAULT);
    
    
    //描述
    _musicCategoryDescView.frame = CGRectMake([_musicCategoryView left],[_musicCategoryView bottom] + 8,80,ATTR_FONT_SIZE);
    _musicCategoryDescView.L_Text(@"一阶段免费");
    
    //购买人数图标
    _buyCountIconView.frame = CGRectMake([_musicCategoryView left], [_musicCoverView bottom] - 20, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    _buyCountIconView.L_ImageName(ICON_DEFAULT);
    
    //购买人数
    _buyCountView.frame = CGRectMake([_buyCountIconView right]+ICON_MARGIN_CONTENT,[_musicCoverView bottom] - 20,200,CONTENT_FONT_SIZE);
    _buyCountView.L_Text([NSString stringWithFormat:@"已购人数：%@ 人",@"1000"]);
    
    //右侧箭头
    _iconRightView.frame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - CONTENT_PADDING_LEFT - MIDDLE_ICON_SIZE,100/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE);
    
}

@end
