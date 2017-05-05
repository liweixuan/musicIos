//
//  ChatroomListCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChatroomListCell.h"

@interface ChatroomListCell()
{
    UIView      * _cellBox;
    UILabel     * _userCountLabel;
    UILabel     * _onlineHint;
    UIView      * _rightLine;
    UIImageView * _headerView;
    UILabel     * _nicknameView;
    UILabel     * _loctaionView;
}
@end

@implementation ChatroomListCell

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
        
        _userCountLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _onlineHint = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _rightLine = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Round()
            .L_AddView(_cellBox);
        }];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _loctaionView = [UILabel LabelinitWith:^(UILabel *la) {
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
    
    _userCountLabel.frame = CGRectMake(CONTENT_PADDING_LEFT,[_cellBox height]/2-TITLE_FONT_SIZE/2 - 12,30,TITLE_FONT_SIZE);
    _userCountLabel.text = @"99";
    
    _onlineHint.frame = CGRectMake(CONTENT_PADDING_LEFT,[_userCountLabel bottom] + 5,30,ATTR_FONT_SIZE);
    _onlineHint.text  = @"在线";
    
    _rightLine.frame = CGRectMake([_userCountLabel right]+CONTENT_PADDING_LEFT,10,1,[_cellBox height] - 20);
    
    //头像
    _headerView.frame = CGRectMake([_rightLine right]+CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,50,50);
    _headerView.L_ImageName(HEADER_DEFAULT);
    
    //昵称
    _nicknameView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_headerView top]+8,200,SUBTITLE_FONT_SIZE);
    _nicknameView.L_Text(@"小鲤鱼");
    
    //消息内容
    _loctaionView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_nicknameView bottom]+10,[_cellBox width] - [_headerView width] - CONTENT_PADDING_LEFT - 20 - 30,CONTENT_FONT_SIZE);
    _loctaionView.L_Text(@"甘肃省-天水市");

}
@end
