//
//  BusinessEnum.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessEnum : NSObject

//性别字符串转化
+(NSString *)getSex:(NSInteger)sex;

//性别转化为相应图标
+(NSString *)getSexIcon:(NSInteger)sex;

//乐器类别转化相应图标
+(NSString *)getCategoryIcon:(NSString *)cname;

//空对象向空字符串转化(防闪退)
+(NSString *)getEmptyString:(NSString *)v;

//比赛类型转化为相应内容
+(NSString *)getMatchTypeString:(NSInteger)type;

@end
