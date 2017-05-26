//
//  DynamicImagePreviewViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DynamicImagePreviewViewController.h"
#import "PhotoView.h"

@interface DynamicImagePreviewViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView * _imageViewScrollView;  //图片展现视图
    UIScrollView * _mainScrollBox;        //总滚动容器视图
    UIView       * _popView;
    UIPageControl * _pageControl;
    UIView      * _boxMaskView;     //总遮罩
    UIView      * _photoMenuView;   //图片菜单操作视图
    
    NSString     * _nowImageUrl;   //长按后准备进行操作的图片（保存系统相册）
}
@end

@implementation DynamicImagePreviewViewController

-(void)viewDidLoad {
    [super viewDidLoad];
  
    //创建总滑动容器视图
    [self mainScrollBox];
    
    //创建图片展示视图
    [self createImageViewScrollView];
    
    //创建分页控件
    [self createUIPageControl];
    
    //创建展现图片
    //[self createImage];
    
    //创建返回按钮
    [self popButton];
    
    //创建总遮罩视图
    [self createMaskView];
    
    //创建图片操作弹出框
    [self createPhotoMenuView];
    
    
}

#pragma mark - 创建图片展示视图
-(void)createImageViewScrollView {
    
    
    //创建图片展示
    for(int i=0;i<self.imageArr.count;i++){
        
        UIScrollView * imageViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*D_WIDTH,0,D_WIDTH,D_HEIGHT)];
        imageViewScrollView.pagingEnabled = YES;
        imageViewScrollView.backgroundColor = [UIColor blackColor];
        imageViewScrollView.delegate = self;
        imageViewScrollView.bounces = NO;
        imageViewScrollView.showsHorizontalScrollIndicator = NO;
        [_mainScrollBox addSubview:imageViewScrollView];
        
        NSDictionary * dictData = self.imageArr[i];

            NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"di_img_url"]];
        NSLog(@"%@",imageURL);
            PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,imageViewScrollView.frame.size.width,imageViewScrollView.frame.size.height) andImage:imageURL dataType:URL_TYPE imgData:nil];

        //长按手势
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClicked:)];
        
        [photoView addGestureRecognizer:longTap];
        
        [imageViewScrollView addSubview:photoView];
        
        //}
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        tap.delegate = self;
        [imageViewScrollView addGestureRecognizer:tap];
        
        //双击手势（为了阻拦双击会产生单击事件）
        UITapGestureRecognizer * doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [tap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
        [imageViewScrollView addGestureRecognizer:doubleTap];
        
        imageViewScrollView.contentSize = CGSizeMake(D_WIDTH,imageViewScrollView.frame.size.height);
        imageViewScrollView.contentOffset = CGPointMake(0,0);
        
        
        
    }
    
    
    _mainScrollBox.contentOffset = CGPointMake(self.imageIdx * D_WIDTH,0);
  
    
}

-(void)createUIPageControl {
    
    if(self.imageArr.count > 1){
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, D_HEIGHT - 50, D_WIDTH,50)];
        _pageControl.numberOfPages = self.imageArr.count;
        _pageControl.currentPage   = self.imageIdx;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        [self.view addSubview:_pageControl];
        
    }
    
    
    
}

//创建总滑动容器视图
-(void)mainScrollBox {
    _mainScrollBox = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,D_WIDTH,D_HEIGHT)];
    _mainScrollBox.backgroundColor = [UIColor orangeColor];
    _mainScrollBox.bounces = NO;
    _mainScrollBox.pagingEnabled = YES;
    _mainScrollBox.delegate = self;
    _mainScrollBox.showsHorizontalScrollIndicator = NO;
    _mainScrollBox.showsVerticalScrollIndicator   = NO;
    _mainScrollBox.contentSize = CGSizeMake(D_WIDTH*self.imageArr.count,D_HEIGHT);
    [self.view addSubview:_mainScrollBox];
}

-(void)createMaskView {
    _boxMaskView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _boxMaskView.backgroundColor = RGB_COLOR_OPACITY(0,0,0,0.4);
    _boxMaskView.hidden = YES;
    [self.view addSubview:_boxMaskView];
    
    //遮罩单击手势
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapClicked)];
    [_boxMaskView addGestureRecognizer:maskTap];
}

