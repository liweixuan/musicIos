//
//  BusinessEnum.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BusinessEnum.h"

@implementation BusinessEnum

+(NSString *)getCategoryIcon:(NSString *)cname {
    
    if([cname isEqualToString:@"古典吉他"]){
        return ICON_DEFAULT;
    }else if([cname isEqualToString:@"民谣吉他"]){
        return ICON_DEFAULT;
    }else if([cname isEqualToString:@"电声吉他"]){
        return ICON_DEFAULT;
    }else if([cname isEqualToString:@"小提琴"]){
        return ICON_DEFAULT;
    }else{
        return ICON_DEFAULT;
    }
    
    
}

+(NSString *)getSexIcon:(NSInteger)sex {
    
    if(sex == 0){
        return ICON_DEFAULT;
    }else if(sex == 1){
        return ICON_DEFAULT;
    }else if(sex == 2){
        return ICON_DEFAULT;
    }else{
        return ICON_DEFAULT;
    }
    
}

+(NSString *)getSex:(NSInteger)sex {
    
    if(sex == 0){
        return @"男";
    }else if(sex == 1){
        return @"女";
    }else if(sex == 2){
        return @"保密";
    }else{
        return @"未知";
    }
}

+(NSString *)getEmptyString:(NSString *)v {
    
    if(v == nil){
        return @"";
    }else if([v isEqual:[NSNull null]]){
        return @"";
    }else if([v isEqualToString:@"0"]){
        return @"";
    }else{
        return v;
    }
    
}

+(NSString *)getMatchTypeString:(NSInteger)type {
    
    if(type == 0){
        return @"周赛";
    }else if(type == 1){
        return @"月赛";
    }else{
        return @"季赛";
    }
    
    return @"";
    
}

@end
