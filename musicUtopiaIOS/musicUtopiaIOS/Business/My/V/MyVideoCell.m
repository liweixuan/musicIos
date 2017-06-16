//
//  MyVideoCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyVideoCell.h"

@interface MyVideoCell()
{
    UIView      * _cellBox;
    UIImageView * _videoTitleImage;
    UIImageView * _videoPlayIcon;
    UILabel     * _videoTitle;
    UIImageView * _deleteBtn;
}
@end

@implementation MyVideoCell

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
        
        _videoTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _deleteBtn = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_Event(YES)
            .L_Click(self,@selector(deleteBtnClick))
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
    
    _videoTitle.frame = CGRectMake(CONTENT_PADDING_LEFT,[_videoTitleImage bottom]+CONTENT_PADDING_TOP,[_videoTitleImage width]/2,SUBTITLE_FONT_SIZE);
    
    _deleteBtn.frame = CGRectMake([_cellBox width] - MIDDLE_ICON_SIZE - 12, [_cellBox height] - MIDDLE_ICON_SIZE - 10, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
    
}

-(void)setDictData:(NSDictionary *)dictData {

    NSString * videoUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"upv_image_url"]];
    
    _videoTitleImage.L_ImageUrlName(videoUrlStr,RECTANGLE_IMAGE_DEFAULT);
    _videoTitleImage.L_ImageMode(UIViewContentModeScaleAspectFill);
    
    _videoPlayIcon.L_ImageName(@"wh");
    
    _videoTitle.L_Text(dictData[@"upv_name"]);
    
}


-(void)deleteBtnClick {
    NSLog(@"删除...");
    [self.delegate deletePlayVideoBtn:self];
}


@end
