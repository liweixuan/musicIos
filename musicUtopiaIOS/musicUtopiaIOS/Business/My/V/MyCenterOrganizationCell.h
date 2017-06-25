//
//  MyCenterOrganizationCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationFrame.h"

@interface MyCenterOrganizationCell : UITableViewCell
@property(nonatomic,strong)OrganizationFrame * organizationFrame;  //位置+数据源对象
@end
