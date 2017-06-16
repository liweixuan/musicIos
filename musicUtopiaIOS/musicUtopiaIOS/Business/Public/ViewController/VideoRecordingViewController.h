//
//  VideoRecordingViewController.h
//  videoRecordingDemo
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoRecordingDelegate <NSObject>

//发送小视频
-(void)sendVideo:(NSString *)videoPath;

@end

@interface VideoRecordingViewController : UIViewController
@property(nonatomic,strong)id<VideoRecordingDelegate> delegate;
@end
