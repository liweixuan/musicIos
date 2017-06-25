#import "CreateInteractionViewController.h"
#import "CreateTagViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "MusicCategoryPopView.h"
#import "CameraViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "VideoViewController.h"
#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CreateInteractionViewController ()<UITextViewDelegate,MusicCategoryPopViewDelegate,TZImagePickerControllerDelegate,VideoDelegate,UIScrollViewDelegate>
{
    UIView       * _dynamicInputView;
    UIView       * _uploadView;
    UIView       * _radioView;                //音频视图
    UIView       * _videoView;                //视频视图
    UIImageView  * _playerVideoIcon;
    UILabel      * _placeHolder;
    UIScrollView * _scrollBoxView;
    
    AMapLocationManager * _locationManager;   //定位对象
    UITextView          * _dynamicTextView;   //动态输入框
    NSString            * _nowLocation;       //当前位置
    NSInteger             _nowDynamicType;    //当前的动态类型
    NSMutableArray      * _dynamicTypeBtnArr; //类型数组
    UIView              * _selectViewBox;     //选择视图
    
    NSString            * _cname;             //类别名称
    NSInteger             _cid;               //当前选择类型
    NSString            * _tagStr;            //当前的标签数据
    NSMutableArray      * _uploadImageArr;    //上传的图片保存数组
    NSMutableArray      * _uploadImageViewArr;//上传图片视图数组
    
    UIImageView * _videoPreview;
    NSURL       * _videoUrl;
    NSString    * _videoEndUrl;
}
@end

@implementation CreateInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    
    //初始化
    [self initVar];
    
    //获取当前用户的位置信息
    [self initMap];
    
    //设置滚动父容器
    [self createScrollView];
    
    //创建右侧按钮
    [self createNavigationRightBtn];
    
    //创建动态内容输入
    [self createDynamicInputBox];
    
    //上传图片视图
    [self createUploadView];
    
    //创建音频视图
    [self createRadioView];
    
    //创建视频视图
    [self createVideoView];
    
    //创建选项列表
    [self createSelectItemView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedTags:) name:@"CreateInteractionVC" object:nil];
    
    
    
}


//初始化
-(void)initVar {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _nowLocation       = @"";
    _nowDynamicType    = 0;
    _dynamicTypeBtnArr = [NSMutableArray array];
    _cid               = -1;
    _tagStr            = @"";
    _cname             = @"";
    _uploadImageArr    = [NSMutableArray array];
    _uploadImageViewArr= [NSMutableArray array];
    
    //添加默认的上传图
    [_uploadImageArr addObject:@{@"image":@"shangchuan",@"type":@"default"}];
}

//位置初始化
-(void)initMap {
    
    //初始化操作对象
    _locationManager = [[AMapLocationManager alloc] init];

    //带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout =2;
    
    //逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息） YES 改成 NO ，则不会返回地址信息
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        
        //更新位置信息
        UILabel * locationLabel = [self.view viewWithTag:100];
        locationLabel.text = @"";

       
        if (error){
            
            
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            locationLabel.text = @"位置信息获取失败";
            
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        
        if (regeocode) {
 
            NSString * _street  = [BusinessEnum getEmptyString:regeocode.street];
            NSString * _POIName = [BusinessEnum getEmptyString:regeocode.POIName];
            
            if(_street.length<=0 && _POIName.length<= 0){
                _nowLocation = @"地址信息获取失败";
            }else{
                _nowLocation = [NSString stringWithFormat:@"%@-%@",_street,_POIName];
            }
            
            //更新位置信息
            locationLabel.text = _nowLocation;
        }
 
    }];
    
    
}

#pragma mark - 视图创建
//滚动父容器创建
-(void)createScrollView {
    
    _scrollBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
       
        view
        .L_Frame(self.view.frame)
        .L_contentSize(CGSizeMake(D_WIDTH,1000))
        .L_AddView(self.view);
        
    }];
    
    _scrollBoxView.delegate = self;
    
}

