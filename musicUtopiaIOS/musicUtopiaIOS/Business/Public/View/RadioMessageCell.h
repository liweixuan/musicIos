//
//  RadioMessageCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioMessageFrame.h"

@interface RadioMessageCell : UITableViewCell
@property(nonatomic,strong)RadioMessageFrame * frameData;  //语音消息内容+位置
@end
