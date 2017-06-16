//
//  MatchUserVideoCommentCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchUserVideoCommentCell.h"
#import "MatchUserVideoCommentFrame.h"

@interface MatchUserVideoCommentCell()
{
    UIView      * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nicknameView;
    UILabel     * _timeView;
    UILabel     * _commentContent;
}
@end

@implementation MatchUserVideoCommentCell

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
            .L_ImageName(HEADER_DEFAULT)
            .L_AddView(_cellBox);
        }];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _timeView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentRight)
            .L_AddView(_cellBox);
        }];
        
        _commentContent = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_numberOfLines(0)
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
    
    
}

-(void)setMatchUserVideoCommentFrame:(MatchUserVideoCommentFrame *)matchUserVideoCommentFrame {
    
    _headerView.frame = matchUserVideoCommentFrame.headerFrame;
    NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,matchUserVideoCommentFrame.matchUserVideoCommentDict[@"u_header_url"]];
    _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
    _headerView.L_radius(5);
    
    _nicknameView.frame = matchUserVideoCommentFrame.nicknameFrame;
    _nicknameView.L_Text(matchUserVideoCommentFrame.matchUserVideoCommentDict[@"u_nickname"]);
    
    _timeView.frame = matchUserVideoCommentFrame.timeFrame;
    _timeView.L_Text([G formatData:[matchUserVideoCommentFrame.matchUserVideoCommentDict[@"mvc_create_time"] integerValue] Format:@"YYYY-MM-dd"]);
    
    _commentContent.frame = matchUserVideoCommentFrame.contentFrame;
    _commentContent.L_Text(matchUserVideoCommentFrame.matchUserVideoCommentDict[@"mvc_content"]);
    _commentContent.L_lineHeight(CONTENT_LINE_HEIGHT);
    
    
}

@end
