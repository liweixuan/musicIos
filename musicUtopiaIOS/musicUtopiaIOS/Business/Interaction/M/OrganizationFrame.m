//
//  OrganizationFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrganizationFrame.h"

@implementation OrganizationFrame
-(instancetype)initWithOrganization:(OrganizationModel *)model {
    self = [super init];
    if(self){
        
        self.organizationModel = model;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //封面容器
        self.coverBoxFrame = CGRectMake(0,0,cardWidth, 250);
        
        //封面
        self.coverImageFrame = CGRectMake(0, 0, cardWidth, 250);
        
        //封面下内容容器
        self.coverContentFrame = CGRectMake(0,250-50,cardWidth,45);
        
        //创立时间图标
        self.createTimeIconFrame = CGRectMake(CONTENT_PADDING_LEFT,8, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //创立时间内容
        self.createTimeFrame = CGRectMake(CGRectGetMaxX(self.createTimeIconFrame) + ICON_MARGIN_CONTENT,CGRectGetMinY(self.createTimeIconFrame), 200,ATTR_FONT_SIZE);
        
        //所在地点图标
        self.locationIconFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.createTimeIconFrame)+6, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //所在地点内容
        self.loctionFrame = CGRectMake(CGRectGetMaxX(self.locationIconFrame) + ICON_MARGIN_CONTENT,CGRectGetMinY(self.locationIconFrame), 200,ATTR_FONT_SIZE);

        
        //内容容器
        self.organizationBoxFrame = CGRectMake(0,CGRectGetMaxY(self.coverBoxFrame) - 5,cardWidth,60);
        
        //团体名称图标
        self.nameIconFrame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE);
       
        //团体内容
        self.nameFrame = CGRectMake(CGRectGetMaxX(self.nameIconFrame)+ICON_MARGIN_CONTENT,CGRectGetMinY(self.nameIconFrame) - 2, cardWidth - 100 - SMALL_ICON_SIZE, TITLE_FONT_SIZE);
        
        
        //团体人数图标
        self.userCountIconFrame = CGRectMake(cardWidth - 40,CGRectGetMinY(self.nameIconFrame),SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //团体人数
        self.userCountFrame = CGRectMake(CGRectGetMaxX(self.userCountIconFrame) + ICON_MARGIN_CONTENT,CGRectGetMinY(self.nameFrame),60, SUBTITLE_FONT_SIZE);
        
        //座右铭
        self.mottoFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.nameFrame)+20,cardWidth,SUBTITLE_FONT_SIZE);
      
        self.cellHeight = 340;
        
    }
    return self;
}
@end
