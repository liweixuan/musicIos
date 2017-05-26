//
//  RadioMessageModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioMessageModel : NSObject
@property(nonatomic,strong)RCMessage * rcMessage;      //融云消息对象
@property(nonatomic,assign)long        messageId;          //消息ID
@property(nonatomic,strong)NSString  * messageSendUser;    //消息发送者帐号
@property(nonatomic,strong)NSData  * radioData;         //临时测试用-语音内容
@property(nonatomic,assign)NSInteger radioLength;       //临时测试用-语音时长
@property(nonatomic,assign)NSInteger messageDirection; //临时测试用-语音消息方向
@property(nonatomic,strong)NSString  * messageReceiveTime; //接收时间

-(instancetype)   initWithDict    :(NSDictionary *)dict;
+(instancetype)RadioMessageWithDict:(NSDictionary *)dict;
@end
