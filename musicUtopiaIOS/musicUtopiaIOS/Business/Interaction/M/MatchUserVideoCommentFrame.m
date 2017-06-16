//
//  MatchUserVideoCommentFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchUserVideoCommentFrame.h"

@implementation MatchUserVideoCommentFrame
-(instancetype)initWithMatchUserVideoComment:(NSDictionary *)dictData {
    
    self = [super init];
    if(self){
        
        self.matchUserVideoCommentDict = dictData;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //头像
        self.headerFrame = CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP,30,30);
        
        self.nicknameFrame = CGRectMake(CGRectGetMaxX(self.headerFrame) + CONTENT_PADDING_LEFT,CGRectGetMinY(self.headerFrame) + 8, 200,CONTENT_FONT_SIZE);
        
        //日期
        self.timeFrame = CGRectMake(cardWidth - 80 - CONTENT_PADDING_LEFT, CGRectGetMinY(self.nicknameFrame), 80,ATTR_FONT_SIZE);
        
        //内容
        NSString * content = dictData[@"mvc_content"];
        CGSize contentSize = [G labelAutoCalculateRectWith:content FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(cardWidth - CGRectGetMinX(self.nicknameFrame), 1000)];
        self.contentFrame = CGRectMake(CGRectGetMinX(self.nicknameFrame), CGRectGetMaxY(self.nicknameFrame)+CONTENT_PADDING_TOP, cardWidth - CGRectGetMinX(self.nicknameFrame), contentSize.height);
        
       self.cellHeight = CGRectGetMaxY(self.contentFrame) + 15;
        
    }
    return self;
}
@end
