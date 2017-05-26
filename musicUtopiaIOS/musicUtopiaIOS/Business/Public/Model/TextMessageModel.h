#import <Foundation/Foundation.h>


@interface TextMessageModel : NSObject
@property(nonatomic,assign)long        messageId;          //消息ID
@property(nonatomic,strong)NSString  * messageSendUser;    //消息发送者帐号
@property(nonatomic,strong)RCMessage * rcMessage;          //融云消息对象
@property(nonatomic,strong)NSString  * messageStr;         //文本消息内容
@property(nonatomic,assign)NSInteger   messageDirection;   //文本消息方向
@property(nonatomic,strong)NSString  * messageReceiveTime; //接收时间

-(instancetype)   initWithDict    :(NSDictionary *)dict;
+(instancetype)textMessageWithDict:(NSDictionary *)dict;
@end
