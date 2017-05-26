//
//  RongCloudData.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongCloudData : NSObject

//获取会话消息
+(NSArray *)getConversationList;

//清除本地会话
+(BOOL)removeConversationList;

//删除指定会话
+(BOOL)removeTargetConversation:(NSString *)targetId ConversationType:(RCConversationType)type;

//获取未读消息总数
+(NSInteger)getUnMessageCount;

//忽略所有未读消息
+(void)ignoreunAllMessage;

//将某个会话的消息状态修改为已读
+(void)readConversationAllMessage:(NSString *)targetId ConversationType:(RCConversationType)type;

//将某条消息接收的状态修改为已读
+(BOOL)readMessage:(long)messageId;

//获取某个会话中指定数量的最新消息实体
+(NSArray *)getCoversationMessage:(NSString *)targetId ConversationType:(RCConversationType)type Count:(int)count;

//获取会话中，从指定消息之前、指定数量的最新消息实体
+(NSArray *)getCoversationHistroyMessage:(NSString *)targetId ConversationType:(RCConversationType)type oldestMessageId:(long)oldestMessageId Count:(int)count;

//清除某个会话消息
+(BOOL)removeConversationAllMessage:(NSString *)targetId ConversationType:(RCConversationType)type;
@end
