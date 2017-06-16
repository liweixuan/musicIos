//
//  GroupInfoData.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "GroupInfoData.h"

@implementation GroupInfoData

+(void)getGroupInfo:(NSString *)groupid GroupEnd:(void(^)(NSDictionary * groupInfo))rsBlock {
    

    //查询本地数据库有否有该用户信息
    NSMutableDictionary * dictData = [NSMutableDictionary dictionary];
    
    //打开数据表
    FMDatabase * db = [FMDatabase databaseWithPath:[Db getDatabasePath]];
    if(![db open]){
        LOG(@"本地数据库打开失败...");
        return;
    }

    //根据条件查询
    NSString * querySql = [NSString stringWithFormat:@"select g_headerUrl,g_name from GroupInfoModel where g_id = '%@'",groupid];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next]) {
        
        NSString * headerUrl = [resultSet stringForColumn:@"g_headerUrl"];
        NSString * nickName  = [resultSet stringForColumn:@"g_name"];
        
        [dictData setObject:headerUrl forKey:@"g_headerUrl"];
        [dictData setObject:nickName forKey:@"g_name"];
        
    }
    
    
    //没有该用户的信息
    if(dictData[@"g_headerUrl"] == nil){
        
        
        //取出团体ID
        NSArray * groupIdArr = [groupid componentsSeparatedByString:@"_"];

        NSArray  * params = @[@{@"key":@"o_id",@"value":groupIdArr[1]}];
        NSString * url = [G formatRestful:API_ORGANIZATION_INFO Params:params];
        
        NSLog(@"&&&&%@",url);
        
        //网络请求获取该用户信息
        [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
            
            NSDictionary * groupArr = (NSDictionary *)array;
            
            NSDictionary * groupInfo = groupArr[@"detail"];
 
            //将信息保存到会员信息表
            NSString * insertSql = [NSString stringWithFormat:@"insert into GroupInfoModel (g_id,g_headerUrl,g_name) values ('%@','%@','%@')",groupid,groupInfo[@"o_logo"],groupInfo[@"o_name"]];
            
            if([db executeUpdate:insertSql]){
                
                [dictData setObject:groupInfo[@"o_logo"] forKey:@"g_headerUrl"];
                [dictData setObject:groupInfo[@"o_name"] forKey:@"g_name"];
                
                rsBlock(dictData);
                
                
            }else {
                
                [dictData setObject:@"" forKey:@"g_headerUrl"];
                [dictData setObject:@"" forKey:@"g_name"];
                
                rsBlock(dictData);
                
            }
        } errorBlock:^(NSString *error) {
            
            [dictData setObject:@"" forKey:@"g_headerUrl"];
            [dictData setObject:@"" forKey:@"g_name"];
            
            rsBlock(dictData);
        }];
        
    }else{
        
        rsBlock(dictData);
        
    }



}

@end
