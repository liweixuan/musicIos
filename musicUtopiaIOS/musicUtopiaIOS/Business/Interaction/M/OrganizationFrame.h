//
//  OrganizationFrame.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrganizationModel.h"

@interface OrganizationFrame : NSObject
@property(nonatomic,strong)OrganizationModel * organizationModel;     //动态数据源

@property(nonatomic,assign)CGRect coverBoxFrame;        //封面容器
@property(nonatomic,assign)CGRect coverImageFrame;      //封面
@property(nonatomic,assign)CGRect coverContentFrame;    //封面下内容容器
@property(nonatomic,assign)CGRect createTimeIconFrame;  //创立时间图标
@property(nonatomic,assign)CGRect createTimeFrame;      //创立时间内容
@property(nonatomic,assign)CGRect locationIconFrame;    //所在地点图标
@property(nonatomic,assign)CGRect loctionFrame;         //所在地点内容

@property(nonatomic,assign)CGRect organizationBoxFrame;  //信息容器
@property(nonatomic,assign)CGRect nameIconFrame;         //名称图标
@property(nonatomic,assign)CGRect nameFrame;             //名称
@property(nonatomic,assign)CGRect userCountIconFrame;    //团体总人数图标
@property(nonatomic,assign)CGRect userCountFrame;        //团体总人数
@property(nonatomic,assign)CGRect mottoFrame;            //座右铭

@property(nonatomic,assign)CGFloat      cellHeight;                   //行高度

-(instancetype)initWithOrganization:(OrganizationModel *)model;
@end
