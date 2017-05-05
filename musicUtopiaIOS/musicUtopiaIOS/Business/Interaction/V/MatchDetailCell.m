//
//  MatchDetailCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchDetailCell.h"

@interface MatchDetailCell()
{
    UIView      * _cellBox;
    UILabel     * _orderLabel;
    UIImageView * _headerView;
    UILabel     * _nickname;
    UIImageView * _playVideo;
    UIView      * _progressBox;
    UILabel     * _progressText;
    UIButton    * _voteButton;
}
@end

@implementation MatchDetailCell

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
        
        _orderLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_AddView(_cellBox);
        }];
        
        _nickname = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _playVideo = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_radius(25)
            .L_AddView(_cellBox);
        }];
        
        _progressBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        _progressText = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _voteButton = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_radius(5)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
    
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN * 2);
    
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT + 20,CONTENT_PADDING_TOP,50,50);
    
    _orderLabel.frame = CGRectMake([_headerView left] - 20, [_headerView top] + 20,10,10);
    
    _nickname.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_headerView top] + 15, [_cellBox width] - 50 - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE);
    
    _playVideo.frame = CGRectMake([_cellBox width] - 50 - CONTENT_PADDING_LEFT, [_headerView top], 50,50);
    
    _progressBox.frame = CGRectMake(CONTENT_PADDING_LEFT, [_headerView bottom] + 20, [_cellBox width] - 120 - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE);
    
    _progressText.frame = CGRectMake([_progressBox right]+ICON_MARGIN_CONTENT, [_progressBox top],40,TITLE_FONT_SIZE);
    
    _voteButton.frame = CGRectMake( [_cellBox width] - 60 - CONTENT_PADDING_LEFT, [_progressText top]- 10, 60, 30);
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _orderLabel.L_Text(@"1");
    
    _headerView.L_ImageName(HEADER_DEFAULT);
    
    _nickname.L_Text(@"桃子小姐");
    
    _playVideo.L_ImageName(IMAGE_DEFAULT);
    
    _progressBox.L_BgColor(HEX_COLOR(@"#EEEEEE"));
    
    _progressText.L_Text(@"999");
    
    _voteButton.L_Title(@"投票",UIControlStateNormal);
    _voteButton.L_TitleColor([UIColor whiteColor],UIControlStateNormal);
    
}

@end
