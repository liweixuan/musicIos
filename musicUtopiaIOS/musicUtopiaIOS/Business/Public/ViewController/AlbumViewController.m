//
//  AlbumViewController.m
//  jxb_ios_teacher
//
//  Created by cx on 15/11/6.
//  Copyright © 2015年 jxb. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_albumController;
}
@end

@implementation AlbumViewController

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
    UIImage *image = nil;
    if ([_albumController allowsEditing]) {
        image = info[UIImagePickerControllerEditedImage];
    }else{
        image = info[UIImagePickerControllerOriginalImage];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        if (image != nil) {
            [self.delegate albumSelectImage:image];
        }
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    viewController.navigationItem.title = @"相册";
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
