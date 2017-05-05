//
//  IndependenceTeacherView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol IndependenceTeacherViewDelegate <NSObject>

//独立教师信息列表
-(void)independenceTeacherClick:(NSDictionary *)dictData;

@end

@interface IndependenceTeacherView : Base_UIView
//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<IndependenceTeacherViewDelegate> delegate;

@end
