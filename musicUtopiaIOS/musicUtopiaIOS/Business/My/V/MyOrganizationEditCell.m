//
//  MyOrganizationEditCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyOrganizationEditCell.h"

@interface MyOrganizationEditCell()
{
    UIView      * _cellBox;
    UILabel     * _textLabel;
    UILabel     * _mustHint;
    UILabel     * _contentLabel;
    UIImageView * _rightIcon;
}
@end

@implementation MyOrganizationEditCell

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
        
        _textLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_AddView(_cellBox);
            
        }];
        
        _rightIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        
        
        _contentLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentRight)
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
    
    
    _textLabel.frame = CGRectMake(CONTENT_PADDING_LEFT,0,100, [_cellBox height]);
    
    _rightIcon.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE, [_cellBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    _contentLabel.frame = CGRectMake([_rightIcon left] - 150 - CONTENT_PADDING_LEFT,0,150,[_cellBox height]);
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    
    _textLabel.L_Text(dictData[@"text"]);
    
    _rightIcon.L_ImageName(@"fanhui");
    
    
    _contentLabel.L_Text(dictData[@"content"]);
    
    
}

-(void)setIsHideRightIcon:(BOOL)isHideRightIcon {
    
    if(isHideRightIcon){
        
        _rightIcon.hidden = YES;
        
    }
    
}
@end