-(void)createDynamicInputBox {
    
    _dynamicInputView = [UIView ViewInitWith:^(UIView *view) {
       
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,D_WIDTH - CARD_MARGIN_LEFT*2,220))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);

    }];
    
    //创建textview输入框
    _dynamicTextView  = [[UITextView alloc] initWithFrame:CGRectMake(5,0,[_dynamicInputView width]-10,220)];
    _dynamicTextView.delegate      = self;
    _dynamicTextView.returnKeyType = UIReturnKeyDone;
    _dynamicTextView.font = [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE];
    [_dynamicInputView addSubview:_dynamicTextView];
    
    //模拟placeholder
    _placeHolder = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(5,5,150,20))
        .L_Text(@"想和大家分享什么")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_AddView(_dynamicTextView);
    }];
    
    //分割线
    UIView * lineView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,150,[_dynamicInputView width],1))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(_dynamicInputView);
    }];
    
    //类型选择视图
    UIView * typeViewBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(5,[lineView bottom],[_dynamicInputView width]-10,69))
        .L_AddView(_dynamicInputView);
    }];
    
    //创建四种类型的图标
    NSArray * sendTypeNormal   = @[@"send_text_normal",@"send_image_normal",@"send_video_normal"];
    NSArray * sendTypeSelected = @[@"send_text_high",@"send_image_high",@"send_video_high"];
    
    for(int i =0;i<sendTypeNormal.count;i++) {

        CGFloat sendW = [_dynamicInputView width]/sendTypeNormal.count;
        
        CGFloat btnSize = 35;
        
        if(i == 2){
            btnSize = 48;
        }
        
        UIButton * typeBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake(i * sendW + (sendW/2 - btnSize/2) - 5,[typeViewBox height]/2 - btnSize/2, btnSize, btnSize))
            .L_BtnImageName(sendTypeNormal[i],UIControlStateNormal)
            .L_BtnImageName(sendTypeSelected[i],UIControlStateSelected)
            .L_TargetAction(self,@selector(sendTypeBtnClick:),UIControlEventTouchUpInside)
            .L_tag(1000 + i)
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_AddView(typeViewBox);
        
        } buttonType:UIButtonTypeCustom];
        
        typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(i == 0){
            typeBtn.selected = YES;
        }
        
        [_dynamicTypeBtnArr addObject:typeBtn];
 
    }
    
}

//上传图片视图
-(void)createUploadView {
    
    //默认高度为90
    _uploadView = [UIView ViewInitWith:^(UIView *view) {
        
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_dynamicInputView bottom] + CARD_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT*2,0))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
        
    }];
    
    //创建图片上传区内容
    [self createPhotosPreview];
    
    
    _uploadView.hidden = YES;
    
}

//上传音频视图
-(void)createRadioView {
    
    _radioView = [UIView ViewInitWith:^(UIView *view) {
        
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_dynamicInputView bottom] + CARD_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT*2,150))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
    }];
    
    
    //上传视图
    UIImageView * uploadRadioView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_radioView width]/2 - 60/2,10,60,60))
        .L_Event(YES)
        .L_ImageName(@"shangchuan")
        .L_Click(self,@selector(radioUploadClick))
        .L_radius(5)
        .L_AddView(_radioView);
    }];
    
    //提示文字
    UILabel * radioLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,[uploadRadioView bottom]+5,[_radioView width],ATTR_FONT_SIZE))
        .L_Text(@"您可以进行录音的上传")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_radioView);
    }];
    
    //音频预览区
    [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(10, [radioLabel bottom]+5, [_radioView width] - 20,50))
        .L_BgColor(HEX_COLOR(@"#EEEEEE"))
        .L_radius(5)
        .L_AddView(_radioView);
    }];
    
    _radioView.hidden = YES;
    
    
}

