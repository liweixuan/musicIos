//
//  UserUpgradeVideoViewCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserUpgradeVideoViewCell.h"

@interface UserUpgradeVideoViewCell()
{
    UIView      * _cellBox;
    UIImageView * _videoTitleImage;
    UIImageView * _videoPlayIcon;
    UIImageView * _categoryIcon;
    UILabel     * _videoTitle;
    UILabel     * _createTime;
}
@end

@implementation UserUpgradeVideoViewCell

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
        
        _categoryIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_cellBox);
        }];
        
        _videoTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _createTime = [UILabel LabelinitWith:^(UILabel *la) {
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
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,5,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - 5*2);
    
    //视频图
    _videoTitleImage.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, [_cellBox width] - CONTENT_PADDING_LEFT * 2,[_cellBox height] - 40 - CONTENT_PADDING_TOP);
    
    //播放按钮
    _videoPlayIcon.frame = CGRectMake([_cellBox width]/2 - 50/2,[_cellBox height]/2 - 50/2 - 20, 50, 50);
    
    _categoryIcon.frame = CGRectMake(CONTENT_PADDING_LEFT, [_videoTitleImage bottom]+CONTENT_PADDING_TOP - 3, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
    
    _videoTitle.frame = CGRectMake([_categoryIcon right]+ICON_MARGIN_CONTENT,[_videoTitleImage bottom]+CONTENT_PADDING_TOP,[_videoTitleImage width]/2,SUBTITLE_FONT_SIZE);
    
    _createTime.frame = CGRectMake([_cellBox width] - 75, [_videoTitle top]+2, 70,ATTR_FONT_SIZE);

    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * videoUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"uuv_image_url"]];
    
    _videoTitleImage.L_ImageUrlName(videoUrlStr,RECTANGLE_IMAGE_DEFAULT);
    _videoTitleImage.L_ImageMode(UIViewContentModeScaleAspectFill);
    
    _videoPlayIcon.L_ImageName(@"wh");
    
    //获取当前类别名称
    NSDictionary * cDict = [BusinessEnum getCategoryId:[dictData[@"uuv_cid"] integerValue]];
    NSString * title = [NSString stringWithFormat:@"乐器类别：%@ - %@级",cDict[@"c_name"],dictData[@"uuv_level"]];
    _videoTitle.L_Text(title);
    
    _categoryIcon.L_ImageName(cDict[@"icon"]);
    
    _createTime.L_Text(@"2012/12/12");
    
}




@end
