//
//  DynamicContentCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicFrame.h"

@class DynamicContentCell;
@protocol DynamicContentCellDelegate <NSObject>
-(void)commentClick   :(DynamicContentCell *)cell;  //动态评论点击
-(void)zanClick       :(DynamicContentCell *)cell NowView:(UILabel *)label;  //赞点击
-(void)concernClick   :(DynamicContentCell *)cell;  //关注点击
-(void)userHeaderClick:(DynamicContentCell *)cell;  //用户头像点击
-(void)deleteBtnClick :(DynamicContentCell *)cell;  //删除按钮点击
-(void)videoPlayerBtnClick :(DynamicContentCell *)cell;  //播放视频
@end

@interface DynamicContentCell : UITableViewCell
@property(nonatomic,strong)DynamicFrame * dynamicFrame;  //位置+数据源对象
@property(nonatomic,strong)id<DynamicContentCellDelegate> delegate;
@property(nonatomic,assign)BOOL isDeleteBtn;//是否有删除按钮
@end
