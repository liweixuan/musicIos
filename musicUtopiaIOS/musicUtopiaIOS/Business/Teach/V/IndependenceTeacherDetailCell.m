//
//  IndependenceTeacherDetailCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IndependenceTeacherDetailCell.h"

@interface IndependenceTeacherDetailCell()
{
    UIView      * _cellBox;
    UILabel     * _titleView;
    UIImageView * _courseCoverView;
    UIView      * _middleLineView;
    UILabel     * _priceView;
    UIImageView * _rightIconView;
    UILabel     * _descView;
    
    
}
@end

@implementation IndependenceTeacherDetailCell

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
        
        _titleView = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _courseCoverView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_ImageMode(UIViewContentModeScaleToFill)
            .L_AddView(_cellBox);
        }];
        
        _middleLineView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _priceView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_AddView(_cellBox);
        }];
        
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _descView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
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
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN * 2);
    
    //标题
    _titleView.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP,200,TITLE_FONT_SIZE);
    
    //课程封面
    _courseCoverView.frame = CGRectMake(CONTENT_PADDING_LEFT, [_titleView bottom]+CONTENT_PADDING_TOP, [_cellBox width] - CONTENT_PADDING_LEFT * 2, 220);
    
    //分割线
    _middleLineView.frame = CGRectMake(CONTENT_PADDING_LEFT, [_courseCoverView bottom]+CONTENT_PADDING_TOP,[_cellBox width] - CONTENT_PADDING_LEFT * 2, 1);
    
    
    //价格
    _priceView.frame = CGRectMake(CONTENT_PADDING_LEFT, [_middleLineView bottom]+CONTENT_PADDING_TOP, 200,SUBTITLE_FONT_SIZE);
    
    //右侧箭头
    _rightIconView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - MIDDLE_ICON_SIZE, [_priceView top]-2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
    
    _descView.frame = CGRectMake([_rightIconView left] - 100 - ICON_MARGIN_CONTENT, [_priceView top]+1, 100, ATTR_FONT_SIZE);
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _titleView.L_Text(@"课程名称");
    _courseCoverView.L_ImageName(RECTANGLE_IMAGE_DEFAULT);
    _priceView.L_Text(@"999元/套");
    _rightIconView.L_ImageName(ICON_DEFAULT);
    _descView.L_Text(@"一阶段免费");
    
}


@end
