//
//  RadioBoxView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"


@protocol RadioBoxViewDelegate <NSObject>

//发送语音数据
-(void)sendRadioData:(NSData *)radioData TimeLength:(NSInteger)length;

@end

@interface RadioBoxView : Base_UIView
@property(nonatomic,strong)id<RadioBoxViewDelegate> delegate;
@end
