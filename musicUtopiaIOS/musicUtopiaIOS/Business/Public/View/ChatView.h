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
#import "RadioMessageCell.h"

@protocol ChatViewDelegate <NSObject>

//发送文本消息
-(void)sendTextMessage:(NSString *)messageStr;

//发送图片消息
-(void)sendImageMessage:(NSArray *)images;

//发送语音消息
-(void)sendRadioMessage:(NSData *)radioData TimeLength:(NSInteger)length;

//进入视频录制界面
-(void)goVideoRecord;

//获取历史消息
-(void)getHistoryMessage;


@end

@interface ChatView : Base_UIView
@property(nonatomic,strong)NSArray * messageData; //新增消息数据
@property(nonatomic,strong)NSArray * historyData; //历史消息数据
@property(nonatomic,strong)id<ChatViewDelegate> delegate;




@end
