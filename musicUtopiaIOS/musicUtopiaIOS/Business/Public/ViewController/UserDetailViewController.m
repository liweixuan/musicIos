//
//  UserDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户详情";
    NSLog(@"用户ID为：%ld",(long)self.userId);
}



@end
