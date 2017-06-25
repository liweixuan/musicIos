//
//  OrganizationUserCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OrganizationUserCell;
@protocol OrganizationUserCellDelegate <NSObject>

//踢出团体按钮
-(void)managerOrganizationUser:(OrganizationUserCell *)cell;

@end

@interface OrganizationUserCell : UITableViewCell
@property(nonatomic,strong)id<OrganizationUserCellDelegate> delegate;
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,assign)BOOL isManagerUser;        //是否可以管理成员
@end
