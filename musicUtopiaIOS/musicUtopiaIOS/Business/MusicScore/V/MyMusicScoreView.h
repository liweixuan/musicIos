//
//  MyMusicScoreView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol MyMusicScoreViewDelegate <NSObject>

//点击曲谱
-(void)musicScoreClick:(NSDictionary *)dictData;

//删除个人收藏的曲谱
-(void)deleteMyMusicScoreClick:(NSInteger)cmsId Index:(NSInteger)index;

@end

@interface MyMusicScoreView : Base_UIView
@property(nonatomic,strong) id<MyMusicScoreViewDelegate> delegate;

-(void)getData:(NSDictionary *)params Type:(NSString *)type;

-(void)editMode:(BOOL)isEdit;

-(void)deleteIdxCell:(NSInteger)index;
@end
