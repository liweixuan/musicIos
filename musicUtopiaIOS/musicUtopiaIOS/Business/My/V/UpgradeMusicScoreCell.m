//
//  UpgradeMusicScoreCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UpgradeMusicScoreCell.h"

@interface UpgradeMusicScoreCell()
{
    UIView      * _cellBox;
    UILabel     * _hotCountTitle;
    UIImageView * _middleLineIcon;
    UILabel     * _categoryTitleLabel;
    UILabel     * _musicScoreName;
    UILabel     * _pageCount;
    UIImageView * _iconRightView;
}
@end

@implementation UpgradeMusicScoreCell

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
        
        
        
        _hotCountTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(15)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        
        _middleLineIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"test2.jpg")
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_cellBox);
        }];
        
        _categoryTitleLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _musicScoreName = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _pageCount = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentRight)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _iconRightView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"fanhui")
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

    _hotCountTitle.frame = CGRectMake(CONTENT_PADDING_LEFT,[_cellBox height]/2 - 30/2,30,30);
    
    _middleLineIcon.frame = CGRectMake([_hotCountTitle right]+ICON_MARGIN_CONTENT, [_cellBox height]/2- 36/2, 14,36);
    
    _categoryTitleLabel.frame = CGRectMake([_middleLineIcon right]+ICON_MARGIN_CONTENT,[_cellBox height]/2-CONTENT_FONT_SIZE/2,40,CONTENT_FONT_SIZE);
    
    _musicScoreName.frame = CGRectMake([_categoryTitleLabel right],[_cellBox height]/2-CONTENT_FONT_SIZE/2, 200, CONTENT_FONT_SIZE);
    
    //右侧箭头
    _iconRightView.frame = CGRectMake([_cellBox width] - SMALL_ICON_SIZE - CONTENT_PADDING_LEFT,[_cellBox height]/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE);
    
    _pageCount.frame = CGRectMake([_iconRightView left] - 40,[_cellBox height]/2 - ATTR_FONT_SIZE/2, 40,ATTR_FONT_SIZE);
    
}

-(void)setDictData:(NSDictionary *)dictData {

    _hotCountTitle.text      = @"1级";
    
    NSString * typeStr = [BusinessEnum getMusicScoreTypeString:[dictData[@"ms_type"] integerValue]];
    _categoryTitleLabel.text = [NSString stringWithFormat:@"[%@]",typeStr];
    
    _musicScoreName.text     = dictData[@"ms_name"];
    
    _pageCount.text          = [NSString stringWithFormat:@"%@页",dictData[@"mu_page"]];
    
    
}

@end