//创建上传视频的视图
-(void)createVideoView {
    
    _videoView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_dynamicInputView bottom] + CARD_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT*2,350))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
    }];
    
    _videoView.hidden = YES;
    
    //上传视图
    UIImageView * uploadRadioView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_radioView width]/2 - 60/2,10,60,60))
        .L_Event(YES)
        .L_ImageName(@"shangchuan")
        .L_Click(self,@selector(videoUploadClick))
        .L_radius(5)
        .L_AddView(_videoView);
    }];
    
    //提示文字
    UILabel * radioLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,[uploadRadioView bottom]+5,[_radioView width],ATTR_FONT_SIZE))
        .L_Text(@"您可在此处进行视频的上传/修改操作")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(_videoView);
    }];
    
    //视频预览区
    _videoPreview = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(10, [radioLabel bottom]+5, [_radioView width] - 20,250))
        .L_BgColor(HEX_COLOR(@"#EEEEEE"))
        .L_Event(YES)
        .L_ImageMode(UIViewContentModeScaleAspectFill)
        .L_radius(5)
        .L_AddView(_videoView);
    }];
    
    _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_videoPreview width]/2 - 60/2,[_videoPreview height]/2 - 60/2, 60, 60))
        .L_Event(YES)
        .L_Click(self,@selector(playerVideoClick))
        .L_ImageName(@"bofang")
        .L_radius(30)
        .L_AddView(_videoPreview);
    }];
    
    _playerVideoIcon.hidden = YES;
    
}

//创建选项列表
-(void)createSelectItemView {
    
    NSArray * selectIcon     = @[@"location_icon",@"send_music_category",@"send_tag"];
    NSArray * selectArr      = @[@"所在位置",@"动态分类",@"动态标签"];
    NSArray * defaultTextArr = @[@"正在获取位置...",@"设置分类",@"设置标签"];
  
    CGFloat sy = [_dynamicInputView bottom] + 10;
    
    //创建列表容器
    _selectViewBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,sy,[_scrollBoxView width],160))
        .L_AddView(_scrollBoxView);
    }];
    
    CGFloat selectViewY = 0.0;
    
    for(int i =0;i<selectArr.count;i++){
        

        UIView * selectView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,selectViewY,D_WIDTH - CARD_MARGIN_LEFT*2,NORMAL_CELL_HIEGHT))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_tag(i + 1)
            .L_Click(self,@selector(selectViewClick:))
            .L_radius_NO_masksToBounds(5)
            .L_AddView(_selectViewBox);
        }];
        
        //标题图标
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[selectView height]/2 - MIDDLE_ICON_SIZE /2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_ImageName(selectIcon[i])
            .L_AddView(selectView);
        }];
        
        //标题
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right] + CONTENT_PADDING_LEFT,0,100,NORMAL_CELL_HIEGHT))
            .L_Text(selectArr[i])
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(selectView);
            
        }];
        
        //选择内容显示
        UILabel * selectedValue = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([selectView width] - 30 - 200,0,200,[selectView height]))
            .L_textAlignment(NSTextAlignmentRight)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_Tag(100 + i)
            .L_Text(defaultTextArr[i])
            .L_AddView(selectView);
        }];
        
        //重新调整位置信息
        if(i == 0){
            [selectedValue setX:[selectView width] - 212];
        }
        
        if(i != 0){
            
            //右侧箭头ICON
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                imgv
                .L_Frame(CGRectMake([selectView width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE,[selectView height]/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
                .L_ImageName(@"fanhui")
                .L_AddView(selectView);
            }];
            
        }
        
        selectViewY = [selectView bottom] + 5;
        
    }
    
    //设置SCROLL的内容高度
    [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,[_selectViewBox bottom] + 10)];
    
    
}

-(void)createNavigationRightBtn {
    
    R_NAV_TITLE_BTN(@"R",@"发布",sendDynamicBtn)
    
}


#pragma mark - 事件处理

//视频播放按钮
-(void)playerVideoClick {
    NSLog(@"播放视频");
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc] init];
    videoPlayerVC.videoUrl = [_videoUrl absoluteString];
   
    videoPlayerVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoPlayerVC animated:YES completion:nil];
}

//选择录音
-(void)radioUploadClick {
    NSLog(@"选择录音...");
}

//选择视频
-(void)videoUploadClick {
    NSLog(@"选择视频...");
    
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择视频" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        videoVC.delegate = self;
        //[self.navigationController pushViewController:videoVC animated:YES];
        [self presentViewController:videoVC animated:YES completion:nil];
        
    }];
    
    [videoAlertController addAction:cancelAction];
    [videoAlertController addAction:deleteAction];
    
    [self presentViewController:videoAlertController animated:YES completion:nil];
    
    
}

