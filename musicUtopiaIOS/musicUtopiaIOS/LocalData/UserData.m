//
//  UserData.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserData.h"

@implementation UserData

//判断用户是否登录
+(BOOL)UserIsLogin {
    
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictData = [userDefaultes dictionaryForKey:@"userInfo"];
    if(dictData != nil){
        return YES;
    }
    
    return NO;
}

//保存用户信息
+(void)saveUserInfo:(NSDictionary *)dict {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:dict forKey:@"userInfo"];
 
}


+(NSInteger)getUserId {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictData = [userDefaultes dictionaryForKey:@"userInfo"];
    return [dictData[@"u_id"] integerValue];
}

+(NSString *)getUsername {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictData = [userDefaultes dictionaryForKey:@"userInfo"];
    return dictData[@"u_username"];
}

+(NSDictionary *)getUserInfo {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictData = [userDefaultes dictionaryForKey:@"userInfo"];
    return dictData;
}

+(void)removeUserInfo {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes removeObjectForKey:@"userInfo"];
}

+(NSString *)getRongCloudToken {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * tokenStr = [userDefaultes stringForKey:@"rongCloudToken"];
    return tokenStr;
}

+(void)saveRongCloudToken:(NSString *)rongCloudToken {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:rongCloudToken forKey:@"rongCloudToken"];
}

+(void)removeRongCloudToken {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes removeObjectForKey:@"rongCloudToken"];
}

+(void)saveUserLocation:(NSString *)location {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:location forKey:@"nowLocation"];
}

//获取当前用户的位置坐标
+(NSDictionary *)getUserLocation {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * lcStr = [userDefaultes stringForKey:@"nowLocation"];
    NSArray  * tempArr = [lcStr componentsSeparatedByString:@","];
    NSDictionary * lcDict = @{@"longitude":tempArr[0],@"latitude":tempArr[1]};
    return lcDict;
}
@end

