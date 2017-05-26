//
//  RadioMessageModel.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioMessageModel.h"

@implementation RadioMessageModel
-(instancetype)   initWithDict    :(NSDictionary *)dict {
    if (self = [super init]) {
        self.messageId          = [dict[@"messageId"] longValue];
        self.rcMessage            = dict[@"rcMessage"];
        self.messageSendUser    = dict[@"messageSendUser"];
        self.radioData        = dict[@"radioData"];
        self.radioLength      = [dict[@"radioLength"] integerValue];
        self.messageDirection = [dict[@"messageDirection"] integerValue];
        self.messageReceiveTime = [G formatData:[dict[@"messageReceiveTime"] integerValue] Format:@"MM-dd HH:mm"];
        
        
    }
    return self;
}

+(instancetype)RadioMessageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
