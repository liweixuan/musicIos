//
//  ChatView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"
#import "TextMessageCell.h"
#import "ImageMessageCell.h"

@protocol ChatViewDelegate <NSObject>

//发送文本消息
-(void)sendTextMessage:(NSString *)messageStr;

//发送图片消息
-(void)sendImageMessage:(NSArray *)images;


@end

@interface ChatView : Base_UIView
@property(nonatomic,strong)NSArray * messageData; //消息数据
@property(nonatomic,strong)id<ChatViewDelegate> delegate;




@end
