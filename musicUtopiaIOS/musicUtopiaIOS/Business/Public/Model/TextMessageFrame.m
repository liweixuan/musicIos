#import "TextMessageFrame.h"

@implementation TextMessageFrame

-(id)initWithTextMessage:(TextMessageModel *)model {
    
    self = [super init];
    
    //进行相关位置计算
    if(self){
        
        //取出数据源
        self.textMessageModel = model;
        
        //判断是回复消息还是发送消息 1-发送 2-接收
        NSInteger messageDirection = self.textMessageModel.messageDirection;
        
        //发送或接收时间
        self.messageTimeFrame = CGRectMake(0,20,D_WIDTH,ATTR_FONT_SIZE);
        
        //设置头像
        if(messageDirection == 1){
            self.headerFrame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 40,CGRectGetMaxY(self.messageTimeFrame) + CONTENT_PADDING_TOP,40,40);
        }else{
            self.headerFrame = CGRectMake(CARD_MARGIN_LEFT,CGRectGetMaxY(self.messageTimeFrame) + CONTENT_PADDING_TOP,40,40);
        }
        
        //聊天气泡
        
        //计算内容大小
        NSString * contentStr = self.textMessageModel.messageStr;
        CGSize contentSize = [G labelAutoCalculateRectWith:contentStr FontSize:SUBTITLE_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - 40*2 - ICON_MARGIN_CONTENT*2,1000)];
        
        if(contentSize.height <= 30){
            contentSize.height = CONTENT_FONT_SIZE;
        }
  
        
        if(messageDirection == 1){
            self.chatBubbleFrame = CGRectMake(D_WIDTH - CARD_MARGIN_LEFT-ICON_MARGIN_CONTENT - 40 - contentSize.width - 30,CGRectGetMinY(self.headerFrame),contentSize.width+30,contentSize.height+20);
        }else{
            self.chatBubbleFrame = CGRectMake(CARD_MARGIN_LEFT + 40 +ICON_MARGIN_CONTENT ,CGRectGetMinY(self.headerFrame),contentSize.width+30,contentSize.height+20);
        }
        
        //聊天内容
        if(messageDirection == 1){
            self.chatContentFrame = CGRectMake(self.chatBubbleFrame.size.width/2 - contentSize.width/2 - 3,self.chatBubbleFrame.size.height/2 - contentSize.height/2 - 2,contentSize.width,contentSize.height);
        }else{
            self.chatContentFrame = CGRectMake(self.chatBubbleFrame.size.width/2 - contentSize.width/2 + 3,self.chatBubbleFrame.size.height/2 - contentSize.height/2 - 2,contentSize.width,contentSize.height);
        }

        //行高度
        self.cellHeight = self.chatBubbleFrame.size.height + self.messageTimeFrame.size.height + 50;
        
    }
    
    return self;
    
}

@end
