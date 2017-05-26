//
//  MemberInfoModel.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MemberInfoModel.h"

@implementation MemberInfoModel
//创建数据模型
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.m_id        = dict[@"m_id"];
        self.m_headerUrl = dict[@"m_headerUrl"];
        self.m_userName  = dict[@"m_userName"];
        self.m_nickName  = dict[@"m_nickName"];
    }
    return self;
}

+(instancetype)memberInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+(NSDictionary *) createTable {
    
    //创建表语句
    NSString *createTableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( \
                                id INTEGER PRIMARY KEY AUTOINCREMENT, \
                                m_id TEXT,   \
                                m_headerUrl TEXT,   \
                                m_userName INTEGER, \
                                m_nickName TEXT)",[self class]];
    
    NSDictionary * settingDict = @{
                                   @"createTableSql" : createTableStr
                                   };
    
    return settingDict;
}
@end
