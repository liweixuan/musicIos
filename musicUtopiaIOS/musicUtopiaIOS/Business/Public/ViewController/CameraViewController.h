//
//  CameraViewController.h
//  jxb_ios_teacher
//
//  Created by cx on 15/11/6.
//  Copyright © 2015年 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraDelegate <NSObject>

- (void)cameraTakePhoto:(UIImage *)photo;

@end

@interface CameraViewController : UIViewController

@property (nonatomic, strong) id <CameraDelegate> delegate;

@end
