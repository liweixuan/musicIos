//
//  VideoViewController.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoDelegate <NSObject>
- (void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image;
@end

@interface VideoViewController : UIViewController
@property(nonatomic,strong)id<VideoDelegate> delegate;
@end
