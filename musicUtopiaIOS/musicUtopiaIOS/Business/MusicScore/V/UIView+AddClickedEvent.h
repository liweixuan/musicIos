//
//  UIView+AddClickedEvent.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

@interface UIView (AddClickedEvent)
- (void)addClickedBlock:(void(^)(id obj))tapAction;
@end
