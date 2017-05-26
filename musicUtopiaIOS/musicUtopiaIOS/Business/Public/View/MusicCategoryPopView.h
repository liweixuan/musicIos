//
//  MusicCategoryPopView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol MusicCategoryPopViewDelegate <NSObject>

//类别选择确认
-(void)categorySelected:(NSString *)c_name Cid:(NSInteger)c_id;

@end

@interface MusicCategoryPopView : Base_UIView
@property(nonatomic,strong)id<MusicCategoryPopViewDelegate> delegate;
@end
