//
//  OrganizationCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationFrame.h"

@interface OrganizationCell : UITableViewCell
@property(nonatomic,strong)OrganizationFrame * organizationFrame;  //位置+数据源对象
@end
