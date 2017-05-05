//
//  PhotoBoxView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PhotoBoxView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SendImageViewController.h"

@interface PhotoBoxView()<SendImageViewControllerDelegate>
{
    NSMutableArray * _photoImages;
    UIScrollView   * _rightPhotoView;
}
@end

@implementation PhotoBoxView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建左侧相册，拍照选择按钮视图
        [self createPhotoActionBox];
        
        //创建右侧图片显示区域
        [self photoListView];
        
        //发送视图部分
        [self sendImageBox];
        
        
    }
    return self;
}

//初始化变量
-(void)initVar {
    _photoImages = [NSMutableArray array];
}

//创建左侧相册，拍照选择按钮视图
-(void)createPhotoActionBox {
    UIView * leftActionBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,([self height] - 40)/2,[self height] - 40))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self);
    }];
    
    //拍照
    UIView * photographView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,[leftActionBox width],[leftActionBox height]/2))
        .L_BgColor(HEX_COLOR(@"#EEEEEE"))
        .L_AddView(leftActionBox);
    }];
    
    //拍照图标
    UIImageView * photographIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([photographView width]/2 - MIDDLE_ICON_SIZE/2, [photographView height]/2 - MIDDLE_ICON_SIZE/2 - 10, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(photographView);
    }];
    
    //拍照标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,[photographIcon bottom]+5,[photographView width],CONTENT_FONT_SIZE))
        .L_Text(@"拍照")
        .L_Font(CONTENT_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(photographView);
    }];
    
    //中间分割线
    [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0, [photographView height]-1, [photographView width], 1))
        .L_BgColor(HEX_COLOR(@"#FFFFFF"))
        .L_AddView(photographView);
    }];
    
    //相册
    UIView * albumView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[leftActionBox height]/2,[leftActionBox width],[leftActionBox height]/2))
        .L_BgColor(HEX_COLOR(@"#EEEEEE"))
        .L_AddView(leftActionBox);
    }];
    
    //相册图标
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([photographView width]/2 - MIDDLE_ICON_SIZE/2, [photographView height]/2 - MIDDLE_ICON_SIZE/2 - 10, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(albumView);
    }];
    
    //相册标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,[photographIcon bottom]+5,[photographView width],CONTENT_FONT_SIZE))
        .L_Text(@"相册")
        .L_Font(CONTENT_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(albumView);
    }];

}

//获取系统图片
-(void)getSystemPhoto {
    
    //获取相册中的图片
    _photoImages = [self getOriginalImages];
    
    //创建图片显示容器
    CGFloat photoItemW = 120.0;
    
    //创建容器
    for(int i=0;i<_photoImages.count;i++){
        
        //每项图片
        UIView * photoItemView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(photoItemW * i,0,photoItemW,[self height]))
            .L_BgColor([UIColor redColor])
            .L_tag(i)
            .L_Click(self,@selector(photoImageClick:))
            .L_AddView(_rightPhotoView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(0,0, [photoItemView width],[photoItemView height]))
            .L_Image(_photoImages[i])
            .L_AddView(photoItemView);
        }];
        
    }
    
    _rightPhotoView.contentSize = CGSizeMake(photoItemW * _photoImages.count, [self height] - 40);
    
}

//创建右侧图片显示区域
-(void)photoListView {
    
    _rightPhotoView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
       view
        .L_Frame(CGRectMake(([self height] - 40)/2, 0, D_WIDTH - ([self height] - 40)/2, [self height] - 40))
        .L_BgColor([UIColor whiteColor])
        .L_contentSize(CGSizeMake(1000,[self height] - 40))
        .L_AddView(self);
    }];

    [self getSystemPhoto];
    
}


//发送视图部分
-(void)sendImageBox {
    
    UIView * sendImageBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0, [self height] - 40, [self width],40))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self);
    }];
    
    //发送按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([sendImageBox width] - 40 - CONTENT_PADDING_LEFT,40/2 - SUBTITLE_FONT_SIZE/2,40,SUBTITLE_FONT_SIZE))
        .L_Title(@"发送",UIControlStateNormal)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TargetAction(self,@selector(sendImageMessage),UIControlEventTouchUpInside)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_AddView(sendImageBox);
    } buttonType:UIButtonTypeCustom];
    
}


#pragma mark - 事件
-(void)photoImageClick:(UITapGestureRecognizer *)tap {
    
    NSInteger photoIdx = tap.view.tag;
    
    NSLog(@"%ld",(long)photoIdx);
    
    //取出图片数据
    UIImage * tempImage = _photoImages[photoIdx];
    
    
    SendImageViewController * photoPreviewVC = [[SendImageViewController alloc] init];
    photoPreviewVC.image             = tempImage;
    photoPreviewVC.SendImageDelegate = self;
    [[self viewController] presentViewController:photoPreviewVC animated:YES completion:^{
        
        [self.delegate resetBottomTool];
        
    }];
    
    
}

//图片发送
-(void)sendImageMessage {
    
}

#pragma mark - 代理
//图片预览发送
-(void)sendImage:(UIImage *)image {
    [self.delegate sendImageData:@[image]];
}


#pragma mark - 私有方法
/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (NSMutableArray * )enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{

    NSMutableArray * tempPhotoImages = [NSMutableArray array];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied)
    {
        //无权限
        NSLog(@"无相册访问权限");
        return nil;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      
            
            [tempPhotoImages addObject:result];
        }];
    }
    
    return tempPhotoImages;
}


- (NSMutableArray * )getThumbnailImages
{
    
    NSMutableArray * tempImages = [NSMutableArray array];
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
       tempImages =  [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [tempImages addObject:[self enumerateAssetsInAssetCollection:cameraRoll original:NO]];
    
    return tempImages[0];
}


- (NSMutableArray * )getOriginalImages
{
    
    NSMutableArray * tempImages = [NSMutableArray array];
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
       tempImages =   [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [tempImages addObject:[self enumerateAssetsInAssetCollection:cameraRoll original:YES]];
    
    return tempImages[0];
}

- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}


@end
