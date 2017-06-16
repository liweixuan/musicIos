//
//  PartnerFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PartnerFrame.h"

@implementation PartnerFrame

-(instancetype)initWithPartner:(PartnerModel *)model {
    
    self = [super init];
    if(self){
        
        //数据源赋值
        self.partnerModel = model;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //头像位置
        self.headerUrlFrame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,HEADER_SIZE,HEADER_SIZE);
        
        
        //性别图标位置
        self.sexIconFrame = CGRectMake(CGRectGetMaxX(self.headerUrlFrame) + CONTENT_MARGIN_LEFT,CGRectGetMinY(self.headerUrlFrame) + 10,SMALL_ICON_SIZE,SMALL_ICON_SIZE);
        
        //性别内容
        self.sexFrame = CGRectMake(CGRectGetMaxX(self.sexIconFrame)+ICON_MARGIN_CONTENT, CGRectGetMinY(self.sexIconFrame),30,ATTR_FONT_SIZE);
        
        //用户昵称
        CGSize nicknameSize = [G labelAutoCalculateRectWith:self.partnerModel.nickname FontSize:TITLE_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH,1000)];
        self.nickNameFrame = CGRectMake(CGRectGetMaxX(self.sexFrame),CGRectGetMinY(self.sexIconFrame)-2,nicknameSize.width,TITLE_FONT_SIZE);

        //位置图标
        self.locationIconFrame = CGRectMake(CGRectGetMinX(self.sexIconFrame), CGRectGetMaxY(self.sexIconFrame)+CONTENT_PADDING_TOP,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //位置信息
        CGSize locationSize = [G labelAutoCalculateRectWith:self.partnerModel.location FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH,1000)];
        self.locationFrame = CGRectMake(CGRectGetMaxX(self.locationIconFrame)+ICON_MARGIN_CONTENT, CGRectGetMinY(self.locationIconFrame),locationSize.width,ATTR_FONT_SIZE);
        
        
        //标题
        self.titleFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.headerUrlFrame)+CONTENT_MARGIN_TOP, cardWidth - CONTENT_PADDING_LEFT * 2,TITLE_FONT_SIZE);
        
      
        //内容
        CGSize contentSize = [G labelAutoCalculateRectWith:self.partnerModel.partnerDesc FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(cardWidth - CONTENT_PADDING_LEFT *2, 1000)];
        
        //判断如果没有内容，将content的高度设置为0
        if(contentSize.width<=0){ contentSize.height = 0.0; }
        self.contentFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.titleFrame) + CONTENT_MARGIN_TOP,cardWidth - CONTENT_PADDING_LEFT*2,contentSize.height);
        
        //伙伴要求图标
        self.askIconFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.contentFrame) + CONTENT_MARGIN_TOP, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //伙伴要求文字
        self.askFrame = CGRectMake(CGRectGetMaxX(self.askIconFrame)+ICON_MARGIN_CONTENT, CGRectGetMinY(self.askIconFrame), 100,ATTR_FONT_SIZE);
        
        //要求内容容器
        CGFloat askContentHeight = 0.0;
        
        if(self.partnerModel.partnerAsk.length > 0){
            
            NSArray *asks = [self.partnerModel.partnerAsk componentsSeparatedByString:@"|"];
            
            CGFloat askItemHeight = 24;
            
            //计算内容高度
            askContentHeight = asks.count * askItemHeight;

        }


        self.askContentBoxFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.askIconFrame) + CONTENT_MARGIN_TOP, cardWidth - CONTENT_PADDING_LEFT*2,askContentHeight);

        CGFloat tagBoxH = 0.0;
        if(self.partnerModel.partnerTags.length > 0){
            tagBoxH = 40;
        }
        //标签容器
        self.tagBoxFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.askContentBoxFrame) + 5,cardWidth - CONTENT_PADDING_LEFT * 2, tagBoxH);

        
        //操作容器
//        self.actionBoxFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.askContentBoxFrame) + CONTENT_MARGIN_TOP, cardWidth - CONTENT_PADDING_LEFT*2, 50);
 
        self.cellHeight = CGRectGetMaxY(self.tagBoxFrame) + 15;
        
        
    }
    
    return self;
    
    
}

@end
