//
//  MatchCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchCell.h"

@interface MatchCell()
{
    UIView      * _cellBox;
    UIImageView * _matchCoverView;
    UILabel     * _matchTypeView;
    UILabel     * _matchNameView;
    UILabel     * _matchInvolvementCountView;
    UIImageView * _matchCategoryIconView;
    UILabel     * _matchCategoryView;
    UILabel     * _matchStartTimeView;
    UILabel     * _matchEndTimeView;
    UILabel     * _matchVoteView;
    UIView      * _matchMiddleLineView;
    UIButton    * _matchStatusView;
    UIButton    * _matchActionView;
}
@end

@implementation MatchCell

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
        
        _matchCoverView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_radius(5)
            .L_AddView(_cellBox);
            
        }];
        
        _matchTypeView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_BgColor([UIColor blackColor])
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_Alpha(0.6)
            .L_AddView(_matchCoverView);
        }];
        
        _matchNameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _matchInvolvementCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentLeft)
            .L_AddView(_cellBox);
        }];
        
//        _matchCategoryIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//            
//            imgv
//            .L_ImageMode(UIViewContentModeScaleAspectFit)
//            .L_AddView(_cellBox);
//            
//        }];
        
        _matchCategoryView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _matchStartTimeView =  [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _matchEndTimeView =  [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(_cellBox);
        }];

        _matchVoteView = [UILabel LabelinitWith:^(UILabel *la) {

            la
            .L_BgColor([UIColor whiteColor])
            .L_Text(@"去投票")
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(14)
            .L_isEvent(YES)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_radius(25)
            .L_borderWidth(1)
            .L_borderColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Click(self,@selector(voteClick))
            .L_AddView(_cellBox);
            
        }];
        
        _matchMiddleLineView = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
            .L_AddView(_cellBox);
            
        }];
        
        _matchStatusView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Font(12)
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_Radius(5)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
        
        _matchActionView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Font(12)
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_Radius(5)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];

    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,CARD_MARGIN_TOP,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - CARD_MARGIN_TOP);
}

-(void)setMatchFrame:(MatchFrame *)matchFrame {
    
    
    //赛事封面
    NSString * coverImage = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,matchFrame.matchModel.matchCover];
    _matchCoverView.frame = matchFrame.matchCoverFrame;
    _matchCoverView.L_ImageUrlName(coverImage,IMAGE_DEFAULT);
    
    //赛事类别
    _matchTypeView.frame = matchFrame.matchTypeFrame;
    _matchTypeView.L_Text(matchFrame.matchModel.matchTypeStr);
    
    //曲目名称
    _matchNameView.frame = matchFrame.matchNameFrame;
    _matchNameView.L_Text(matchFrame.matchModel.matchName);
    
    //参与人数
    _matchInvolvementCountView.frame = matchFrame.matchInvolvementCountFrame;
    _matchInvolvementCountView.L_Text([NSString stringWithFormat:@"已参与：%ld",(long)matchFrame.matchModel.matchInvolvementCount]);
    
//    //类别图标
//    _matchCategoryIconView.frame = matchFrame.matchCategoryIconFrame;
//    _matchCategoryIconView.L_ImageName(matchFrame.matchModel.cIcon);
    
    //类别名称
    _matchCategoryView.frame = matchFrame.matchCategoryFrame;
    _matchCategoryView.L_Text([NSString stringWithFormat:@"乐器：[ %@ ]",matchFrame.matchModel.cName]);
    
    //开始时间
    _matchStartTimeView.frame = matchFrame.matchStartTimeFrame;
    _matchStartTimeView.L_Text([NSString stringWithFormat:@"开始时间：%@",matchFrame.matchModel.matchStartTime]);
    
    //结束时间
    _matchEndTimeView.frame = matchFrame.matchEndTimeFrame;
    _matchEndTimeView.L_Text([NSString stringWithFormat:@"结束时间：%@",matchFrame.matchModel.matchEndTime]);
    
    //去投票按钮
    _matchVoteView.frame  = matchFrame.matchVoteFrame;
    _matchVoteView.hidden = YES;

    //判断是否显示投票按钮
    if(matchFrame.matchModel.nowStatus == 1){
        _matchVoteView.hidden = NO;
    }
    
    //分割线
    _matchMiddleLineView.frame = matchFrame.middleLineFrame;
    
    //状态按钮
    _matchStatusView.frame = matchFrame.matchStatusFrame;
    _matchStatusView.L_BgColor(HEX_COLOR(BG_GARY));

    if(matchFrame.matchModel.nowStatus == 0){
        _matchStatusView.L_Title(@"抱歉，比赛未开始",UIControlStateNormal);
        _matchStatusView.L_BgColor(HEX_COLOR(@"#E6CA79"));
    }else if(matchFrame.matchModel.nowStatus == 1){
        _matchStatusView.L_BgColor(HEX_COLOR(@"#68D249"));
        _matchStatusView.L_Title(@"进行中",UIControlStateNormal);
    }else{
        _matchStatusView.L_Title(@"抱歉，比赛已结束",UIControlStateNormal);
        _matchStatusView.L_BgColor(HEX_COLOR(BG_GARY));
    }
    
    
    
    //操作按钮
    _matchActionView.frame = matchFrame.matchActionFrame;
    _matchActionView.L_BgColor(HEX_COLOR(APP_MAIN_COLOR));
    _matchActionView.L_TargetAction(self,@selector(matchActionClick:),UIControlEventTouchUpInside);
    
    if(matchFrame.matchModel.nowStatus == 2){
        _matchActionView.L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal);
        _matchActionView.L_BgColor([UIColor whiteColor]).L_borderWidth(1).L_borderColor(HEX_COLOR(APP_MAIN_COLOR));
        _matchActionView.L_Title(@"比赛结果",UIControlStateNormal);
    }else if(matchFrame.matchModel.nowStatus == 1){
        _matchActionView.L_Title(@"参与比赛",UIControlStateNormal);
    }else{
        _matchActionView.hidden = YES;
    }
    
}

-(void)setIsPartakeMatch:(BOOL)isPartakeMatch {
    
    if(isPartakeMatch){
        _matchActionView.L_Title(@"退出比赛",UIControlStateNormal);
    }
    
    
}

#pragma mark - 事件
//去投票按钮点击时
-(void)voteClick {
    
    NSLog(@"去投票按钮点击...");
    [self.delegate voteClick:self];
}

//操作按钮
-(void)matchActionClick:(UIButton *)sender {
    
    NSString * btnTitle = sender.titleLabel.text;
    
    if([btnTitle isEqualToString:@"参与比赛"]){
        
        [self.delegate partakeMatchClick:self];
        
    }else if([btnTitle isEqualToString:@"比赛结果"]){
        
        [self.delegate matchResultClick:self];
        
    }else{
        
        [self.delegate quitMatchClick:self];
        
    }
    
}

@end
