#import "ImageMessageModel.h"

@implementation ImageMessageModel
-(instancetype)   initWithDict    :(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.tempMessageUrl       = dict[@"tempMessageUrl"];
        self.tempMessageDirection = [dict[@"tempMessageDirection"] integerValue];
        self.tempMessageImage     = dict[@"tempMessageImage"];
  
        
    }
    return self;
}

+(instancetype)ImageMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
