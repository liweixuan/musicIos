//
//  OrganizationModel.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrganizationModel.h"

@implementation OrganizationModel
-(instancetype)   initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.organizationId           = [dict[@"o_id"] integerValue];
        self.organizationCover        = dict[@"o_cover"];
        self.organizationCreateTime   = [G formatData:[dict[@"o_create_time"] integerValue] Format:@"YYYY年MM月dd日"];
        self.organizationProvinceName = dict[@"o_province_name"];
        self.organizationCityName     = dict[@"o_city_name"];
        self.organizationDistrictName = dict[@"o_district_name"];
        self.organizationMotto        = dict[@"o_motto"];
        self.organizationName         = dict[@"o_name"];
        self.organizationUserCount    = [dict[@"o_user_count"] integerValue];
        self.location                 = [NSString stringWithFormat:@"%@-%@-%@",self.organizationProvinceName,self.organizationCityName,self.organizationDistrictName];
        
    }
    return self;
}

+(instancetype)organizationWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
