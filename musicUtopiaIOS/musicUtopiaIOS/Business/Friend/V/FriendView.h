//
//  FriendView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol FriendViewDelegate <NSObject>

//发现好友点击事件
-(void)findFriendClick;

@end

@interface FriendView : Base_UIView
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@property(nonatomic,strong) id<FriendViewDelegate> delegate;
@end
