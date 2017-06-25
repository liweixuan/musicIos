//
//  MemberInfoData.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MemberInfoData.h"

@implementation MemberInfoData

//获取会员信息
+(void)getMemberInfo:(NSString *)username MemberEnd:(void(^)(NSDictionary * memberInfo))rsBlock {
    
    //查询本地数据库有否有该用户信息
    NSMutableDictionary * dictData = [NSMutableDictionary dictionary];
    
    //打开数据表
    FMDatabase * db = [FMDatabase databaseWithPath:[Db getDatabasePath]];
    if(![db open]){
        LOG(@"本地数据库打开失败...");
        return;
    }
    
    //根据条件查询
    NSString * querySql = [NSString stringWithFormat:@"select m_headerUrl,m_nickName from MemberInfoModel where m_userName = '%@'",username];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next]) {
        
        NSString * headerUrl = [resultSet stringForColumn:@"m_headerUrl"];
        NSString * nickName  = [resultSet stringForColumn:@"m_nickName"];
        
        [dictData setObject:headerUrl forKey:@"m_headerUrl"];
        [dictData setObject:nickName forKey:@"m_nickName"];
        
    }
    
    
    //没有该用户的信息
    if(dictData[@"m_headerUrl"] == nil){
        
        NSArray  * params = @[@{@"key":@"u_username",@"value":username}];
        NSString * url = [G formatRestful:API_USER_BASIC_INFO Params:params];
        
        //网络请求获取该用户信息
        [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {

            NSDictionary * userInfo = (NSDictionary *)array;
            
            //将信息保存到会员信息表
            NSString * insertSql = [NSString stringWithFormat:@"insert into MemberInfoModel (m_id,m_headerUrl,m_userName,m_nickName) values ('%@','%@','%@','%@')",userInfo[@"u_id"],userInfo[@"u_header_url"],userInfo[@"u_username"],userInfo[@"u_nickname"]];
            
            if([db executeUpdate:insertSql]){
                
                [dictData setObject:userInfo[@"u_header_url"] forKey:@"m_headerUrl"];
                [dictData setObject:userInfo[@"u_nickname"] forKey:@"m_nickName"];
                
                rsBlock(dictData);
                
                
            }else {
                
                [dictData setObject:@"" forKey:@"m_headerUrl"];
                [dictData setObject:@"" forKey:@"m_nickName"];
                
                rsBlock(dictData);
                
            }
        } errorBlock:^(NSString *error) {
            
            [dictData setObject:@"" forKey:@"m_headerUrl"];
            [dictData setObject:@"" forKey:@"m_nickName"];
            
            rsBlock(dictData);
        }];

    }else{
        
        rsBlock(dictData);
        
    }
    
    
  
}

+(void)updateMemberInfo:(NSDictionary *)userDict {
    
    NSLog(@"更新用户信息");
    
    //打开数据表
    FMDatabase * db = [FMDatabase databaseWithPath:[Db getDatabasePath]];
    if(![db open]){
        LOG(@"本地数据库打开失败...");
        return;
    }
    
    
    if([db executeUpdate:@"update MemberInfoModel set m_headerUrl = ?,m_nickName = ? where m_id = ?",userDict[@"m_headerUrl"],userDict[@"m_nickName"],userDict[@"m_id"]]){
        NSLog(@"用户信息更新成功");
    }else{
        NSLog(@"用户信息更新失败");
    }
}

@end
