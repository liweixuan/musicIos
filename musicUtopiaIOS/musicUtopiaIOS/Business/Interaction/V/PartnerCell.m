//
//  PartnerCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PartnerCell.h"
#import "TagLabel.h"

@interface PartnerCell()
{
    UIView      * _cellBox;
    UIImageView * _headerUrlView;
    UIImageView * _sexIconView;
    UILabel     * _sexView;
    UILabel     * _nicknameView;
    UIImageView * _locationIconView;
    UILabel     * _locationView;
    UIView      * _tagBoxView;
    UILabel     * _titleView;
    UILabel     * _contentView;
    UIImageView * _askIconView;
    UILabel     * _askView;
    UIView      * _askBoxView;
    UIView      * _actionTopLine;
    UIView      * _actionBoxView;
    UIButton    * _actionUserDetailView;
    UIButton    * _actionApplyView;
    TagLabel    * _ageLabel;

}
@end

@implementation PartnerCell

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
        
        _headerUrlView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(HEADER_DEFAULT)
            .L_Event(YES)
            .L_Click(self,@selector(userHeaderClick))
            .L_AddView(_cellBox);
        }];
        
        _sexIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _sexView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _ageLabel = [[TagLabel alloc] init];
        _ageLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        _ageLabel.layer.masksToBounds = YES;
        _ageLabel.layer.cornerRadius  = 5;
        _ageLabel.insets = UIEdgeInsetsMake(2,5,2,5);
        [_cellBox addSubview:_ageLabel];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _locationIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"location_icon")
            .L_AddView(_cellBox);
        }];
        
        _locationView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _tagBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _titleView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _contentView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_numberOfLines(0)
            .L_AddView(_cellBox);
        }];
        
        
        _askIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"huobanyaoqiu")
            .L_AddView(_cellBox);
        }];
        
        _askView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _askBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _actionBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        
        _actionTopLine = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
            .L_AddView(_actionBoxView);
        }];
        
        _actionUserDetailView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BgColor([UIColor whiteColor])
            .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
            .L_Title(@"详细了解",UIControlStateNormal)
            .L_TargetAction(self,@selector(showDetail),UIControlEventTouchUpInside)
            .L_radius(5)
            .L_borderWidth(1)
            .L_borderColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_AddView(_actionBoxView);
        } buttonType:UIButtonTypeCustom];
        
        _actionApplyView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_Title(@"申请好友",UIControlStateNormal)
            .L_TargetAction(self,@selector(ApplyFriend),UIControlEventTouchUpInside)
            .L_radius(5)
            .L_AddView(_actionBoxView);
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

