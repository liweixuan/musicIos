//
//  VideoCommentFrame.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCommentFrame : NSObject
@property(nonatomic,strong)NSDictionary * videoCommentDict;  //数据源

@property(nonatomic,assign)CGRect headerFrame;      //头像位置
@property(nonatomic,assign)CGRect nicknameFrame;    //昵称位置
@property(nonatomic,assign)CGRect timeFrame;        //日期位置
@property(nonatomic,assign)CGRect contentFrame;     //内容位置
@property(nonatomic,assign)CGRect actionFrame;      //操作容器位置
@property(nonatomic,assign)CGRect replyIconFrame;   //回复图标
@property(nonatomic,assign)CGRect replyTitleFrame;  //回复标题
@property(nonatomic,assign)CGRect zanIconFrame;     //点赞图标
@property(nonatomic,assign)CGRect zanCountFrame;    //点赞数量
@property(nonatomic,assign)CGFloat cellHeight;      //行高度

-(instancetype)initWithVideoComment:(NSDictionary *)dictData;
@end