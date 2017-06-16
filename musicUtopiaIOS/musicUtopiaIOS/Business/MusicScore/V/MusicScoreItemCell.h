//
//  MusicScoreItemCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicScoreItemCell;
@protocol MusicScoreItemCellDelegate <NSObject>

//删除收藏的曲谱
-(void)deleteMyMusicScore:(MusicScoreItemCell *)cell;

@end

@interface MusicScoreItemCell : UITableViewCell
@property(nonatomic,strong)id<MusicScoreItemCellDelegate> delegate;
@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@property(nonatomic,assign)BOOL isEdit;
@end
