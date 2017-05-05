//
//  MatchView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol MatchViewDelegate <NSObject>

//向外传递去投票点击
-(void)voteClick:(NSInteger)matchId;

@end

@interface MatchView : Base_UIView
//获取比赛信息数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<MatchViewDelegate> delegate;
@end
