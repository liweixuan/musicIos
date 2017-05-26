#import "ImageMessageModel.h"

@implementation ImageMessageModel
-(instancetype)   initWithDict    :(NSDictionary *)dict {
    if (self = [super init]) {
        self.messageId          = [dict[@"messageId"] longValue];
        self.rcMessage        = dict[@"rcMessage"];
        self.messageSendUser    = dict[@"messageSendUser"];
        self.messageUrl       = dict[@"messageUrl"];
        self.messageDirection = [dict[@"messageDirection"] integerValue];
        self.messageImage     = dict[@"messageImage"];
        self.messageReceiveTime = [G formatData:[dict[@"messageReceiveTime"] integerValue] Format:@"MM-dd HH:mm"];
        
        
    }
    return self;
}

+(instancetype)ImageMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
