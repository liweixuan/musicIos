//
//  GroupInfoModel.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "GroupInfoModel.h"

@implementation GroupInfoModel
//创建数据模型
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.g_id        = dict[@"g_id"];
        self.g_name      = dict[@"g_name"];
        self.g_headerUrl = dict[@"g_headerUrl"];
    }
    return self;
}

+(instancetype)groupInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+(NSDictionary *) createTable {
    
    //创建表语句
    NSString *createTableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( \
                                id INTEGER PRIMARY KEY AUTOINCREMENT, \
                                g_id TEXT,   \
                                g_name TEXT,   \
                                g_headerUrl TEXT)",[self class]];
    
    NSDictionary * settingDict = @{
                                   @"createTableSql" : createTableStr
                                   };
    
    return settingDict;
}
@end