//选择视频回调
-(void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image {
    
    _videoPreview.image = image;
    
    _videoUrl   = url;
    
    _playerVideoIcon.hidden = NO;
    
    [self startActionLoading:@"正在上传动态视频..."];
    
    //上传视频操作,转化成MP4
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]){
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",[NSHomeDirectory() stringByAppendingString:@"/tmp"],[NSString stringWithFormat:@"%u",arc4random() % 99999]];
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse= YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                {
                    SHOW_HINT(@"视频上传失败，请重新尝试");
                }
                    
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    SHOW_HINT(@"视频上传失败，请重新尝试");
                }
                    
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"转换成功");
                {
                    
                    //上传视频
                    NSData * videoData = [NSData dataWithContentsOfFile:exportPath];
                    
                    [NetWorkTools uploadVideo:@{@"video":videoData,@"videoDir":@"dynamicVideo"} Result:^(BOOL results, NSString *fileName) {
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self endActionLoading];
                        });
                        
                        if(!results){
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                SHOW_HINT(@"视频上传失败，请重新尝试");
                            });
                            return;
                        }
                        
                        _videoEndUrl = fileName;
                        
                        //上传升级申请
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self endActionLoading];
                        });
                        
                    }];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }];
    }
    

}

//发布动态
-(void)sendDynamicBtn {
    NSLog(@"右侧按钮...");
    
    //获取动态内容
    NSString * dynamicText = _dynamicTextView.text;
    
    if(dynamicText.length <= 0){
        SHOW_HINT(@"动态内容不能为空");
        [self.view endEditing:YES];
        return;
    }
    
    
    
    if(_cid == -1 || _cid == 0){
        SHOW_HINT(@"请选择动态类型");
        [self.view endEditing:YES];
        return;
    }
    
    NSLog(@"!!!!%ld",(long)_cid);
    
    if([_tagStr isEqualToString:@""]){
        SHOW_HINT(@"请添加动态标签");
        [self.view endEditing:YES];
        return;
    }
    
    
    //参数
    NSMutableDictionary * dynamicParams = [NSMutableDictionary dictionary];
    [dynamicParams setObject:dynamicText        forKey:@"d_content"];
    [dynamicParams setObject:@(_nowDynamicType) forKey:@"d_type"];
    [dynamicParams setObject:@(1)               forKey:@"d_uid"];
    [dynamicParams setObject:_tagStr            forKey:@"d_tags"];
    [dynamicParams setObject:@(_cid)            forKey:@"d_cid"];
    
    NSLog(@"!!!!!!!!!");
    NSLog(@"%@",_uploadImageArr);
    
    //判断地址是否获取成功
    if(![_nowLocation isEqualToString:@"地址信息获取失败"]){
        [dynamicParams setObject:_nowLocation   forKey:@"d_location"];
    }
    
    
    
    if(_nowDynamicType == 0){

        [self startActionLoading:@"动态发布中..."];
        
        [NetWorkTools POST:API_DYNAMIC_ADD params:dynamicParams successBlock:^(NSArray *array) {
            
            [self endActionLoading];
            
            [self.view endEditing:YES];
            SHOW_HINT(@"动态发布成功");
            
            [self.navigationController popViewControllerAnimated:YES];
            
            //重置所有输入
            //[self clearDynamicData];
            
            
            
        } errorBlock:^(NSString *error) {
            SHOW_HINT(@"动态发布失败，请重新尝试");
            NSLog(@"%@",error);
        }];
        
        
    }else if(_nowDynamicType == 1){
        
        if(_uploadImageArr.count == 1){
            SHOW_HINT(@"请选择需要分享的图片");
            return;
        }
        
        //清除最后一张上传显示用图
        [_uploadImageArr removeLastObject];
        
        [self startActionLoading:@"动态发布中..."];

        
        [NetWorkTools uploadMoreImage:_uploadImageArr Result:^(BOOL results, NSArray *fileNames) {
  
            
            if(!results){
                
                [self endActionLoading];
                SHOW_HINT(@"动态发送失败，请重新尝试");
                return;
            }
            
            //发布图片动态
            [dynamicParams setObject:fileNames forKey:@"d_images"];
            
            [NetWorkTools POST:API_DYNAMIC_ADD params:dynamicParams successBlock:^(NSArray *array) {

                [self endActionLoading];
            
                [self.view endEditing:YES];
                SHOW_HINT(@"动态发布成功");
                
                [self.navigationController popViewControllerAnimated:YES];
                //重置所有输入
                //[self clearDynamicData];
            
            } errorBlock:^(NSString *error) {
                SHOW_HINT(@"动态发布失败，请重新尝试");
                NSLog(@"%@",error);
            }];
            
        }];

    }else if(_nowDynamicType == 2){
        
        NSLog(@"处理视频类型的动态上传");
        if(_videoPreview.image == nil){
            SHOW_HINT(@"请选择需要分享的视频");
            return;
        }
        
        
        [self startActionLoading:@"动态发布中..."];
        
        

        
        //上传第一帧图片
        [NetWorkTools uploadImage:@{@"image":_videoPreview.image,@"imageDir":@"dynamicVideo"} Result:^(BOOL results, NSString *fileName) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!results){
                    [self endActionLoading];
                    SHOW_HINT(@"动态发布失败");
                    return;
                }
                
                
                //发布图片动态
                [dynamicParams setObject:fileName forKey:@"d_video_image"];
                [dynamicParams setObject:_videoEndUrl forKey:@"d_video_url"];
                
                
                //发布动态
                [NetWorkTools POST:API_DYNAMIC_ADD params:dynamicParams successBlock:^(NSArray *array) {
                    
                    [self endActionLoading];
                    
                    [self.view endEditing:YES];
                    SHOW_HINT(@"动态发布成功");
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    //重置所有输入
                    //[self clearDynamicData];
                    
                } errorBlock:^(NSString *error) {
                    SHOW_HINT(@"动态发布失败，请重新尝试");
                    NSLog(@"%@",error);
                }];
  
                
            });
            
        }];
        
        
        
    }

}

