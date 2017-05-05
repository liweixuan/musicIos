//
//  OfficialMusicScoreCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OfficialMusicScoreCell.h"

@interface OfficialMusicScoreCell()
{
    UIView      * _cellBox;
    UIImageView * _titleImage;
    UILabel     * _musicScoreOrder;
    UILabel     * _musicScoreText;
    UIButton    * _playedDemonstration;
    UIButton    * _lookMusicScore;
    UILabel     * _musicScoreCount;
}
@end


@implementation OfficialMusicScoreCell

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
        
        _titleImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _musicScoreOrder = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _musicScoreText = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _playedDemonstration = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BgColor([UIColor whiteColor])
            .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
            .L_BorderWidth(1)
            .L_BorderColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Radius(5)
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
        
        
        _lookMusicScore = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_Radius(5)
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
        
        _musicScoreCount = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
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
    
    _titleImage.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP,110,80);
    
    _musicScoreOrder.frame = CGRectMake([_titleImage right]+CONTENT_PADDING_LEFT, [_titleImage top]+2, 200,TITLE_FONT_SIZE);
    
    _musicScoreText.frame = CGRectMake([_titleImage right]+CONTENT_PADDING_LEFT, [_musicScoreOrder bottom]+CONTENT_PADDING_TOP, 200,CONTENT_FONT_SIZE);
    
    _playedDemonstration.frame = CGRectMake([_titleImage right]+CONTENT_PADDING_LEFT,[_titleImage bottom] - 27,90,27);
    
    _lookMusicScore.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 90, [_playedDemonstration top], 90,27);
    
    _musicScoreCount.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 50, [_musicScoreOrder top], 50,CONTENT_FONT_SIZE);
    
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _titleImage.L_ImageName(RECTANGLE_IMAGE_DEFAULT);
    
    _musicScoreOrder.L_Text(@"练习一");
    
    _musicScoreCount.L_Text(@"共：3张");
    
    _musicScoreText.L_Text(@"小星星变奏曲");
    
    _playedDemonstration.L_Title(@"演奏示范",UIControlStateNormal);
    
    _lookMusicScore.L_Title(@"查看曲谱",UIControlStateNormal);
    
}

@end
