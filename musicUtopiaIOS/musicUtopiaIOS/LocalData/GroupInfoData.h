//
//  GroupInfoData.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfoData : NSObject

//获取群组信息
+(void)getGroupInfo:(NSString *)groupid GroupEnd:(void(^)(NSDictionary * groupInfo))rsBlock;


@end
