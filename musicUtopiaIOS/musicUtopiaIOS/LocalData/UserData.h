//
//  UserData.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject
//判断用户是否登录
+(BOOL)UserIsLogin;

//保存用户信息
+(void)saveUserInfo:(NSDictionary *)dict;

//获取用户信息
+(NSDictionary *)getUserInfo;

//获取当前登录用户的ID
+(NSInteger)getUserId;

//获取当前登录用户的帐号
+(NSString *)getUsername;

//获取用户信息
+(void)removeUserInfo;

//获取融云TOKEN
+(NSString *)getRongCloudToken;

//清除融云TOKEN
+(void)removeRongCloudToken;

//保存融云TOKEN
+(void)saveRongCloudToken:(NSString *)rongCloudToken;

//保存用户的当前位置坐标
+(void)saveUserLocation:(NSString *)location;

//获取当前用户的位置坐标
+(NSDictionary *)getUserLocation;
@end
