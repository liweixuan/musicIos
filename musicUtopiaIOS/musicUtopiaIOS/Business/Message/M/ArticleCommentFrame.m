//
//  ArticleCommentFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ArticleCommentFrame.h"

@implementation ArticleCommentFrame

-(instancetype)initWithArticleComment:(NSDictionary *)dictData {
    
    self = [super init];
    if(self){
        
        self.articleCommentDict = dictData;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //头像
        self.headerFrame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP,30,30);
        
        self.nicknameFrame = CGRectMake(CGRectGetMaxX(self.headerFrame) + CONTENT_PADDING_LEFT,CGRectGetMinY(self.headerFrame) + 8, 200,CONTENT_FONT_SIZE);
        
        //日期
        self.timeFrame = CGRectMake(cardWidth - 80 - CONTENT_PADDING_LEFT, CGRectGetMinY(self.nicknameFrame), 80,ATTR_FONT_SIZE);
        
        //内容
        NSString * content = dictData[@"ac_content"];
        CGSize contentSize = [G labelAutoCalculateRectWith:content FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(cardWidth - CGRectGetMinX(self.nicknameFrame)-10, 1000)];
        self.contentFrame = CGRectMake(CGRectGetMinX(self.nicknameFrame), CGRectGetMaxY(self.nicknameFrame)+CONTENT_PADDING_TOP, cardWidth - CGRectGetMinX(self.nicknameFrame)-10, contentSize.height);
        
        //操作容器
        self.actionFrame = CGRectMake(cardWidth - 120, CGRectGetMaxY(self.contentFrame)+10, 120,30);
        
        //回复图标
        self.replyIconFrame = CGRectMake(0, self.actionFrame.size.height/2 - SMALL_ICON_SIZE/2 ,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        self.replyTitleFrame = CGRectMake(CGRectGetMaxX(self.replyIconFrame)+ICON_MARGIN_CONTENT,0,40,self.actionFrame.size.height );
        
        self.zanIconFrame = CGRectMake(CGRectGetMaxX(self.replyTitleFrame)+15, self.actionFrame.size.height/2 - SMALL_ICON_SIZE/2 ,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        self.zanCountFrame = CGRectMake(CGRectGetMaxX(self.zanIconFrame)+ICON_MARGIN_CONTENT,0,40,self.actionFrame.size.height);
        
        self.cellHeight = CGRectGetMaxY(self.actionFrame) + 10;
        
    }
    return self;
}

@end
