//
//  IndependenceTeacherModeCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IndependenceTeacherModeCell.h"

@interface IndependenceTeacherModeCell()
{
    UIView      * _cellBox;
    UIImageView * _headerView;
    UILabel     * _teacherNameView;
    UILabel     * _matchMusicView;  //教授的乐器
    UILabel     * _courseCountView;
    UIImageView * _rightIconView;
    UIImageView * _locationIconView;
    UILabel     * _locationView;

}
@end

@implementation IndependenceTeacherModeCell

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
        
        _teacherNameView = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _matchMusicView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_AddView(_cellBox);
            
        }];
        
        _courseCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _locationView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _locationIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
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
    
    //头像位置
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP+3,60,60);
    
    //教师名称
    _teacherNameView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT,[_headerView top],200,TITLE_FONT_SIZE);
    
    //教授乐器
    _matchMusicView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT,[_teacherNameView bottom]+5,200,SUBTITLE_FONT_SIZE);
    
    //地点图标
    _locationIconView.frame = CGRectMake([_headerView right]+CONTENT_PADDING_LEFT, [_matchMusicView bottom]+8, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    //老师所在省份城市
    _locationView.frame = CGRectMake([_locationIconView right]+ICON_MARGIN_CONTENT, [_locationIconView top]-1, 200,CONTENT_FONT_SIZE);
    
    //右侧箭头
    _rightIconView.frame = CGRectMake([_cellBox right] - CONTENT_PADDING_LEFT*2 - MIDDLE_ICON_SIZE,[_cellBox height]/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE);
    
    //课程数量
    _courseCountView.frame = CGRectMake([_rightIconView left] - 25 - ICON_MARGIN_CONTENT, [_rightIconView top]+3, 25,ATTR_FONT_SIZE);
    
    
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _headerView.L_ImageName(HEADER_DEFAULT);
    _teacherNameView.L_Text(@"李梵语");
    _matchMusicView.L_Text([NSString stringWithFormat:@"授课乐器：%@",@"古典吉他"]);
    _rightIconView.L_ImageName(ICON_DEFAULT);
    _locationIconView.L_ImageName(ICON_DEFAULT);
    _courseCountView.L_Text([NSString stringWithFormat:@"%@ 套",@"8"]);
    _locationView.L_Text(@"甘肃省，兰州市，麦积区");
}

@end
