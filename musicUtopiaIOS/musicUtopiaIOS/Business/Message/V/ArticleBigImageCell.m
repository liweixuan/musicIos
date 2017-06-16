//
//  ArticleBigImageCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ArticleBigImageCell.h"

@interface ArticleBigImageCell()
{
    UIView      * _cellBox;
    UIImageView * _titleImage;
    UIView      * _titleBox;
    UILabel     * _title;
    UIImageView * _commentIcon;
    UILabel     * _commentCount;
}
@end

@implementation ArticleBigImageCell

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
            .L_radius(5)
            .L_AddView(self.contentView);
            
        }];
        
        _titleImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        _titleBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_BgColor([UIColor blackColor])
            .L_Alpha(0.6)
            .L_AddView(_cellBox);
        }];
        
        _title = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_numberOfLines(0)
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
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
            .L_TextColor([UIColor whiteColor])
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
    
    _titleBox.frame = CGRectMake(0, [_cellBox height] - 40,[_cellBox width],40);
    
    _titleImage.frame = CGRectMake(0, 0, [_cellBox width], [_cellBox height]);
    
    _title.frame = CGRectMake(CONTENT_PADDING_LEFT, [_cellBox height] - SUBTITLE_FONT_SIZE - CONTENT_PADDING_TOP, [_cellBox width ] - 60, SUBTITLE_FONT_SIZE);
    
    _commentCount.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 10 ,[_cellBox height] - SUBTITLE_FONT_SIZE - CONTENT_PADDING_TOP, 30,ATTR_FONT_SIZE);
    
    _commentIcon.frame = CGRectMake([_commentCount left] - SMALL_ICON_SIZE - ICON_MARGIN_CONTENT,[_cellBox height] - SUBTITLE_FONT_SIZE - CONTENT_PADDING_TOP, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * titleImage = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"a_title_image"]];
    _titleImage.L_ImageUrlName(titleImage,RECTANGLE_IMAGE_DEFAULT);
    
    _title.L_Text(dictData[@"a_title"]);
    
    _commentCount.L_Text([NSString stringWithFormat:@"%@",dictData[@"a_comment_count"]]);

}
@end
