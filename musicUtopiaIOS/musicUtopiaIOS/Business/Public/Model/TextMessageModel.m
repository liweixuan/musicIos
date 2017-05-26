#import "TextMessageModel.h"

@implementation TextMessageModel
-(instancetype)   initWithDict    :(NSDictionary *)dict {
    if (self = [super init]) {
        self.messageId          = [dict[@"messageId"] longValue];
        self.rcMessage          = dict[@"rcMessage"];
        self.messageStr         = dict[@"messageStr"];
        self.messageSendUser    = dict[@"messageSendUser"];
        self.messageDirection   = [dict[@"messageDirection"] integerValue];
        self.messageReceiveTime = [G formatData:[dict[@"messageReceiveTime"] integerValue] Format:@"MM-dd HH:mm"];
  
    }
    return self;
}

+(instancetype)textMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
