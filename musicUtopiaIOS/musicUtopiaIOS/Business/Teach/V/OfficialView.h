//
//  OfficialView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"


@protocol OfficialViewDelegate <NSObject>

//官方课程阶段列表
-(void)officialCategoryClick:(NSDictionary *)dictData;

@end

@interface OfficialView : Base_UIView
//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<OfficialViewDelegate> delegate;

@end
