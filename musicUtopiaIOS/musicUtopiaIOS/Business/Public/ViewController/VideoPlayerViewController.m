//
//  VideoPlayerViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AppDelegate.h"
#import "JWPlayer.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放";

    //创建播放容器
    JWPlayer * player=[[JWPlayer alloc]initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    [player updatePlayerWith:[NSURL URLWithString:self.videoUrl]];
    player.isLandscape = YES;
    [self.view addSubview:player];


    //退出按钮
    [self createBackBtn];
    
}

-(void)createBackBtn {
    
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(12,35,BIG_ICON_SIZE,BIG_ICON_SIZE))
        .L_ImageName(@"back")
        .L_Event(YES)
        .L_Click(self,@selector(backBtnClick))
        .L_AddView(self.view);
    }];
    
}

-(void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
