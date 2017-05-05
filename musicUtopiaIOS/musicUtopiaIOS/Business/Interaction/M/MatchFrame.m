//
//  MatchFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchFrame.h"

@implementation MatchFrame
-(instancetype)initWithMatch:(MatchModel *)model {
    
    self = [super init];
    if(self){
        
        self.matchModel = model;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //赛事图片
        self.matchCoverFrame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, 100,100);
        
        //赛事类别
        self.matchTypeFrame  = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP + 100 - 30,100,30);
        
        //曲目名称
        self.matchNameFrame = CGRectMake(CGRectGetMaxX(self.matchCoverFrame)+CONTENT_MARGIN_LEFT,CGRectGetMinY(self.matchCoverFrame),cardWidth - CGRectGetMaxX(self.matchCoverFrame) - 100,TITLE_FONT_SIZE);
        
        //参与人数
        self.matchInvolvementCountFrame = CGRectMake(CGRectGetMaxX(self.matchNameFrame)+10, CGRectGetMinY(self.matchCoverFrame), 80,ATTR_FONT_SIZE);
        
        //类别图标
        self.matchCategoryIconFrame = CGRectMake(CGRectGetMaxX(self.matchCoverFrame)+CONTENT_MARGIN_LEFT, CGRectGetMaxY(self.matchNameFrame) + CONTENT_PADDING_TOP, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
        
        //类别
        self.matchCategoryFrame = CGRectMake(CGRectGetMaxX(self.matchCategoryIconFrame)+10, CGRectGetMinY(self.matchCategoryIconFrame), 100,MIDDLE_ICON_SIZE);
        
        //开始时间
        self.matchStartTimeFrame = CGRectMake(CGRectGetMaxX(self.matchCoverFrame)+CONTENT_MARGIN_LEFT, CGRectGetMaxY(self.matchCategoryIconFrame) + CONTENT_PADDING_TOP, 150,CONTENT_FONT_SIZE);
        
        //结束时间
        self.matchEndTimeFrame = CGRectMake(CGRectGetMaxX(self.matchCoverFrame)+CONTENT_MARGIN_LEFT, CGRectGetMaxY(self.matchStartTimeFrame) + CONTENT_PADDING_TOP, 150,CONTENT_FONT_SIZE);
  
        //去投票
        self.matchVoteFrame = CGRectMake(cardWidth - 65, CGRectGetMaxY(self.matchCategoryIconFrame), 50,50);
        
        //分割线
        self.middleLineFrame = CGRectMake(0, CGRectGetMaxY(self.matchCoverFrame) + CONTENT_PADDING_TOP, cardWidth , 1);
        
        //状态按钮
        self.matchStatusFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.middleLineFrame) + CONTENT_PADDING_TOP, 60 , 30);
        
        //操作按钮
        self.matchActionFrame = CGRectMake(cardWidth - CONTENT_PADDING_LEFT - 80, CGRectGetMaxY(self.middleLineFrame) + CONTENT_PADDING_TOP, 80 , 30);
        
        self.cellHeight = 200;
        
        
    }
    return self;
}
@end