//选择视图点击事件
-(void)selectViewClick:(UITapGestureRecognizer *)tap {
    
    NSInteger TAG = tap.view.tag;
    
    //选择分类
    if(TAG == 2){
        
        //弹出类别选择窗口
        MusicCategoryPopView * musicCategoryPopView =  [[MusicCategoryPopView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
        musicCategoryPopView.delegate = self;
        [self.navigationController.view addSubview:musicCategoryPopView];
  
        
    //选择标签
    }else if(TAG == 3){
        
        CreateTagViewController * createTagVC = [[CreateTagViewController alloc] init];
        createTagVC.TAG_NAME    = @"CreateInteractionVC";
        createTagVC.defaultTags = _tagStr;
        createTagVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:createTagVC animated:YES];
        
    }
    
}

//获取发送的分类
-(void)sendTypeBtnClick:(UIButton *)sender {
    
    NSInteger tagv = sender.tag;
    
    //当前动态类别
    _nowDynamicType = tagv - 1000;

    //选中点击的
    [self selectedDynamicType:_nowDynamicType];
    
    
    
    if(_nowDynamicType == 0){
        
        //隐藏上传图片视图
        [self hideUploadView];
        
        //隐藏上传视频视图
        [self hideVideoView];
        
        //隐藏上传图片视图
        [self hideUploadView];
        
        
        //设置SCROLL的内容高度
        [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,[_selectViewBox bottom] + 10)];
        
    }else if(_nowDynamicType == 1){
        
        NSLog(@"图片类型...");
        //隐藏上传视频视图
        [self hideVideoView];
        
        //隐藏语音视图
        [self hideRadioView];
        
        //显示图片视图
        [self showUploadView];
        
        //设置SCROLL的内容高度
        [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,[_selectViewBox bottom] + 10)];

        
    }else if(_nowDynamicType == 2){
        
        //隐藏上传图片视图
        [self hideUploadView];
        
        //隐藏语音视图
        [self hideRadioView];
        
        //显示上传视频视图
        [self showVideoView];
        
    }else{
        NSLog(@"类型错误...");
    }

    
    /*
     else if(_nowDynamicType == 2){
     
     //隐藏上传图片视图
     [self hideUploadView];
     
     //隐藏上传视频视图
     [self hideVideoView];
     
     //显示上传语音视图
     [self showRadioView];
     
     }
     */
}

