//
//  MatchDetailCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MatchDetailCell;
@protocol MatchDetailCellDelegate <NSObject>
-(void)voteBtnClick:(MatchDetailCell *)cell;  //去投票点击
@end

@interface MatchDetailCell : UITableViewCell
@property(nonatomic,assign)NSInteger      idx;
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,assign)NSInteger      isVote;    //是否可以投票
@property(nonatomic,assign)NSInteger      totalVoteCount; //当前的总票数

@property(nonatomic,strong)id<MatchDetailCellDelegate> delegate;
@end
