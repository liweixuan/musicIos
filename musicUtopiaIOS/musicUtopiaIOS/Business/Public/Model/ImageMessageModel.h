//
//  ImageMessageModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMessageModel : NSObject
@property(nonatomic,assign)long        messageId;          //消息ID
@property(nonatomic,strong)NSString  * messageSendUser;    //消息发送者帐号
@property(nonatomic,strong)RCMessage * rcMessage;      //融云消息对象
@property(nonatomic,strong)NSString  * messageUrl;       //临时测试用-图片地址
@property(nonatomic,strong)UIImage   * messageImage;     //临时测试用-图片数据源
@property(nonatomic,assign)NSInteger   messageDirection; //临时测试用-图片消息方向
@property(nonatomic,strong)NSString  * messageReceiveTime; //接收时间

-(instancetype)   initWithDict    :(NSDictionary *)dict;
+(instancetype)ImageMessageWithDict:(NSDictionary *)dict;
@end
