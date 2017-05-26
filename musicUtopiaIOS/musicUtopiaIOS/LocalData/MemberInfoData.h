//
//  MemberInfoData.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoData : NSObject

//获取会员信息
+(void)getMemberInfo:(NSString *)username MemberEnd:(void(^)(NSDictionary * memberInfo))rsBlock;


@end
