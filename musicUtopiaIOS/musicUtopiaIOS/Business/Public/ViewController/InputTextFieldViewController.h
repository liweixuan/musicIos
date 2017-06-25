//
//  InputTextFieldViewController.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIViewController.h"

@interface InputTextFieldViewController : Base_UIViewController
@property(nonatomic,strong)NSString * VCTitle;
@property(nonatomic,assign)NSInteger  inputTag;    //输入框标记，用于反回时告诉更改哪个输入框的值
@property(nonatomic,strong)NSString * defaultStr;  //默认输入框内容
@end
