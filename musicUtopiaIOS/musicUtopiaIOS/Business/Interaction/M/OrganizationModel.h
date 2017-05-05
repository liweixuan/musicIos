//
//  OrganizationModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationModel : NSObject

@property(nonatomic,assign) NSInteger  organizationId;           //团体ID
@property(nonatomic,copy)   NSString * organizationCover;        //团体封面
@property(nonatomic,copy)   NSString * organizationCreateTime;   //团体创建时间
@property(nonatomic,copy)   NSString * organizationProvinceName; //省份名称
@property(nonatomic,copy)   NSString * organizationCityName;     //城市名称
@property(nonatomic,copy)   NSString * organizationDistrictName; //区域名称
@property(nonatomic,copy)   NSString * location;                 //完整地址
@property(nonatomic,copy)   NSString * organizationName;         //团体名称
@property(nonatomic,assign) NSInteger  organizationUserCount;    //团体人数
@property(nonatomic,copy)   NSString * organizationMotto;        //座右铭

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)organizationWithDict:(NSDictionary *)dict;
@end
