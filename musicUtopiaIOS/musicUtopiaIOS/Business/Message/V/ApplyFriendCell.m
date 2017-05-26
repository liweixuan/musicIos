//
//  ApplyFriendCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ApplyFriendCell.h"


@interface ApplyFriendCell()
{
    UIView      * _cellBox;
    UIImageView * _headerImageView;
    UILabel     * _nicknameView;
    UILabel     * _actionLabel;
    UIButton    * _agreedToBtn;
    UIButton    * _refusedToBtn;
}
@end

@implementation ApplyFriendCell

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
        
        
        _headerImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(HEADER_DEFAULT)
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        //标题
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _actionLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _agreedToBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Title(@"同意",UIControlStateNormal)
            .L_TargetAction(self,@selector(agreedToBtnClick),UIControlEventTouchUpInside)
            .L_Font(12)
            .L_radius(5)
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
        
        
        _refusedToBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Title(@"拒绝",UIControlStateNormal)
            .L_TargetAction(self,@selector(refusedToBtnClick),UIControlEventTouchUpInside)
            .L_TitleColor(HEX_COLOR(TITLE_FONT_COLOR),UIControlStateNormal)
            .L_Font(12)
            .L_radius(5)
            .L_borderWidth(1)
            .L_borderColor(HEX_COLOR(BG_GARY))
            .L_BgColor([UIColor whiteColor])
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
    
    _headerImageView.frame = CGRectMake(CONTENT_PADDING_LEFT,11,50,50);
    
    _nicknameView.frame = CGRectMake([_headerImageView right]+CONTENT_PADDING_LEFT,[_headerImageView top]+4, 100,TITLE_FONT_SIZE);
    
    _actionLabel.frame = CGRectMake([_headerImageView right]+CONTENT_PADDING_LEFT, [_nicknameView bottom]+10,200,CONTENT_FONT_SIZE);
    
    _agreedToBtn.frame = CGRectMake([_cellBox width] - 60 - 10,10,60,25);
    
    _refusedToBtn.frame = CGRectMake([_cellBox width] - 60 - 10,[_agreedToBtn bottom]+5,60,25);
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    [MemberInfoData getMemberInfo:dictData[@"frl_sponsorUserName"] MemberEnd:^(NSDictionary *memberInfo) {
        
        NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,memberInfo[@"m_headerUrl"]];
        _headerImageView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
        
        //昵称
        _nicknameView.L_Text(memberInfo[@"m_nickName"]);
        
    }];
    
    if([dictData[@"frl_status"] integerValue] == 0){
        _actionLabel.L_Text(@"请求成为您的好友");
        _agreedToBtn.hidden  = NO;
        _refusedToBtn.hidden = NO;
    }else if([dictData[@"frl_status"] integerValue] == 1){
        _actionLabel.L_Text(@"您同意了该用户的好友请求");
        _agreedToBtn.hidden  = YES;
        _refusedToBtn.hidden = YES;

    }else if([dictData[@"frl_status"] integerValue] == 2){
        _actionLabel.L_Text(@"您拒绝了该用户的好友请求");
        _agreedToBtn.hidden  = YES;
        _refusedToBtn.hidden = YES;
    }
    
    
    
}

-(void)agreedToBtnClick {
    [self.delegate agreedToBtnClick:self];
}

-(void)refusedToBtnClick {
    [self.delegate refusedToBtnClick:self];
}

@end
