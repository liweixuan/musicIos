//
//  PartnerView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol PartnerViewDelegate <NSObject>

//向外传递动态头像点击事件
-(void)publicUserHeaderClick:(NSInteger)userId UserName:(NSString *)username;

//向外传递网络请求错误
-(void)requestFaild:(NSInteger)menuIdx;

@end

@interface PartnerView : Base_UIView

//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<PartnerViewDelegate> delegate;

@end
