//
//  AddUpgradeInstrumentCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddUpgradeInstrumentCell.h"

@interface AddUpgradeInstrumentCell()
{
    UIView      * _cellBox;
    UIImageView * _instrumentIcon;
    UILabel     * _instrumentText;
    UILabel     * _nowLevel;
    UILabel     * _goLevelHint;
    UIImageView * _rightIcon;
}
@end

@implementation AddUpgradeInstrumentCell

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
        
        _instrumentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_cellBox);
        }];
        
        _instrumentText = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _nowLevel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _goLevelHint = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _rightIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN*2);
    
    _instrumentIcon.frame = CGRectMake(CONTENT_MARGIN_LEFT,[_cellBox height]/2 - 30/2,30, 30);
    
    _instrumentText.frame = CGRectMake([_instrumentIcon right]+10,[_cellBox height]/2 - SUBTITLE_FONT_SIZE/2,80,SUBTITLE_FONT_SIZE);
    
    _nowLevel.frame = CGRectMake([_instrumentText right]+ICON_MARGIN_CONTENT, [_cellBox height]/2 - CONTENT_FONT_SIZE/2,80,CONTENT_FONT_SIZE);
    
    _rightIcon.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE, [_cellBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    _goLevelHint.frame = CGRectMake([_rightIcon left] - 45 , [_cellBox height]/2 - ATTR_FONT_SIZE/2, 40, ATTR_FONT_SIZE);
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    //获取类别图标
    NSDictionary * categoryData = [BusinessEnum getCategoryId:[dictData[@"c_id"] integerValue]];
    _instrumentIcon.L_ImageName(categoryData[@"icon"]);
    
    _instrumentText.L_Text(categoryData[@"c_name"]);
    
    _nowLevel.L_Text([NSString stringWithFormat:@"当前：0 级"]);
    
    _goLevelHint.L_Text(@"去评测");
    
    _rightIcon.L_ImageName(@"fanhui");
    
}

@end
