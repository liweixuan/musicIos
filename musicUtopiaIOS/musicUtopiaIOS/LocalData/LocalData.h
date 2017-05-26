//
//  LocalData.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject

//获取全部乐器分类项，包含非正常乐器分类
+(NSArray *)getMusicCategory;

//获取全部标准乐器分类项
+(NSMutableArray *)getStandardMusicCategory;

//获取省市区数据
typedef void(^loctaionResults)(BOOL results,NSArray *locationArr);
+(NSMutableArray *)getLocationInfoResult:(loctaionResults)rs;

@end