//显示上传视频视图
-(void)showVideoView {
    _videoView.hidden = NO;
    [_selectViewBox setY:[_videoView bottom]+10];
    [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,[_selectViewBox bottom] + 80)];
}

//隐藏上传视频视图
-(void)hideVideoView {
    _videoView.hidden = YES;
    [_selectViewBox setY:[_videoView bottom]+10];
}

//显示上传语音视图
-(void)showRadioView {
    _radioView.hidden = NO;
    [_selectViewBox setY:[_radioView bottom]+10];
    [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,[_selectViewBox bottom] + 10)];
}

//隐藏上传语音视图
-(void)hideRadioView {
    _radioView.hidden = YES;
    [_selectViewBox setY:[_radioView bottom]+10];
}

//点击上传图片
-(void)uploadBtnClick:(UITapGestureRecognizer *)tap {
    
    
    //判断是否为上传按钮
    NSInteger tagv = tap.view.tag;
    
    if(tagv != _uploadImageArr.count - 1){
        return;
    }
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
       [self presentViewController:imagePickerVc animated:YES completion:nil];
        
        
        
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CameraViewController * albumVC = [[CameraViewController alloc] init];
        [self presentViewController:albumVC animated:YES completion:nil];
        
      
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - 代理事件处理
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeHolder.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        
        if (textView.text.length<1) {
            _placeHolder.hidden = NO;
        }
        
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}

//获取类别
-(void)categorySelected:(NSString *)c_name Cid:(NSInteger)c_id {

    UILabel * selectLabel = [self.view viewWithTag:101];
    selectLabel.text = c_name;
    
    _cid   = c_id;
    _cname = c_name;
}

//相册图片选择代理
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@",photos);
    
    //清除数组内容
    [_uploadImageArr removeAllObjects];
    
    //创建上传数据
    for(int i = 0;i<photos.count;i++){
        [_uploadImageArr addObject:@{@"image":photos[i],@"type":@"uploadImage",@"imageDir":@"dynamicImage"}];
    }
    
    //上传按钮
    [_uploadImageArr addObject:@{@"image":@"shangchuan",@"type":@"default"}];
    
    //创建图片预览视图
    [self createPhotosPreview];
    
    
    
}

//创建图片预览视图
-(void)createPhotosPreview {
    
    //清除原有视图
    for(UIView * view in _uploadView.subviews){
        [view removeFromSuperview];
    }
    
    //清除保存的图片视图数组
    [_uploadImageViewArr removeAllObjects];
    
    CGFloat lastBottomY = 0.0;

    for(int i =0;i<_uploadImageArr.count;i++){
        
        NSDictionary * dictData = _uploadImageArr[i];

        //宽度计算
        CGFloat cItemWidth = ([_uploadView width] - 60)/5;
        
        //当前列
        CGFloat col = i % 5;

        
        CGFloat marginRight = 0.0;
        
        if(col > 0){
            marginRight = 10;
        }
        
        //上间距
        CGFloat marginTop = 0.0;
        
        //y位置
        CGFloat row = i / 5;
        
        if(row > 0){
            marginTop = 10;
        }
        
        //x轴
        CGFloat cItemX  = col * (cItemWidth + marginRight);
        
        //y轴
        CGFloat cItemY  = row * (cItemWidth + marginTop);

        //上传图片图标
        UIImageView * uploadImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cItemX+10,cItemY+10,cItemWidth,cItemWidth))
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_Event(YES)
            .L_tag(i)
            .L_radius(5)
            .L_Click(self,@selector(uploadBtnClick:))
            .L_AddView(_uploadView);
        }];
        
        

        
        //创建删除号
        
        if(i != _uploadImageArr.count - 1){
           [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                imgv
                .L_Frame(CGRectMake([uploadImageView width]/2 - 30/2,[uploadImageView height]/2- 30/2,30,30))
                .L_ImageName(@"shanchu")
                .L_Event(YES)
                .L_Alpha(0.5)
                .L_tag(i)
                .L_Click(self,@selector(removeUploadImage:))
                .L_AddView(uploadImageView);
            }];
            
            //添加图片上滑手势
            UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
            [uploadImageView addGestureRecognizer:recognizer];

            
            [_uploadImageViewArr addObject:uploadImageView];
        }
        
        
        if([dictData[@"type"] isEqualToString:@"uploadImage"]){
            uploadImageView.image = dictData[@"image"];
        }else{
            uploadImageView.image = [UIImage imageNamed:@"shangchuan"];
            lastBottomY = [uploadImageView bottom];
        }

    }
    
    [_uploadView setHeight:lastBottomY + 10];
    [_selectViewBox setY:[_uploadView bottom] + 10];
    
}

