//
//  MessageCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell()
{
    UIView      * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nicknameView;
    UILabel     * _messageContentView;
    UILabel     * _timeView;
    UILabel     * _messageCountView;
}
@end

@implementation MessageCell

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
            .L_Round()
            .L_AddView(_cellBox);
        }];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _messageContentView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _timeView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentRight)
            .L_AddView(_cellBox);
        }];
        
        _messageCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(12)
            .L_TextColor([UIColor whiteColor])
            .L_BgColor([UIColor redColor])
            .L_textAlignment(NSTextAlignmentCenter)
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
    
    //头像
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,50,50);
    _headerView.L_ImageName(HEADER_DEFAULT);
    
    //昵称
    _nicknameView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_headerView top]+8,200,SUBTITLE_FONT_SIZE);
    _nicknameView.L_Text(@"小鲤鱼");
    
    //消息内容
    _messageContentView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_nicknameView bottom]+10,[_cellBox width] - [_headerView width] - CONTENT_PADDING_LEFT - 20 - 30,CONTENT_FONT_SIZE);
    _messageContentView.L_Text(@"今天天气不错，你在干什么呢？想去玩吗？");
    
    //发送时间
    _timeView.frame = CGRectMake([_cellBox width] - 60 - CONTENT_PADDING_LEFT,[_nicknameView top],60,ATTR_FONT_SIZE);
    _timeView.L_Text(@"2天前");
    
    //消息数提示
    _messageCountView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 20,[_timeView bottom]+8,20,20);
    _messageCountView.L_radius(10);
    _messageCountView.L_Text(@"99");
}



@end
