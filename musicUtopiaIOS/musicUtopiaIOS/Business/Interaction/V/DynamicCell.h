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
-(void)zanClick       :(DynamicCell *)cell NowView:(UILabel *)label;  //赞点击
-(void)concernClick   :(DynamicCell *)cell;  //关注点击
-(void)userHeaderClick:(DynamicCell *)cell;  //用户头像点击
-(void)deleteBtnClick :(DynamicCell *)cell;  //删除按钮点击
-(void)videoPlayerBtnClick :(DynamicCell *)cell;  //播放视频
@end

@interface DynamicCell : UITableViewCell
@property(nonatomic,strong)DynamicFrame * dynamicFrame;  //位置+数据源对象
@property(nonatomic,strong)id<DynamicCellDelegate> delegate;
@property(nonatomic,assign)BOOL isDeleteBtn;//是否有删除按钮
@end
