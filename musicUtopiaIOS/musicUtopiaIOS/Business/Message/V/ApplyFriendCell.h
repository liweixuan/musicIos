//
//  ApplyFriendCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplyFriendCell;
@protocol ApplyFriendCellDelegate <NSObject>
-(void)agreedToBtnClick  :(ApplyFriendCell *)cell;  //同意点击
-(void)refusedToBtnClick :(ApplyFriendCell *)cell;  //拒绝点击
@end

@interface ApplyFriendCell : UITableViewCell
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,strong)id<ApplyFriendCellDelegate> delegate;
@end
