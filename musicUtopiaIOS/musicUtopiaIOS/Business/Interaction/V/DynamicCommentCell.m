//
//  DynamicCommentCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DynamicCommentCell.h"
#import "DynamicCommentFrame.h"
#import "GONMarkupParser_All.h"

@interface DynamicCommentCell()
{
    UIView      * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nicknameView;
    UILabel     * _timeView;
    UILabel     * _commentContent;
    UIView      * _actionView;
    UIImageView * _replyIconView;
    UILabel     * _replyTitleView;
    UIButton    * _commentZanIconView;
    UILabel     * _zanCountView;
}
@end

@implementation DynamicCommentCell

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
            .L_Font(SUBTITLE_FONT_SIZE)
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
        
        _actionView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_AddView(_cellBox);
        }];
        
        _replyIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Event(YES)
            .L_Click(self,@selector(commentReplyClick))
            .L_AddView(_actionView);
        }];
        
        _replyTitleView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_isEvent(YES)
            .L_Click(self,@selector(commentReplyClick))
            .L_AddView(_actionView);
        }];
        
//        _zanIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//            imgv
//            .L_Event(YES)
//            .L_Click(self,@selector(commentZanClick))
//            .L_AddView(_actionView);
//        }];
        
        _commentZanIconView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BtnImageName(@"dianzan",UIControlStateNormal)
            .L_BtnImageName(@"selected_dianzan",UIControlStateSelected)
            .L_TargetAction(self,@selector(commentZanClick),UIControlEventTouchUpInside)
            .L_AddView(_actionView);
        } buttonType:UIButtonTypeCustom];
        
        _zanCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_isEvent(YES)
            .L_Click(self,@selector(commentZanClick))
            .L_AddView(_actionView);
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

-(void)setDynamicCommentFrame:(DynamicCommentFrame *)dynamicCommentFrame {
 
    _headerView.frame = dynamicCommentFrame.headerFrame;
    NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dynamicCommentFrame.dynamicCommentDict[@"u_header_url"]];
    _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT).L_Event(YES).L_Click(self,@selector(headerClick)).L_radius(5);
    
    
    //判断是否为回复
    if([dynamicCommentFrame.dynamicCommentDict[@"dc_is_reply"] integerValue] == 0){
        _nicknameView.frame = dynamicCommentFrame.nicknameFrame;
        _nicknameView.L_Text(dynamicCommentFrame.dynamicCommentDict[@"u1_nickname"]);
    }else{
        _nicknameView.frame = dynamicCommentFrame.nicknameFrame;
        
        NSString *replyNickname = [NSString stringWithFormat:@"%@ 回复 <color value='#8BB3F1'>%@</>",dynamicCommentFrame.dynamicCommentDict[@"u1_nickname"],dynamicCommentFrame.dynamicCommentDict[@"u2_nickname"]];
        NSAttributedString *replyNicknameStr = [[GONMarkupParserManager sharedParser] attributedStringFromString:replyNickname error:nil];
        _nicknameView.attributedText = replyNicknameStr;
        
        //_nicknameView.L_Text([NSString stringWithFormat:@"%@ 回复 %@",dynamicCommentFrame.dynamicCommentDict[@"u1_nickname"],dynamicCommentFrame.dynamicCommentDict[@"u2_nickname"]]);
    }
    
    
    
    _timeView.frame = dynamicCommentFrame.timeFrame;
    _timeView.L_Text([G formatData:[dynamicCommentFrame.dynamicCommentDict[@"dc_create_time"] integerValue] Format:@"YYYY-MM-dd"]);
    
    _commentContent.frame = dynamicCommentFrame.contentFrame;
    _commentContent.L_Text(dynamicCommentFrame.dynamicCommentDict[@"dc_content"]);
    _commentContent.L_lineHeight(CONTENT_LINE_HEIGHT);
    
    _actionView.frame = dynamicCommentFrame.actionFrame;
    
    _replyIconView.frame = dynamicCommentFrame.replyIconFrame;
    _replyIconView.L_ImageName(@"huifu");
    
    _replyTitleView.frame = dynamicCommentFrame.replyTitleFrame;
    _replyTitleView.L_Text(@"回复");
    
    _commentZanIconView.frame = dynamicCommentFrame.zanIconFrame;
    if(dynamicCommentFrame.isCommentZan){
        _commentZanIconView.selected = YES;
    }else{
       _commentZanIconView.selected = NO;
    }
    
    _zanCountView.frame = dynamicCommentFrame.zanCountFrame;
    _zanCountView.L_Text([NSString stringWithFormat:@"%ld",(long)dynamicCommentFrame.commentZanCount]);
    
}

-(void)commentReplyClick {
    [self.delegate commentReplyClick:self];
}

-(void)commentZanClick {
    if(!_commentZanIconView.isSelected){
        [self.delegate commentZanClick:self];
    }
}

-(void)headerClick {
    [self.delegate commentUserHeaderClick:self];
}

@end
