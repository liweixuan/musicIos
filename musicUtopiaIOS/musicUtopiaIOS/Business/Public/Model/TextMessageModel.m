#import "TextMessageModel.h"

@implementation TextMessageModel
-(instancetype)   initWithDict    :(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.tempMessageStr       = dict[@"tempMessageStr"];
        self.tempMessageDirection = [dict[@"tempMessageDirection"] integerValue];
        
        
        
        
    }
    return self;
}

+(instancetype)textMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
