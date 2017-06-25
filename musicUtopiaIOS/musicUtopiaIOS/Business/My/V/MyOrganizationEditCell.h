//
//  MyOrganizationEditCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrganizationEditCell : UITableViewCell
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,assign)BOOL isHideRightIcon;
@end
