//
//  GroupInfoModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfoModel : NSObject
@property(nonatomic,strong)NSString * g_id;
@property(nonatomic,strong)NSString * g_name;
@property(nonatomic,strong)NSString * g_headerUrl;

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)groupInfoWithDict:(NSDictionary *)dict;
+(NSDictionary *) createTable;
@end
