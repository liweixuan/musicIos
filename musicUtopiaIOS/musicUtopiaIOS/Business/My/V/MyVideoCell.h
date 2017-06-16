//
//  MyVideoCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyVideoCell;
@protocol MyVideoDelegate <NSObject>

//删除视频点击
-(void)deletePlayVideoBtn:(MyVideoCell *)cell;


@end

@interface MyVideoCell : UITableViewCell

@property(nonatomic,strong)id<MyVideoDelegate> delegate;

@property(nonatomic,strong)NSDictionary * dictData;  //位置+数据源对象
@end
