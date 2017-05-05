//
//  PartnerModel.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PartnerModel.h"

@implementation PartnerModel
-(instancetype)   initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.partnerId           = [dict[@"fp_id"] integerValue];
        self.partnerTitle        = dict[@"fp_title"];
        self.userId              = [dict[@"fp_uid"] integerValue];
        self.partnerStatus       = [dict[@"fp_status"] integerValue]; //信息状态 0-未关闭 1-已关闭
        self.partnerTags         = dict[@"fp_tag"];
        self.partnerProvinceName = dict[@"fp_province_name"];
        self.partnerCityName     = dict[@"fp_city_name"];
        self.partnerDistrictName = dict[@"fp_district_name"];
        self.partnerAddress      = dict[@"fp_address"];
        self.location            = [NSString stringWithFormat:@"%@%@%@%@",self.partnerProvinceName,self.partnerCityName,self.partnerDistrictName,self.partnerAddress];
        self.partnerDesc         = dict[@"fp_desc"];
        self.partnerAsk          = dict[@"fp_ask"];
        self.username            = dict[@"u_username"];
        self.nickname            = dict[@"u_nickname"];
        self.headerUrl           = dict[@"u_header_url"];
        self.sex                 = [BusinessEnum getSex:[dict[@"u_sex"] integerValue]];
        self.sexIcon             = [BusinessEnum getSexIcon:[dict[@"u_sex"] integerValue]];
        
    }
    return self;
}

+(instancetype)partnerWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
