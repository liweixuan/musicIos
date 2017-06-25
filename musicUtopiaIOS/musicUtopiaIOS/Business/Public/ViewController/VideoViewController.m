//
//  VideoViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface VideoViewController ()<UINavigationControllerDelegate>
{
    UIImagePickerController *_albumController;
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initViewUI];
}

- (void)initViewUI{
    
    if ([self isPhotoLibraryAvailable]) {
        _albumController = [[UIImagePickerController alloc] init];
        _albumController.delegate = self;
        _albumController.allowsEditing = YES;
        _albumController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _albumController.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
        _albumController.view.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_albumController.view];
    }
    
}


#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
        
        //获取视频时长
        NSInteger secondValue = [self durationWithVideo:videoURL];
        
        NSLog(@"%ld",(long)secondValue);
        
        //不能超过一分钟
        if(secondValue >= 60){
            
            SHOW_HINT(@"视频时长不能超过一分钟");
            return;
            
        }
        
        //获取视频第一帧缩略图
        UIImage * thumbnail = [self getVideoPreViewImage:videoURL];
        
        [self.delegate videoSelectURL:videoURL thumbnailImage:thumbnail];
    }
}

//获取视频时长
- (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    return second;
}


// 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    viewController.navigationItem.title = @"相册";
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}




@end
