//
//  SelectAddressView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol SelectAddressDelegate <NSObject>

//选择省市区
-(void)selectLocation:(NSDictionary *)locationDict;

//关闭选择省市区
-(void)closeSelectLocation;

@end

@interface SelectAddressView : Base_UIView
@property(nonatomic,strong)id<SelectAddressDelegate> delegate;
@end
