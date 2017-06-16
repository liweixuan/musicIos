//
//  MatchUserVideoCommentFrame.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchUserVideoCommentFrame : NSObject
@property(nonatomic,strong)NSDictionary * matchUserVideoCommentDict;  //数据源

@property(nonatomic,assign)CGRect headerFrame;    //头像位置
@property(nonatomic,assign)CGRect nicknameFrame;  //昵称位置
@property(nonatomic,assign)CGRect timeFrame;      //日期位置
@property(nonatomic,assign)CGRect contentFrame;   //内容位置

@property(nonatomic,assign)CGFloat cellHeight;  //行高度

-(instancetype)initWithMatchUserVideoComment:(NSDictionary *)dictData;
@end
