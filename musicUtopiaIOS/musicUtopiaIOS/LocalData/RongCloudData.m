//
//  RongCloudData.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RongCloudData.h"

@implementation RongCloudData

+(NSArray *)getConversationList {
    
    NSArray * conversations = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_SYSTEM)];
    NSArray * tempArr       = [[RCIMClient sharedRCIMClient] getConversationList:conversations];
    return tempArr;
}

//清除本地会话
+(BOOL)removeConversationList {
    
    NSArray * conversations = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_CHATROOM)];
    return [[RCIMClient sharedRCIMClient] clearConversations:conversations];
}

//删除指定会话
+(BOOL)removeTargetConversation:(NSString *)targetId ConversationType:(RCConversationType)type {
   BOOL isRmove = [[RCIMClient sharedRCIMClient] removeConversation:type targetId:targetId];
   return isRmove;
}

//获取未读消息总数
+(NSInteger)getUnMessageCount {
    return [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
}

//忽略所有未读消息
+(void)ignoreunAllMessage {
    
    NSArray * conversations = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_CHATROOM)];
    NSArray * tempArr       = [[RCIMClient sharedRCIMClient] getConversationList:conversations];
    
    for(int i =0;i<tempArr.count;i++){
        
        RCConversation * rcc = tempArr[i];
        
        if(rcc.unreadMessageCount > 0){
            
            //获取会话中的消息
            NSString * targetId = rcc.targetId;
            
            NSArray * messageArr = [[RCIMClient sharedRCIMClient] getLatestMessages:rcc.conversationType targetId:targetId count:100];

            //设置状态为已读
            for(int k = 0;k<messageArr.count;k++){
                
                RCMessage * message = messageArr[k];
                
                [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:message.messageId receivedStatus:ReceivedStatus_READ];
                
            }
            
        }

    }
    
}

//将某条消息的状态修改为已读
+(BOOL)readMessage:(long)messageId {
    return [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:messageId receivedStatus:ReceivedStatus_READ];
}

//将某个会话的消息状态修改为已读
+(void)readConversationAllMessage:(NSString *)targetId ConversationType:(RCConversationType)type {
    
    NSArray * messageArr = [[RCIMClient sharedRCIMClient] getLatestMessages:type targetId:targetId count:100];
    
    //设置状态为已读
    for(int k = 0;k<messageArr.count;k++){
        
        RCMessage * message = messageArr[k];
        
        [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:message.messageId receivedStatus:ReceivedStatus_READ];
        
    }
    
}

//获取当前会话的信息
+(NSArray *)getCoversationMessage:(NSString *)targetId ConversationType:(RCConversationType)type Count:(int)count {
    
    NSArray * tempArr = [[RCIMClient sharedRCIMClient] getLatestMessages:type targetId:targetId count:count];

    return tempArr;
    
}

//获取会话中，从指定消息之前、指定数量的最新消息实体
+(NSArray *)getCoversationHistroyMessage:(NSString *)targetId ConversationType:(RCConversationType)type oldestMessageId:(long)oldestMessageId Count:(int)count {
    
    NSArray * tempArr = [[RCIMClient sharedRCIMClient] getHistoryMessages:type targetId:targetId oldestMessageId:oldestMessageId count:count];
    return tempArr;
    
    
    
}

//清除某个会话消息
+(BOOL)removeConversationAllMessage:(NSString *)targetId ConversationType:(RCConversationType)type {
   return [[RCIMClient sharedRCIMClient] clearMessages:type targetId:targetId];
}
@end

