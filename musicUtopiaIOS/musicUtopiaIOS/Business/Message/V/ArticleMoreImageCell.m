//
//  ArticleMoreImageCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ArticleMoreImageCell.h"

@interface ArticleMoreImageCell()
{
    UIView  * _cellBox;
    UILabel * _title;
    UIView  * _imageBox;
    UIImageView * _imageOne;
    UIImageView * _imageTwo;
    UIImageView * _imageThree;
    UILabel     * _time;
    UIImageView * _commentIcon;
    UILabel     * _commentCount;
    
}
@end

@implementation ArticleMoreImageCell

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
        
        _title = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_numberOfLines(0)
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _imageBox = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _imageOne = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_imageBox);
        }];
        
        _imageTwo = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_imageBox);
        }];
        
        _imageThree = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_imageBox);
        }];
        
        _time = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _commentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
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
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,5,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - 5*2);
    
    _title.frame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, [_cellBox width], SUBTITLE_FONT_SIZE);
    
    _imageBox.frame = CGRectMake(CONTENT_PADDING_LEFT, [_title bottom]+CONTENT_PADDING_TOP, [_cellBox width] - CONTENT_PADDING_LEFT * 2, 80);
    
    CGFloat imageItemW = [_imageBox width] / 3 - 5;
    _imageOne.frame = CGRectMake(0,0,imageItemW,[_imageBox height]);
    
    _imageTwo.frame = CGRectMake(imageItemW+7.5,0,imageItemW,[_imageBox height]);
    
    _imageThree.frame = CGRectMake(imageItemW * 2+15,0,imageItemW,[_imageBox height]);
    
    _time.frame =  CGRectMake(CONTENT_PADDING_LEFT, [_imageBox bottom]+10, 100,ATTR_FONT_SIZE);
    
    _commentCount.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 30 , [_time top], 30,ATTR_FONT_SIZE);
    
    _commentIcon.frame = CGRectMake([_commentCount left] - SMALL_ICON_SIZE - ICON_MARGIN_CONTENT, [_time top], SMALL_ICON_SIZE, SMALL_ICON_SIZE);
}

-(void)setDictData:(NSDictionary *)dictData {
    
    _title.L_Text(dictData[@"title"]);
    
    NSArray * images = dictData[@"image"];
    _imageOne.L_ImageName(images[0][@"imageUrl"]);
    _imageTwo.L_ImageName(images[1][@"imageUrl"]);
    _imageThree.L_ImageName(images[2][@"imageUrl"]);
    
    _time.L_Text(@"2天前");
    
    _commentCount.L_Text(@"999");

    
}
@end
