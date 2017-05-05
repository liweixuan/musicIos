//
//  OrganizationView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol OrganizationViewDelegate <NSObject>


//向外传递查看团体点击事件，跳转至详细
-(void)organizationItemClick:(NSInteger)organizationId;

@end

@interface OrganizationView : Base_UIView
//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<OrganizationViewDelegate> delegate;

@end
