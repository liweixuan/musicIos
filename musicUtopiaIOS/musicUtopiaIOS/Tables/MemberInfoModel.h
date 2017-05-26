//
//  MemberInfoModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject
@property(nonatomic,strong)NSString * m_id;
@property(nonatomic,strong)NSString * m_headerUrl;
@property(nonatomic,strong)NSString * m_userName;
@property(nonatomic,strong)NSString * m_nickName;

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)memberInfoWithDict:(NSDictionary *)dict;
+(NSDictionary *) createTable;
@end
