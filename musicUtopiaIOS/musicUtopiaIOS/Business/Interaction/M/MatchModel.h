//
//  MatchModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchModel : NSObject

@property(nonatomic,assign) NSInteger   matchId;                 //比赛ID
@property(nonatomic,copy)   NSString *  matchName;               //比赛曲目名称
@property(nonatomic,assign) NSInteger   musicScorePage;          //曲谱数
@property(nonatomic,assign) NSInteger   musicScoreId;            //曲谱ID
@property(nonatomic,assign) NSInteger   cid;                     //类别ID
@property(nonatomic,copy)   NSString *  cName;                   //类别名称
@property(nonatomic,assign) NSInteger   matchInvolvementCount;   //参与人数
@property(nonatomic,assign) NSInteger   matchStartTimeUnix;      //开始时间
@property(nonatomic,copy)   NSString *  matchStartTime;          //开始时间
@property(nonatomic,assign) NSInteger   matchEndTimeUnix;        //结束时间
@property(nonatomic,copy)   NSString *  matchEndTime;            //结束时间
@property(nonatomic,assign) NSInteger   nowStatus;               //当前状态
@property(nonatomic,assign) NSInteger   matchType;               //比赛类型
@property(nonatomic,copy)   NSString *  matchTypeStr;            //比赛类型转化
@property(nonatomic,assign) NSInteger   matchCreateTime;         //创建时间
@property(nonatomic,copy)   NSString *  cIcon;                   //类别图标
@property(nonatomic,copy)   NSString *  matchCover;              //比赛封面

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)matchWithDict  :(NSDictionary *)dict;
@end
