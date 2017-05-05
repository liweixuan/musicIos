#import <Foundation/Foundation.h>


@interface TextMessageModel : NSObject
@property(nonatomic,strong)RCMessage * rcMessage;      //融云消息对象

@property(nonatomic,strong)NSString  * tempMessageStr;       //临时测试用-文本消息内容
@property(nonatomic,assign)NSInteger   tempMessageDirection; //临时测试用-文本消息方向

-(instancetype)   initWithDict    :(NSDictionary *)dict;
+(instancetype)textMessageWithDict:(NSDictionary *)dict;
@end
