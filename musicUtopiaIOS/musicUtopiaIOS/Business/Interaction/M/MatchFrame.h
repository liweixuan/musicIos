//
//  MatchFrame.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchModel.h"

@interface MatchFrame : NSObject
@property(nonatomic,strong)MatchModel * matchModel;  //数据源

@property(nonatomic,assign)CGRect matchCoverFrame;             //赛事图片
@property(nonatomic,assign)CGRect matchTypeFrame;              //赛事类别
@property(nonatomic,assign)CGRect matchNameFrame;              //赛事曲目名称
@property(nonatomic,assign)CGRect matchInvolvementCountFrame;  //参与人数
@property(nonatomic,assign)CGRect matchCategoryIconFrame;      //乐器类别图标
@property(nonatomic,assign)CGRect matchCategoryFrame;          //乐器类别
@property(nonatomic,assign)CGRect matchStartTimeFrame;         //开始时间
@property(nonatomic,assign)CGRect matchEndTimeFrame;           //结束时间
@property(nonatomic,assign)CGRect matchVoteFrame;              //去投票操作
@property(nonatomic,assign)CGRect middleLineFrame;             //分割线
@property(nonatomic,assign)CGRect matchStatusFrame;            //状态按钮
@property(nonatomic,assign)CGRect matchActionFrame;            //操作按钮

@property(nonatomic,assign)CGFloat      cellHeight;  //行高度

-(instancetype)initWithMatch:(MatchModel *)model;
@end
