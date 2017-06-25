//
//  ConcernCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ConcernCell.h"
#import "TagLabel.h"

@interface ConcernCell()
{
    UIView      * _cellBox;
    UIImageView * _headerImageView;
    UILabel     * _nicknameView;
    UIImageView * _rightIconView;
    UIImageView * _sexIcon;
    UILabel     * _sign;
    TagLabel    * _age;
}
@end

@implementation ConcernCell

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
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
            
        }];
        
        _sign = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
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
        
        //右侧箭头
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"fanhui")
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
    
    _headerImageView.frame = CGRectMake(CONTENT_PADDING_LEFT,10,40,40);
    
    _sexIcon.frame =CGRectMake([_headerImageView right]+CONTENT_PADDING_LEFT,[_headerImageView top]+3,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    _nicknameView.frame = CGRectMake([_sexIcon right]+5,[_headerImageView top]+2, 100,SUBTITLE_FONT_SIZE);
    
    
    _age.frame = CGRectMake([_headerImageView right]+CONTENT_PADDING_LEFT,[_nicknameView bottom]+8,28,16);

    
    _sign.frame = CGRectMake([_age right]+5 ,[_nicknameView bottom]+10,200,ATTR_FONT_SIZE);
 
    
    _rightIconView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE,[_cellBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"u_header_url"]];
    _headerImageView.L_ImageUrlName(imageUrl,HEADER_DEFAULT);
    
    _nicknameView.L_Text(dictData[@"u_nickname"]);
    
    NSString * signStr = [BusinessEnum getEmptyString:dictData[@"u_sign"]];
    _sign.L_Text(signStr);
    
    if([dictData[@"u_sex"] integerValue] == 0){
        
        _sexIcon.L_ImageName(@"sex_nan");
        
    }else{
        
        _sexIcon.L_ImageName(@"sex_nv");
    }
    
    _age.text = [NSString stringWithFormat:@"%@",dictData[@"u_age"]];

    
    
}
@end
