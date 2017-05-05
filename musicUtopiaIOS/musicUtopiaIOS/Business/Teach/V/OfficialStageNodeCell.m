//
//  OfficialStageNodeCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OfficialStageNodeCell.h"

@interface OfficialStageNodeCell()
{
    UIView      * _cellBox;
    UIImageView * _musicCoverView;
    UILabel     * _stageView;
    UILabel     * _statusView;
    UIImageView * _iconRightView;
    
}
@end

@implementation OfficialStageNodeCell

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
        
        _stageView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _statusView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
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

-(void)setDictData:(NSDictionary *)dictData{
    
    //乐器类型图片
    _musicCoverView.frame = CGRectMake(CONTENT_PADDING_LEFT,12, 110,80);
    _musicCoverView.L_ImageName(@"gangqin.jpg");
    
    //阶段名称
    _stageView.frame = CGRectMake([_musicCoverView right]+CONTENT_PADDING_LEFT,[_musicCoverView top]+CONTENT_PADDING_TOP,200,TITLE_FONT_SIZE);
    _stageView.L_Text(@"第一节/认识吉他1");
    
    //当前阶段状态
    _statusView.frame = CGRectMake([_stageView left], [_stageView bottom]+CONTENT_PADDING_TOP, 200, ATTR_FONT_SIZE);
    _statusView.L_Text(@"未观看");
    
    //右侧箭头
    _iconRightView.frame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - CONTENT_PADDING_LEFT - MIDDLE_ICON_SIZE,100/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE);
    
}

@end
