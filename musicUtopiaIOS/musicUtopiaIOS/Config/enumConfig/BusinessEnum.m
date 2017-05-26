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
    
    if([cname isEqualToString:@"民谣吉他"]){
        return @"c_minyaojita";
    }else if([cname isEqualToString:@"钢琴"]){
        return @"c_gangqin";
    }else if([cname isEqualToString:@"小提琴"]){
        return @"c_xiaotiqin";
    }else if([cname isEqualToString:@"二胡"]){
        return @"c_erhu";
    }else if([cname isEqualToString:@"大提琴"]){
        return @"c_datiqin";
    }else if([cname isEqualToString:@"古典吉他"]){
        return @"c_gudianjita";
    }else if([cname isEqualToString:@"电声吉他"]){
        return @"c_dianjita";
    }else if([cname isEqualToString:@"综合"]){
        return @"c_zonghe";
    }else if([cname isEqualToString:@"小号"]){
        return @"c_xiaohao";
    }else if([cname isEqualToString:@"电声贝斯"]){
        return @"c_dianbeisi";
    }else if([cname isEqualToString:@"长笛"]){
        return @"c_changdi";
    }else if([cname isEqualToString:@"萨克斯管"]){
        return @"c_sakesi";
    }else if([cname isEqualToString:@"单簧管"]){
        return @"c_danhuangguan";
    }else if([cname isEqualToString:@"口琴"]){
        return @"c_kouqin";
    }else if([cname isEqualToString:@"尤克里里"]){
        return @"c_youkelili";
    }else if([cname isEqualToString:@"架子鼓"]){
        return @"c_jiazigu";
    }else{
        return ICON_DEFAULT;
    }
    
    
}

+(NSString *)getSexIcon:(NSInteger)sex {
    
    if(sex == 0){
        return @"sex_nan";
    }else if(sex == 1){
        return @"sex_nv";
    }else if(sex == 2){
        return @"sex_baomi";
    }else{
        return @"sex_baomi";
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
