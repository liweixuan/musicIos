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

+(NSDictionary *)getCategoryId:(NSInteger)cid {
    
    if(cid == 9){
        return @{@"icon":@"cc_minyaojita",@"c_id":@(9) ,@"c_name":@"民谣吉他"};
    }else if(cid == 10){
        return @{@"icon":@"cc_gangqin",@"c_id":@(10),@"c_name":@"钢琴"};
    }else if(cid == 11){
        return @{@"icon":@"cc_xiaotiqin",@"c_id":@(11),@"c_name":@"小提琴"};
    }else if(cid == 12){
        return @{@"icon":@"cc_erhu",@"c_id":@(12),@"c_name":@"二胡"};
    }else if(cid == 16){
        return @{@"icon":@"cc_datiqin",@"c_id":@(16),@"c_name":@"大提琴"};
    }else if(cid == 19){
        return @{@"icon":@"cc_gudianjita",@"c_id":@(19),@"c_name":@"古典吉他"};
    }else if(cid == 20){
        return @{@"icon":@"cc_dianjita",@"c_id":@(20),@"c_name":@"电声吉他"};
    }else if(cid == 22){
        return @{@"icon":@"cc_xiaohao",@"c_id":@(22),@"c_name":@"小号"};
    }else if(cid == 23){
        return @{@"icon":@"cc_dianbeisi",@"c_id":@(23),@"c_name":@"电声贝斯"};
    }else if(cid == 24){
        return @{@"icon":@"cc_changdi",@"c_id":@(24),@"c_name":@"长笛"};
    }else if(cid == 25){
        return @{@"icon":@"cc_sakesi",@"c_id":@(25),@"c_name":@"萨克斯管"};
    }else if(cid == 26){
        return @{@"icon":@"cc_danhuangguan",@"c_id":@(26),@"c_name":@"单簧管"};
    }else if(cid == 27){
        return @{@"icon":@"cc_kouqin",@"c_id":@(27),@"c_name":@"口琴"};
    }else if(cid == 28){
        return @{@"icon":@"cc_youkelili",@"c_id":@(28),@"c_name":@"尤克里里"};
    }else if(cid == 29){
        return @{@"icon":@"cc_jiazigu",@"c_id":@(29),@"c_name":@"架子鼓"};
    }
    
    return nil;
    
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

+(NSString *)getMusicScoreTypeString:(NSInteger)type {
    
    if(type == 0){
        return @"乐曲";
    }else if(type == 1){
        return @"弹唱";
    }else if(type == 2){
        return @"指弹";
    }else if(type == 3){
        return @"合奏";
    }else if(type == 4){
        return @"二重奏";
    }else if(type == 5){
        return @"乐队";
    }else{
        return @"";
    }
    
    return @"";
    
}

@end
