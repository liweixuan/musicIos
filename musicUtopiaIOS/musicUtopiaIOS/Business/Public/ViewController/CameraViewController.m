//
//  CameraViewController.m
//  jxb_ios_teacher
//
//  Created by cx on 15/11/6.
//  Copyright © 2015年 jxb. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_cameraController;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
   
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    
    [self initViewUI];
}

- (void)initViewUI{
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
        _cameraController.allowsEditing = YES;
        _cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _cameraController.view.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_cameraController.view];
        
    }

}

#pragma mark - 摄像头相关的公共类

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = nil;
    if ([_cameraController allowsEditing]) {
        image = info[UIImagePickerControllerEditedImage];
    }else{
        image = info[UIImagePickerControllerOriginalImage];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (image != nil) {
            [self.delegate cameraTakePhoto:image];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
