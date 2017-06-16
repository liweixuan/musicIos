//
//  RadioMessageFrame.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioMessageFrame.h"

@implementation RadioMessageFrame

-(id)initWithRadioMessage:(RadioMessageModel *)model {
    
    self = [super init];
    
    //进行相关位置计算
    if(self){
        
        //取出数据源
        self.radioMessageModel = model;
        
        //判断是回复消息还是发送消息 1-发送 2-接收
        NSInteger messageDirection = self.radioMessageModel.messageDirection;
        
        //发送或接收时间
        self.messageTimeFrame = CGRectMake(0,20,D_WIDTH,ATTR_FONT_SIZE);
        
        //设置头像
        if(messageDirection == 1){
            self.headerFrame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 40,CGRectGetMaxY(self.messageTimeFrame) + CONTENT_PADDING_TOP,40,40);
        }else{
            self.headerFrame = CGRectMake(CARD_MARGIN_LEFT,CGRectGetMaxY(self.messageTimeFrame) + CONTENT_PADDING_TOP,40,40);
        }
        
        //聊天气泡
        
        if(messageDirection == 1){
            self.chatBubbleFrame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT-ICON_MARGIN_CONTENT - 40 - D_WIDTH*0.2 - 10,CGRectGetMinY(self.headerFrame),D_WIDTH*0.2 + 10,40);
        }else{
            self.chatBubbleFrame = CGRectMake(CARD_MARGIN_LEFT + 40 +ICON_MARGIN_CONTENT,CGRectGetMinY(self.headerFrame),D_WIDTH*0.2 + 20,40);
        }
        
        //消息时长
        if(messageDirection == 1){
            self.messageLengthFrame = CGRectMake(-20,self.chatBubbleFrame.size.height/2 - ATTR_FONT_SIZE/2, 20,ATTR_FONT_SIZE);
        }else{
            self.messageLengthFrame = CGRectMake(self.chatBubbleFrame.size.width+10,self.chatBubbleFrame.size.height/2 - ATTR_FONT_SIZE/2, 20,ATTR_FONT_SIZE);
        }
        
        //语音播放图标
         if(messageDirection == 1){
             self.radioPlayerIconFrame = CGRectMake(self.chatBubbleFrame.size.width - 40,self.chatBubbleFrame.size.height/2 - 25/2,25,25);
         }else{
             self.radioPlayerIconFrame = CGRectMake(10,self.chatBubbleFrame.size.height/2 - 25/2,25,25);
         }
 
        //行高度
        self.cellHeight = self.chatBubbleFrame.size.height + self.messageTimeFrame.size.height + 50;
        
    }
    
    return self;
    
}

@end
