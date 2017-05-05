//
//  OrganizationUserCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrganizationUserCell.h"

@interface OrganizationUserCell()
{
    UIView * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nickname;
    UILabel     * _goodMusic;
    UIImageView * _rightIconView;
}
@end

@implementation OrganizationUserCell

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
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_AddView(_cellBox);
        }];
        
        _nickname = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _goodMusic = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        //右侧箭头
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
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
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN*2);
    
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,10,40,40);
    
    _nickname.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT,[_headerView top]+5,200,CONTENT_FONT_SIZE);
    
    _goodMusic.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_nickname bottom]+5,200,ATTR_FONT_SIZE);
    
    _rightIconView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - MIDDLE_ICON_SIZE,[_cellBox height]/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _headerView.L_ImageName(HEADER_DEFAULT);
    
    _nickname.L_Text(@"桃子小姐");
    
    _goodMusic.L_Text(@"擅长乐器：古典吉他");
    
    
    
}


@end