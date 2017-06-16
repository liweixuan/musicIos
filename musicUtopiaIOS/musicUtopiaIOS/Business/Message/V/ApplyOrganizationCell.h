//
//  ApplyOrganizationCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ApplyOrganizationCell;
@protocol ApplyOrganizationCellDelegate <NSObject>
-(void)agreedToBtnClick  :(ApplyOrganizationCell *)cell;  //同意点击
-(void)refusedToBtnClick :(ApplyOrganizationCell *)cell;  //拒绝点击
@end

@interface ApplyOrganizationCell : UITableViewCell
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,strong)id<ApplyOrganizationCellDelegate> delegate;
@end
