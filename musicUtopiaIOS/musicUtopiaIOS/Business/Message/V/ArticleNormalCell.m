//
//  ArticleNormalCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ArticleNormalCell.h"

@interface ArticleNormalCell()
{
    UIView  * _cellBox;
    UIImageView * _titleImage;
    UILabel     * _title;
    UILabel     * _time;
    UIImageView * _commentIcon;
    UILabel     * _commentCount;
}
@end

@implementation ArticleNormalCell

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
        
        _titleImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        _title = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_numberOfLines(2)
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _time = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _commentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_ImageName(@"pinglun")
            .L_AddView(_cellBox);
        }];
        
        _commentCount = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,5,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - 7);
    
    _titleImage.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, 90,[_cellBox height] - CONTENT_PADDING_TOP * 2);
    
    _title.frame = CGRectMake([_titleImage right] + CONTENT_PADDING_LEFT,[_titleImage top]+3,[_cellBox width] - [_titleImage right] - CONTENT_PADDING_LEFT*2,SUBTITLE_FONT_SIZE*2);
    [_title sizeToFit];
    
    _time.frame = CGRectMake([_titleImage right]+CONTENT_PADDING_LEFT, [_cellBox height] - ATTR_FONT_SIZE - CONTENT_PADDING_TOP - 3, 100, ATTR_FONT_SIZE);
    
    _commentCount.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 15 , [_time top], 30,ATTR_FONT_SIZE);
    
    _commentIcon.frame = CGRectMake([_commentCount left] - SMALL_ICON_SIZE - ICON_MARGIN_CONTENT, [_time top], SMALL_ICON_SIZE, SMALL_ICON_SIZE);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * titleImage = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"a_title_image"]];
    _titleImage.L_ImageUrlName(titleImage,RECTANGLE_IMAGE_DEFAULT);
    
    _title.L_Text(dictData[@"a_title"]);
    
    NSString * timeStr = [G formatData:[dictData[@"a_create_time"] integerValue] Format:@"MM-dd"];
    _time.L_Text(timeStr);
    
    _commentCount.L_Text([NSString stringWithFormat:@"%@",dictData[@"a_comment_count"]]);
}
@end
