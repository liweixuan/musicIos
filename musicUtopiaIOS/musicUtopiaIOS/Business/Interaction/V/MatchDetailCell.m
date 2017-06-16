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
    UILabel     * _playHint;
    UIView      * _progressBox;
    UIView      * _progressValue;
    UILabel     * _progressText;
    UIButton    * _voteButton;
    
    NSInteger     _nowVoteCount;
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
        
//        _orderLabel = [UILabel LabelinitWith:^(UILabel *la) {
//            la
//            .L_Font(TITLE_FONT_SIZE)
//            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
//            .L_TextColor([UIColor whiteColor])
//            .L_textAlignment(NSTextAlignmentCenter)
//            .L_AddView(_cellBox);
//        }];
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_radius(5)
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
        
        _playHint = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentRight)
            .L_AddView(_cellBox);
        }];
        
        _progressBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        _progressValue = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_radius(5)
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_progressBox);
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
    
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,50,50);
    
//    _orderLabel.frame = CGRectMake([_headerView left] - 30, [_headerView top] + 20,16,16);
//    _orderLabel.L_radius(8);
    
    _nickname.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_headerView top] + 15, [_cellBox width] - 50 - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE);
    
    _playVideo.frame = CGRectMake([_cellBox width] - BIG_ICON_SIZE - CONTENT_PADDING_LEFT, [_headerView top]+10, BIG_ICON_SIZE,BIG_ICON_SIZE);
    
    _playHint.frame = CGRectMake([_playVideo left] - 100, [_playVideo top]+6, 100, CONTENT_FONT_SIZE);
    
    _progressBox.frame = CGRectMake(CONTENT_PADDING_LEFT, [_headerView bottom] + 20, [_cellBox width] - 120 - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE);
    
   
    
    _progressText.frame = CGRectMake([_progressBox right]+ICON_MARGIN_CONTENT, [_progressBox top],40,TITLE_FONT_SIZE);
    
    _voteButton.frame = CGRectMake( [_cellBox width] - 60 - CONTENT_PADDING_LEFT, [_progressText top]- 10, 60, 30);
    
}

//-(void)setIdx:(NSInteger)idx {
//    _orderLabel.L_Text([NSString stringWithFormat:@"%ld",((long)idx + 1)]);
//}

-(void)setDictData:(NSDictionary *)dictData {

    NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"u_header_url"]];
    _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
    
    _nickname.L_Text(dictData[@"u_nickname"]);
    
    _playVideo.L_ImageName(@"fanhui");
    
    _playHint.L_Text(@"去看看比赛视频");
    
    _progressBox.L_BgColor(HEX_COLOR(@"#EEEEEE"));
 
    _progressText.L_Text([NSString stringWithFormat:@"%@票",dictData[@"mpu_vote_count"]]);
    
    _voteButton.L_Title(@"投票",UIControlStateNormal);
    _voteButton.L_TitleColor([UIColor whiteColor],UIControlStateNormal);
    
    _nowVoteCount = [dictData[@"mpu_vote_count"] floatValue];
    
    CGFloat progressBoxWidth   = [self.contentView width] - CARD_MARGIN_LEFT * 2  - 100;
    CGFloat progressValueWidth = (float)_nowVoteCount/14 * progressBoxWidth;
    _progressValue.frame = CGRectMake(0,0,0,TITLE_FONT_SIZE);
    [UIView animateWithDuration:0.8 animations:^{
        [_progressValue setWidth:progressValueWidth];
    }];

}



-(void)setIsVote:(NSInteger)isVote {
    
    if(isVote == 1){
        _voteButton.L_TargetAction(self,@selector(voteBtnClick),UIControlEventTouchUpInside);
    }else{
        _voteButton.L_BgColor(HEX_COLOR(BG_GARY));
        _voteButton.L_TitleColor([UIColor whiteColor],UIControlStateNormal);
    }
    
    
}

-(void)voteBtnClick {
    [self.delegate voteBtnClick:self];
}

@end