//设置位置+数据
-(void)setPartnerFrame:(PartnerFrame *)partnerFrame {
    
    
    //数据对象
    PartnerModel * dataModel = (PartnerModel *)partnerFrame.partnerModel;
    
    //头像
    _headerUrlView.frame = partnerFrame.headerUrlFrame;
    NSString * headerImageStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,partnerFrame.partnerModel.headerUrl];
    [_headerUrlView sd_setImageWithURL:[NSURL URLWithString:headerImageStr] placeholderImage:[UIImage imageNamed:HEADER_DEFAULT]];
    _headerUrlView.L_radius(5);
    
    //性别图标
    _sexIconView.frame = partnerFrame.sexIconFrame;
    _sexIconView.L_ImageName(dataModel.sexIcon);
    
    //性别
    _sexView.frame     = partnerFrame.sexFrame;
    _sexView.L_Text(dataModel.sex);
    
    _ageLabel.frame = partnerFrame.ageFrame;
    _ageLabel.text = [NSString stringWithFormat:@"%ld",(long)partnerFrame.partnerModel.userAge];
    
    //昵称
    _nicknameView.frame = partnerFrame.nickNameFrame;
    _nicknameView.L_Text(dataModel.nickname);

    //地理位置图标
    _locationIconView.frame = partnerFrame.locationIconFrame;
    
    //地理位置信息
    _locationView.frame = partnerFrame.locationFrame;
    _locationView.L_Text(dataModel.location);
    
    //tag容器
    _tagBoxView.frame = partnerFrame.tagBoxFrame;
    
    //创建tag显示视图
    if(partnerFrame.partnerModel.partnerTags.length > 0){
        NSArray *tags = [partnerFrame.partnerModel.partnerTags componentsSeparatedByString:@"|"];
        
        CGFloat nowX = 0.0;
        
        for(int i =0;i<tags.count;i++){
            
            //内容大小
            CGSize s = [G labelAutoCalculateRectWith:tags[i] FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(1000, 1000)];
            
            //创建UILabel
            TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(nowX,5,s.width + TAG_SIZE,TAG_SIZE)];
            tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
            tagLabel.text = tags[i];
            tagLabel.textColor = [UIColor whiteColor];
            tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
            tagLabel.layer.masksToBounds = YES;
            tagLabel.layer.cornerRadius = TAG_SIZE/2;
            tagLabel.insets = UIEdgeInsetsMake(0,TAG_SIZE/2, 0,TAG_SIZE/2);
            [_tagBoxView addSubview:tagLabel];
            
            //X轴位置变化
            nowX += s.width + TAG_SIZE + 10;
        }
    }
    
    //标题
    _titleView.frame = partnerFrame.titleFrame;
    _titleView.L_Text(partnerFrame.partnerModel.partnerTitle);
    
    //内容
    _contentView.frame = partnerFrame.contentFrame;
    _contentView.L_Text(dataModel.partnerDesc);
    _contentView.L_lineHeight(CONTENT_LINE_HEIGHT);
    
    //要求图标
    _askIconView.frame = partnerFrame.askIconFrame;
    
    //要求标题
    _askView.frame = partnerFrame.askFrame;
    _askView.L_Text(@"伙伴要求");
    
    //要求容器
    _askBoxView.frame = partnerFrame.askContentBoxFrame;
    
    //创建容器内容
    if(partnerFrame.partnerModel.partnerAsk.length > 0){
        
        NSArray *asks = [partnerFrame.partnerModel.partnerAsk componentsSeparatedByString:@"|"];
        
        CGFloat askItemHeight = 24;
        
        //创建内容
        for(int i=0;i<asks.count;i++){
            
            CGFloat tagY = askItemHeight * i;
            
            //要求项的视图
            UIView * askItemView = [UIView ViewInitWith:^(UIView *view) {
               view
                .L_Frame(CGRectMake(0,tagY, [_askBoxView width], askItemHeight))
                .L_AddView(_askBoxView);
            }];
            
            //序号
            UILabel * indexLabel = [UILabel LabelinitWith:^(UILabel *la) {
               la
                .L_Frame(CGRectMake(0,[askItemView height]/2 - 12/2,12,12))
                .L_Text([NSString stringWithFormat:@"%d",(i+1)])
                .L_BgColor(HEX_COLOR(BG_GARY))
                .L_Font(10)
                .L_textAlignment(NSTextAlignmentCenter)
                .L_TextColor(HEX_COLOR(@"#FFFFFF"))
                .L_radius(6)
                .L_AddView(askItemView);
            }];
            
            //内容
            [UILabel LabelinitWith:^(UILabel *la) {
                la
                .L_Frame(CGRectMake([indexLabel right]+ICON_MARGIN_CONTENT,[askItemView height]/2 - 20/2,[askItemView width] - 30,20))
                .L_Text(asks[i])
                .L_Font(CONTENT_FONT_SIZE)
                .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
                .L_AddView(askItemView);
            }];
            
            
            
        }
        
    }
    
    //要求容器
    _actionBoxView.frame = partnerFrame.actionBoxFrame;
    
    _actionTopLine.frame = CGRectMake(0,0,[_actionBoxView width],1);
    
    //创建操作按钮
//    _actionUserDetailView.frame = CGRectMake(([_actionBoxView width]/2)/2 - 100/2,[_actionBoxView height]/2 - 30/2 + 5,100,30);
//    _actionApplyView.frame = CGRectMake(([_actionBoxView width]/2)/2 + ([_actionBoxView width]/2 - 100/2),[_actionBoxView height]/2 - 30/2 + 5,100,30);
    
    
    
}


//头像点击
-(void)userHeaderClick {
    [self.delegate userHeaderClick:self];
}

//查看详细按钮点击
-(void)showDetail{
    [self.delegate userHeaderClick:self];
}


//申请好友点击
-(void)ApplyFriend {
    NSLog(@"申请好友...");
}

@end