-(void)createPhotoMenuView {
    _photoMenuView = [[UIView alloc] initWithFrame:CGRectMake(0,D_HEIGHT,D_WIDTH,105)];
    _photoMenuView.backgroundColor = RGB_COLOR(200,200,200);
    [self.view addSubview:_photoMenuView];
    
    UIButton *savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savePhotoBtn setTitle:@"保存" forState:UIControlStateNormal];
    [savePhotoBtn setTitleColor:RGB_COLOR(51,51,51) forState:UIControlStateNormal];
    savePhotoBtn.frame = CGRectMake(0,0,D_WIDTH,50);
    savePhotoBtn.backgroundColor = [UIColor whiteColor];
    [savePhotoBtn addTarget:self action:@selector(savePhotoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_photoMenuView addSubview:savePhotoBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB_COLOR(51,51,51) forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0,[savePhotoBtn bottom]+5,D_WIDTH,50);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_photoMenuView addSubview:cancelBtn];
}

-(void)maskTapClicked {
    _boxMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [_photoMenuView setY:D_HEIGHT];
    }];
}

-(void)savePhotoBtnClicked {
    
    
    UIImage *img = nil;
    if(self.imageType == 1){
        NSURL* imageurl = [NSURL URLWithString:[self.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
        NSData*  data = [NSData dataWithContentsOfURL:imageurl];//获取网咯图片数据
        img = [UIImage imageWithData:data];
    }else{
        img = self.imageData;
    }
    
    
    if(img!=nil){
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        
    }else{
        NSLog(@"保存失败,请重新尝试");
        [self cancelBtnClicked];
    }
    
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
    if(!error){
        SHOW_HINT(@"保存成功")
        
        [self cancelBtnClicked];
    }else{
        NSLog(@"保存失败,请重新尝试");
        [self cancelBtnClicked];
    }
}

-(void)cancelBtnClicked {
    _boxMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [_photoMenuView setY:D_HEIGHT];
    }];
}


#pragma mark - 创建展现图片
-(void)createImage {
    
    
    PhotoView *photoView;
    if(self.imageType == 1){
        photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,_imageViewScrollView.frame.size.width,_imageViewScrollView.frame.size.height) andImage:self.imgUrl dataType:URL_TYPE imgData:nil];
        
    }else if(self.imageType == 2){
        photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,_imageViewScrollView.frame.size.width,_imageViewScrollView.frame.size.height) andImage:nil dataType:DATA_TYPE imgData:self.imageData];
        
    }
    
    
    //长按手势
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClicked:)];
    
    [photoView addGestureRecognizer:longTap];
    
    [_imageViewScrollView addSubview:photoView];
    
    //}
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [_imageViewScrollView addGestureRecognizer:tap];
    
    //双击手势（为了阻拦双击会产生单击事件）
    UITapGestureRecognizer * doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [tap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
    [_imageViewScrollView addGestureRecognizer:doubleTap];

    _imageViewScrollView.contentSize = CGSizeMake(0,_imageViewScrollView.frame.size.height);
    _imageViewScrollView.contentOffset = CGPointMake(0,0);
    
}

-(void)longTapClicked:(UILongPressGestureRecognizer *)longTap {
    if (longTap.state == UIGestureRecognizerStateBegan) {
        
        //PhotoView *pView = (PhotoView *)longTap.view;
        //_nowImageUrl = pView.imageurl;
        
        _boxMaskView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [_photoMenuView setY:D_HEIGHT-105];
        }];
        
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    NSLog(@"双击...");
}

-(void)tapClicked:(UITapGestureRecognizer *)tap {
    //_popView.hidden = !_popView.hidden;
    
    NSLog(@"单击.....");
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建返回按钮
-(void)popButton {
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,64)];
    _popView.hidden = YES;
    _popView.backgroundColor = RGB_COLOR_OPACITY(201,201,201,0.2);
    [self.view addSubview:_popView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5,64/2-30/2+10,30,30);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:backBtn];
}

#pragma mark - 返回按钮点击时
-(void)backBtnClicked {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = (int)scrollNowX / D_WIDTH;
    
    _pageControl.currentPage = nowIdx;

}

@end
