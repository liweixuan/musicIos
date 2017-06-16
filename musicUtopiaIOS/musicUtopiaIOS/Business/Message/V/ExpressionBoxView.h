//
//  ExpressionBoxView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"


@protocol ExpressionBoxViewDelegate <NSObject>

//发送表情信息
-(void)sendExpressMessage:(NSString *)expressImageName;

//删除信息
-(void)deleteExpressMessage;

//发送消息
-(void)sendExpressSubmit;

@end

@interface ExpressionBoxView : Base_UIView
@property(nonatomic,strong)id<ExpressionBoxViewDelegate> delegate;
-(void)createExpressView;
@end
