//
//  PartnerCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerFrame.h"

@class PartnerCell;
@protocol PartnerCellDelegate <NSObject>
-(void)userHeaderClick:(PartnerCell *)cell;  //用户头像点击
@end

@interface PartnerCell : UITableViewCell
@property(nonatomic,strong)PartnerFrame * partnerFrame;  //位置+数据源对象
@property(nonatomic,strong) id<PartnerCellDelegate> delegate;
@end