//图片上滑手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)swip {
    NSInteger tagValue = swip.view.tag;
    
    
    UIImageView * uploadImage = _uploadImageViewArr[tagValue];
    [UIView animateWithDuration:0.3 animations:^{
        [uploadImage setY:-100];
        uploadImage.alpha = 0;
    } completion:^(BOOL finished) {
        //删除数组的图片
        [_uploadImageArr removeObjectAtIndex:tagValue];
        
        [self createPhotosPreview];
    }];
}

//删除某个图片
-(void)removeUploadImage:(UITapGestureRecognizer *)tap {
    NSInteger tagValue = tap.view.tag;
  
    
    UIImageView * uploadImage = _uploadImageViewArr[tagValue];
    [UIView animateWithDuration:0.2 animations:^{
        [uploadImage setWidth:0];
        [uploadImage setHeight:0];
        uploadImage.alpha = 0;
    } completion:^(BOOL finished) {
        //删除数组的图片
        [_uploadImageArr removeObjectAtIndex:tagValue];
        
        [self createPhotosPreview];
    }];
    
    
}


#pragma mark - 私有方法
-(void)selectedDynamicType:(NSInteger)idx {
    
    //选中
    for(int i=0;i<_dynamicTypeBtnArr.count;i++){
        
        UIButton * tempBtn = _dynamicTypeBtnArr[i];
        
        if(i != idx){
            tempBtn.selected   = NO;
        }else{
            tempBtn.selected   = YES;
        }
        
    }
}

//显示上传视图
-(void)showUploadView {
    
    [_uploadView setHeight:([_uploadView width] - 60)/5 + 20];
    _uploadView.hidden = NO;
    [_selectViewBox setY:[_uploadView bottom]+10];
    
}

//隐藏上传视图
-(void)hideUploadView {
    
    [_uploadView setHeight:0];
    _uploadView.hidden = YES;
    [_selectViewBox setY:[_uploadView bottom]+10];
    
}

//发送成功后清除数据
-(void)clearDynamicData {
    
    //清除内容
    _dynamicTextView.text = @"";
    _placeHolder.hidden   = NO;
    
    //恢复文字类型
    _nowDynamicType    = 0;
    [self selectedDynamicType:_nowDynamicType];
    
    //恢复类型分类选择
    _cid  = -1;
    UILabel * selectCategoryLabel = [self.view viewWithTag:101];
    selectCategoryLabel.text      = @"设置分类";
    
    //恢复标签选择
    _tagStr = @"";
    UILabel * selectTagsLabel = [self.view viewWithTag:102];
    selectTagsLabel.text      = @"设置标签";
    
    //清除上传图片数组
    if(_nowDynamicType == 1){
        [_uploadImageArr removeAllObjects];
        [_uploadImageArr addObject:@{@"image":@"shangchuan",@"type":@"default"}];
        [self createPhotosPreview];
    }
}


#pragma mark - 通知相关,获取标签数据
-(void)selectedTags:(NSNotification *)notification{

    UILabel * selectLabel = [self.view viewWithTag:102];
    _tagStr = notification.userInfo[@"tagStr"];
    selectLabel.text = _tagStr;
}

//屏幕将要开始滚动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"视图准备开始滚动...");
}

@end
