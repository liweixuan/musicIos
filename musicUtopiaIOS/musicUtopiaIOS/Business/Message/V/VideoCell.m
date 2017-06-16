//
//  VideoCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell()
{
    UIView      * _cellBox;
    UIImageView * _videoTitleImage;
    UIImageView * _videoPlayIcon;
    UILabel     * _videoTitle;
    UIView      * _actionView;
    UIImageView * _commentIcon;
    UILabel     * _commentText;
    UIImageView * _zanIcon;
    UILabel     * _zanText;
}
@end

@implementation VideoCell

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
        
        _videoTitleImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        _videoPlayIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        _videoPlayIcon.hidden = YES;
        
        _videoTitle = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _actionView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_AddView(_cellBox);
        }];
        
        _commentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_ImageName(@"pinglun")
            .L_AddView(_actionView);
        }];
        
        _commentText = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentLeft)
            .L_AddView(_actionView);
        }];
        
        _zanIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"dianzan")
            .L_AddView(_actionView);
        }];
        
        _zanText = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentLeft)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_actionView);
        }];
        
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,5,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - 5*2);
    
    //视频图
    _videoTitleImage.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, [_cellBox width] - CONTENT_PADDING_LEFT * 2,[_cellBox height] - 40 - CONTENT_PADDING_TOP);
    
    //播放按钮
    _videoPlayIcon.frame = CGRectMake([_cellBox width]/2 - 50/2,[_cellBox height]/2 - 50/2 - 25, 50, 50);
    
    _videoTitle.frame = CGRectMake(CONTENT_PADDING_LEFT,[_videoTitleImage bottom]+CONTENT_PADDING_TOP,[_videoTitleImage width]/2,SUBTITLE_FONT_SIZE);
    
    _actionView.frame = CGRectMake([_videoTitle right],[_videoTitle top],[_cellBox width]/2 - CONTENT_PADDING_LEFT,30);
    
    _commentIcon.frame = CGRectMake([_actionView width]/2,0,SMALL_ICON_SIZE, SMALL_ICON_SIZE);

    _commentText.frame = CGRectMake([_commentIcon right]+ICON_MARGIN_CONTENT ,0,40,ATTR_FONT_SIZE);

    _zanIcon.frame = CGRectMake([_commentText right],0,SMALL_ICON_SIZE, SMALL_ICON_SIZE);

    _zanText.frame = CGRectMake([_zanIcon right]+ICON_MARGIN_CONTENT,0,40,ATTR_FONT_SIZE);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * videoImage = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"v_title_image"]];
    [_videoTitleImage sd_setImageWithURL:[NSURL URLWithString:videoImage] placeholderImage:[UIImage imageNamed:RECTANGLE_IMAGE_DEFAULT] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _videoPlayIcon.hidden = NO;
    }];
    
    _videoPlayIcon.L_ImageName(@"wh");
    
    _videoTitle.L_Text(dictData[@"v_title"]);
    
    _commentText.L_Text([NSString stringWithFormat:@"%@",dictData[@"v_comment_count"]]);
    
    _zanText.L_Text([NSString stringWithFormat:@"%@",dictData[@"v_zan_count"]]);
    
}
@end
