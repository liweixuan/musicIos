//
//  MatchCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFrame.h"

@class MatchCell;
@protocol MatchCellDelegate <NSObject>
-(void)voteClick:(MatchCell *)cell;  //去投票点击
@end

@interface MatchCell : UITableViewCell
@property(nonatomic,strong)MatchFrame * matchFrame;  //位置+数据源对象
@property(nonatomic,strong) id<MatchCellDelegate> delegate;
@end
