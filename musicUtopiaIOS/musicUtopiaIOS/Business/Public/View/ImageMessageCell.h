//
//  ImageMessageCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageMessageFrame.h"

@interface ImageMessageCell : UITableViewCell
@property(nonatomic,strong)ImageMessageFrame * frameData;  //图片消息内容+位置
@end
