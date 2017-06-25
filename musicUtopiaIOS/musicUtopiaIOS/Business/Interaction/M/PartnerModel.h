//
//  PartnerModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerModel : NSObject

@property(nonatomic,assign) NSInteger  partnerId;               //找伙伴ID
@property(nonatomic,copy)   NSString * partnerTitle;            //找伙伴标题
@property(nonatomic,assign) NSInteger  userId;                  //用户ID
@property(nonatomic,assign) NSInteger  userAge;                 //用户年龄
@property(nonatomic,assign) NSInteger  partnerStatus;           //状态
@property(nonatomic,copy)   NSString * partnerTags;             //标签
@property(nonatomic,copy)   NSString * partnerProvinceName;     //省份名称
@property(nonatomic,copy)   NSString * partnerCityName;         //城市名称
@property(nonatomic,copy)   NSString * partnerDistrictName;     //区域名称
@property(nonatomic,copy)   NSString * partnerAddress;          //详细地址
@property(nonatomic,copy)   NSString * location;                //完整地址
@property(nonatomic,copy)   NSString * partnerDesc;             //描述
@property(nonatomic,copy)   NSString * partnerAsk;              //要求
@property(nonatomic,copy)   NSString * username;                //用户帐号
@property(nonatomic,copy)   NSString * nickname;                //用户昵称
@property(nonatomic,copy)   NSString * headerUrl;               //用户头像
@property(nonatomic,copy)   NSString * sex;                     //性别
@property(nonatomic,copy)   NSString * sexIcon;                 //性别图标名

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)partnerWithDict:(NSDictionary *)dict;
@end
