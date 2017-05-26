//
//  AllMusicScoreView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol AllMusicScoreViewDelegate <NSObject>

//点击曲谱类别
-(void)musicScoreCategoryClick:(NSInteger)categoryId;

@end

@interface AllMusicScoreView : Base_UIView
@property(nonatomic,strong) id<AllMusicScoreViewDelegate> delegate;
@end
