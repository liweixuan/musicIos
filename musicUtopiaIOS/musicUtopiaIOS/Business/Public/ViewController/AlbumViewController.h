//
//  AlbumViewController.h
//  jxb_ios_teacher
//
//  Created by cx on 15/11/6.
//  Copyright © 2015年 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlbumDelegate <NSObject>

- (void)albumSelectImage:(UIImage *)image;

@end

@interface AlbumViewController : UIViewController

@property (nonatomic, strong) id <AlbumDelegate> delegate;

@end
