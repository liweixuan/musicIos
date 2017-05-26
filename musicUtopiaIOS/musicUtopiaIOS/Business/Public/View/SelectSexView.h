//
//  SelectSexView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol SelectSexDelegate <NSObject>

//选择性别
-(void)selectSex:(NSDictionary *)sexDict;

//关闭性别选择
-(void)closeSelectSex;

@end

@interface SelectSexView : Base_UIView
@property(nonatomic,strong)id<SelectSexDelegate> delegate;
@end
