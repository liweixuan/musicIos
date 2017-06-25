//
//  OrganizationUserCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrganizationUserCell.h"
#import "TagLabel.h"

@interface OrganizationUserCell()
{
    UIView * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nickname;
    UILabel     * _goodMusic;
    UIImageView * _rightIconView;
    UIImageView * _sexIcon;
    TagLabel    * _age;
    UIButton    * _managerOrganizationBtn;
    UILabel     * _isOrganizationCreate;
    
    BOOL          _isCreateUser;
}
@end

@implementation OrganizationUserCell

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
            .L_AddView(_cellBox);
        }];
        
        _nickname = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _goodMusic = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
            
        }];
        
        //右侧箭头
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"fanhui")
            .L_AddView(_cellBox);
            
        }];
        
        _age = [[TagLabel alloc] init];
        _age.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        _age.textColor = [UIColor whiteColor];
        _age.textAlignment = NSTextAlignmentCenter;
        _age.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        _age.layer.masksToBounds = YES;
        _age.layer.cornerRadius  = 5;
        _age.insets = UIEdgeInsetsMake(2,5,2,5);
        [_cellBox addSubview:_age];
        
        _isOrganizationCreate = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(12)
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"团长")
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        _isOrganizationCreate.hidden = YES;
        
        _managerOrganizationBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Title(@"管理成员",UIControlStateNormal)
            .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
            .L_BgColor(HEX_COLOR(@"#3CB371"))
            .L_Font(12)
            .L_TargetAction(self,@selector(deleteOrganizationClick),UIControlEventTouchUpInside)
            .L_radius(5)
            .L_AddView(_cellBox);
        } buttonType:UIButtonTypeCustom];
        _managerOrganizationBtn.hidden = YES;
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN*2);
    
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,10,40,40);
    
    _sexIcon.frame =CGRectMake([_headerView right]+CONTENT_PADDING_LEFT,[_headerView top]+3,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    _nickname.frame = CGRectMake([_sexIcon right]+5,[_headerView top]+2,200,CONTENT_FONT_SIZE);

    
    _age.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT,[_nickname bottom]+8,28,16);
    
    _goodMusic.frame = CGRectMake([_age right]+5, [_age top]+2,200,ATTR_FONT_SIZE);

    
    _rightIconView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE,[_cellBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    _managerOrganizationBtn.frame = CGRectMake([_rightIconView left] - 90,[_cellBox height]/2 - 30/2, 80,30);
    
    _isOrganizationCreate.frame = CGRectMake([_rightIconView left] - 60, [_cellBox height]/2 - 25/2,50,25);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"u_header_url"]];
    _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
    _headerView.L_radius(5);
    
    _nickname.L_Text(dictData[@"u_nickname"]);
    
    NSArray * instrumentArr = [dictData[@"u_good_instrument"] componentsSeparatedByString:@"|"];
    _goodMusic.L_Text([NSString stringWithFormat:@"擅长乐器：%@",instrumentArr[1]]);
    
    if([dictData[@"u_sex"] integerValue] == 0){
        _sexIcon.L_ImageName(@"sex_nan");
    }else{
        _sexIcon.L_ImageName(@"sex_nv");
    }
    
    if([dictData[@"om_is_create_user"] integerValue] == 1){
        _isOrganizationCreate.hidden  = NO;
        _isCreateUser = YES;
    }
    
    
    _age.text = [NSString stringWithFormat:@"%@",dictData[@"u_age"]];
    
}

-(void)setIsManagerUser:(BOOL)isManagerUser {
    
    if(isManagerUser){
        
        if(!_isCreateUser){
            _managerOrganizationBtn.hidden = NO;
        }
        
    }
    
}

//踢出团体按钮
-(void)deleteOrganizationClick {
    [self.delegate managerOrganizationUser:self];
}
@end
