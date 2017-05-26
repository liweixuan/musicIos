//
//  RegisterSubmitViewController.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIViewController.h"

@interface RegisterSubmitViewController : Base_UIViewController
@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * password;
@property(nonatomic,strong)NSString * nickname;
@property(nonatomic,assign)NSInteger  sex;
@property(nonatomic,strong)NSString * headerUrl;
@end
