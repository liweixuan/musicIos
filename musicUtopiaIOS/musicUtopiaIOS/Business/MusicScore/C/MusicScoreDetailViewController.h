//
//  MusicScoreDetailViewController.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIViewController.h"

@interface MusicScoreDetailViewController : Base_UIViewController
@property(nonatomic,strong)NSString  * musicScoreName;   //曲谱名称
@property(nonatomic,assign)NSInteger   imageCount;       //图片页数
@property(nonatomic,assign)NSInteger   musicScoreId;     //曲谱ID
@property(nonatomic,strong)NSArray   * musicArr;         //曲谱数组
@end
