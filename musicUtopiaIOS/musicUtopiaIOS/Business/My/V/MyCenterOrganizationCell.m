//
//  MyCenterOrganizationCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyCenterOrganizationCell.h"

@interface MyCenterOrganizationCell()
{
    UIView      * _cellBox;
    UIView      * _coverBoxView;
    UIImageView * _coverImageView;
//    UIView      * _coverContentView;
//    UIImageView * _createTimeIconView;
//    UILabel     * _createTimeView;
//    UIImageView * _locationIconView;
//    UILabel     * _locationView;
    UIImageView * _nameIconView;
    UILabel     * _nameView;
    UIImageView * _userCountIconView;
    UILabel     * _userCountView;
    
    UIView      * _organizationBoxView;
}
@end

@implementation MyCenterOrganizationCell

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
        
        _coverBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        
        _coverImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_AddView(_coverBoxView);
        }];
        
        
        _organizationBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
//        _coverContentView = [UIView ViewInitWith:^(UIView *view) {
//            view
//            .L_BgColor([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha: 0.5])
//            .L_AddView(_cellBox);
//        }];
//        
//        
//        _createTimeIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//            imgv
//            .L_ImageName(@"tuantishijian")
//            .L_AddView(_coverContentView);
//        }];
//        
//        _createTimeView = [UILabel LabelinitWith:^(UILabel *la) {
//            la
//            .L_Font(ATTR_FONT_SIZE)
//            .L_TextColor([UIColor whiteColor])
//            .L_AddView(_coverContentView);
//        }];
//        
//        _locationIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//            imgv
//            .L_ImageName(@"tuantididian")
//            .L_AddView(_coverContentView);
//        }];
//        
//        _locationView = [UILabel LabelinitWith:^(UILabel *la) {
//            la
//            .L_Font(ATTR_FONT_SIZE)
//            .L_TextColor([UIColor whiteColor])
//            .L_AddView(_coverContentView);
//        }];
        
        _nameIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"tuantimingcheng")
            .L_AddView(_organizationBoxView);
        }];
        
        _nameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_organizationBoxView);
        }];
        
        _userCountIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"chengyuanshuliang")
            .L_AddView(_organizationBoxView);
        }];
        
        _userCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_organizationBoxView);
        }];
        
        
    }
    
    return self;
    
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,CARD_MARGIN_TOP,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - CARD_MARGIN_TOP);
}


-(void)setOrganizationFrame:(OrganizationFrame *)organizationFrame {
    
    //数据对象
    OrganizationModel * dataModel = (OrganizationModel *)organizationFrame.organizationModel;
    
    //封面容器
    _coverBoxView.frame = organizationFrame.coverBoxFrame;
    
    
    //封面
    _coverImageView.frame = organizationFrame.coverImageFrame;
    NSString * coverImage = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dataModel.organizationCover];
    _coverImageView.L_ImageUrlName(coverImage,RECTANGLE_IMAGE_DEFAULT);
    
//    //封面下内容容器
//    _coverContentView.frame = organizationFrame.coverContentFrame;
//    
//    //创建时间图标
//    _createTimeIconView.frame = organizationFrame.createTimeIconFrame;
//    
//    //创建时间内容
//    _createTimeView.frame = organizationFrame.createTimeFrame;
//    _createTimeView.L_Text(dataModel.organizationCreateTime);
//    
//    //地点图标
//    _locationIconView.frame = organizationFrame.locationIconFrame;
    
//    //地点内容
//    _locationView.frame = organizationFrame.loctionFrame;
//    _locationView.L_Text(dataModel.location);
    
    //团体图标
    _nameIconView.frame = organizationFrame.nameIconFrame;
    
    //团体内容
    _nameView.frame = organizationFrame.nameFrame;
    _nameView.L_Text(dataModel.organizationName);
    
    //人数图标
    _userCountIconView.frame = organizationFrame.userCountIconFrame;
    
    //人数
    _userCountView.frame = organizationFrame.userCountFrame;
    _userCountView.L_Text([NSString stringWithFormat:@"%ld",(long)dataModel.organizationUserCount]);

    //内容容器
    _organizationBoxView.frame = organizationFrame.organizationBoxFrame;
    [_organizationBoxView setHeight:[_organizationBoxView height] - 22];
    _organizationBoxView.backgroundColor = [UIColor whiteColor];
    _organizationBoxView.L_raius_location(UIRectCornerBottomLeft|UIRectCornerBottomRight,5);
    
    
}

@end
