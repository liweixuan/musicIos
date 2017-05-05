//
//  TagLabel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
