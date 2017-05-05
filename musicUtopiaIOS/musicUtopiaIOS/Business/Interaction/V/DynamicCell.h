//
//  DynamicCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicFrame.h"

@class DynamicCell;
@protocol DynamicCellDelegate <NSObject>
-(void)commentClick   :(DynamicCell *)cell;  //动态评论点击
-(void)userHeaderClick:(DynamicCell *)cell;  //用户头像点击
@end

@interface DynamicCell : UITableViewCell
@property(nonatomic,strong)DynamicFrame * dynamicFrame;  //位置+数据源对象
@property(nonatomic,strong) id<DynamicCellDelegate> delegate;
@end
