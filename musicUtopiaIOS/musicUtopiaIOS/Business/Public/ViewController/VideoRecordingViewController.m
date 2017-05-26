#import "VideoRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>

#define VIDEO_MAX_TIME 15  //最大视频录制时间
#define VIDEO_MIN_TIME 3   //最小视频录制时间

@interface VideoRecordingViewController ()<AVCaptureFileOutputRecordingDelegate>
{
    UIView                     * _videoPreviewView;         //视频预览视图
    UIButton                   * _recordBtn;                //录制按钮
    UIButton                   * _sendBtn;                  //发送按钮
    UIButton                   * _cancelSendBtn;            //取消发送按钮
    UIButton                   * _changeCrameBtn;           //切换前后置按钮
    AVCaptureSession           * _captureSession;           //负责输入和输出设置之间的数据传递
    AVCaptureDeviceInput       * _captureDeviceInput;       //负责从AVCaptureDevice获得输入数据
    AVCaptureMovieFileOutput   * _captureMovieFileOutput;   //视频输出流
    AVCaptureVideoPreviewLayer * _captureVideoPreviewLayer; //相机拍摄预览图层
    UIBackgroundTaskIdentifier   _backgroundTaskIdentifier; //后台任务标识
    
    UIView                     * _progressView;             //进度容器条视图
    UIView                     * _progressLoadingView;      //已加载长度
    
    NSTimer                    * _timer;                    //计时器对象
    
    NSInteger                    _recordTime;               //已录制的时间
    
    AVPlayer                   * _videoPlayer;              //视频播放对象
    UIView                     * _accordingView;            //视频播放视图
    
    BOOL                         _isEndRecord;              //是否有已录制的视频
    
}
@end

@implementation VideoRecordingViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]);
    
    //设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化变量
    [self initVar];
    
    //创建视频预览容器
    [self createVideoPreview];
    
    //创建相关操作按钮
    [self createAction];
    
    //录制进度视图
    [self createRecordProgressView];
    
    
    //视频播放视图
    [self createAccordingView];
 
    
}


//初始化变量
-(void)initVar {
    _recordTime  = 0;
    _isEndRecord = NO;
}

//创建发送和取消按钮
-(void)createSendAndCancelView {

    UIView * SendAndCancelView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - 80 - 80,self.view.frame.size.width,80)];
    [_accordingView addSubview:SendAndCancelView];
    
    //取消发送按钮
    _cancelSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelSendBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelSendBtn.backgroundColor = [UIColor whiteColor];
    [_cancelSendBtn addTarget:self action:@selector(resteVideoRecord) forControlEvents:UIControlEventTouchUpInside];
    [_cancelSendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancelSendBtn.frame = CGRectMake(((self.view.frame.size.width/2)/2 - 80/2),0,80,80);
    _cancelSendBtn.layer.shadowOffset  = CGSizeMake(3,3);
    _cancelSendBtn.layer.shadowColor   = [UIColor grayColor].CGColor;
    _cancelSendBtn.layer.shadowOpacity = 0.2;
    _cancelSendBtn.layer.cornerRadius  = 40;
    _cancelSendBtn.layer.borderWidth = 5;
    _cancelSendBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [SendAndCancelView addSubview:_cancelSendBtn];
    
    //发送按钮
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.backgroundColor = [UIColor whiteColor];
    [_sendBtn addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _sendBtn.frame = CGRectMake(self.view.frame.size.width/2 + ((self.view.frame.size.width/2)/2 - 80/2),0,80,80);
    _sendBtn.layer.shadowOffset  = CGSizeMake(3,3);
    _sendBtn.layer.shadowColor   = [UIColor grayColor].CGColor;
    _sendBtn.layer.shadowOpacity = 0.2;
    _sendBtn.layer.cornerRadius  = 40;
    _sendBtn.layer.borderWidth = 5;
    _sendBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [SendAndCancelView addSubview:_sendBtn];
   
}

//视频播放视图
-(void)createAccordingView {
    _accordingView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
    _accordingView.backgroundColor = [UIColor whiteColor];
    _accordingView.alpha = 0.0;
    [self.view addSubview:_accordingView];
}


//录制进度视图
-(void)createRecordProgressView {
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_recordBtn.frame)+ 20,self.view.frame.size.width - 30,10)];
    _progressView.backgroundColor     = [UIColor lightGrayColor];
    _progressView.layer.borderWidth   = 1;
    _progressView.layer.cornerRadius  = 5;
    _progressView.layer.masksToBounds = YES;
    _progressView.hidden              = YES;
    _progressView.layer.borderColor   = [UIColor grayColor].CGColor;
    _progressView.layer.shadowOffset  = CGSizeMake(3,3);
    _progressView.layer.shadowColor   = [UIColor grayColor].CGColor;
    _progressView.layer.shadowOpacity = 0.2;
    [self.view addSubview:_progressView];
    
    _progressLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,_progressView.frame.size.height)];
    _progressLoadingView.backgroundColor = [UIColor orangeColor];
    [_progressView addSubview:_progressLoadingView];
}

//创建相关操作按钮
-(void)createAction {
    
    //录制按钮
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setTitle:@"录制" forState:UIControlStateNormal];
    _recordBtn.backgroundColor = [UIColor whiteColor];
    [_recordBtn addTarget:self action:@selector(startVideoRecord) forControlEvents:UIControlEventTouchUpInside];
    [_recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _recordBtn.frame = CGRectMake(self.view.frame.size.width/2 - 80/2,self.view.frame.size.height - 80 - 40,80,80);
    _recordBtn.layer.shadowOffset  = CGSizeMake(3,3);
    _recordBtn.layer.shadowColor   = [UIColor grayColor].CGColor;
    _recordBtn.layer.shadowOpacity = 0.2;
    _recordBtn.layer.cornerRadius  = 40;
    _recordBtn.layer.borderWidth = 5;
    _recordBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_recordBtn];

    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSendVideo) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(15,35, 40,20);
    [self.view addSubview:cancelBtn];
    
    //切换前后置摄像头
    _changeCrameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeCrameBtn setTitle:@"切换" forState:UIControlStateNormal];
    [_changeCrameBtn addTarget:self action:@selector(changeCrameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_changeCrameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _changeCrameBtn.frame = CGRectMake(self.view.frame.size.width - 40 - 15,35, 40,20);
    [self.view addSubview:_changeCrameBtn];

    
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_captureSession stopRunning];
}

//初始化相关视频录制对象
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //初始化会话
    _captureSession = [[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) { //设置分辨率
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    //添加一个音频输入设备
    AVCaptureDevice * audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    
    CALayer * layer = _videoPreviewView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    //开启摄像
    [_captureSession startRunning];


 
}

//创建视频预览容器
-(void)createVideoPreview {
    
    _videoPreviewView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:_videoPreviewView];
    
}

#pragma mark - 事件

//关闭录制
-(void)closeVideoRecord {
    [_captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//开始录制
-(void)startVideoRecord{
    
    //获取当前进行的文字
    NSString * title  = _recordBtn.titleLabel.text;
    
    if([title isEqualToString:@"录制"]){
        
        NSLog(@"11111");
        //启动进度条动画
        [self startProgressAnimate];

        _changeCrameBtn.hidden = YES;
       
        [_recordBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        //录制
        [self startRecord];
  
        
        
    }else{
        
        
        //停止进度条动画
        [self stopProgressAnimate];
        NSLog(@"22222");
        
        _changeCrameBtn.hidden = NO;
        
        [_recordBtn setTitle:@"录制" forState:UIControlStateNormal];

        //录制
        [self startRecord];
            
       

        
        
        

        
    }
    
    
    
    
    
    
}


//录制开始
-(void)startRecord {
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //根据连接取得设备输出的数据
    if (![_captureMovieFileOutput isRecording]) {
        
        
        NSLog(@"开始录制...");
        
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            _backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[_captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        
        NSLog(@"save path is :%@",outputFielPath);
        
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [_captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        
    }
    else{
        
        
        NSLog(@"停止录制...");
        
        if(_recordTime <= VIDEO_MIN_TIME){
            
            NSLog(@"视频录制时间过短");
           
            //关闭定时器
            _recordTime = 0;
//            //预览图层和视频方向保持一致
//            captureConnection.videoOrientation=[_captureVideoPreviewLayer connection].videoOrientation;
//            NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
//            
//            NSLog(@"save path is :%@",outputFielPath);
//            
//            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
//            [_captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
            
            
            
        }else{
            
            //录制完毕,关闭定时器
            _recordTime = 0;
           
            [_captureMovieFileOutput stopRecording];//停止录制
        }
        
        
        
    }
}

//发送该视频
-(void)sendVideo {
    NSLog(@"发送该视频");
    
    
}

//取消发送
-(void)cancelSendVideo {
    
    NSLog(@"asdasdasdsadassd");
    
    //提示是否放弃保存
    if(_isEndRecord){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认放弃录制视频" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
          [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
}


#pragma mark - 代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    //进度条初始化
    CGRect frame               = _progressLoadingView.frame;
    frame.size.width           = 0;
    _progressLoadingView.frame = frame;
    
    NSLog(@"完成录制,可以自己做进一步的处理");
    NSLog(@"%@",outputFileURL);
    NSLog(@"%@",connections);
    NSLog(@"%@",error);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),@"myMovie.mov"];
    if([fileManager fileExistsAtPath:filePath]){
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]){
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",[NSHomeDirectory() stringByAppendingString:@"/tmp"],[NSString stringWithFormat:@"%u",arc4random() % 10000]];
            exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse= YES;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        //视频转化失败
                        
                        
                        
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Export canceled");
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        NSLog(@"转换成功");
                        
                    {
                        
                        _isEndRecord = YES;
                        
                        //播放视频
                        dispatch_sync(dispatch_get_main_queue(), ^{
                        
                            [self playervideo:exportPath];
                            
                        });
                       
   
                    }
                        
                        
                        break;
                    default:
                        break;
                }
            }];
        }
        
        
    }
    
    
   
    
}

-(void)playervideo:(NSString *)url {
    
    [UIView animateWithDuration:0.3 animations:^{
        _accordingView.alpha = 1;
    }];
    
    
    NSURL *movieUrl = [NSURL fileURLWithPath:url];
    // 创建 AVPlayer 播放器
    _videoPlayer = [AVPlayer playerWithURL:movieUrl];
    
    // 将 AVPlayer 添加到 AVPlayerLayer 上
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    
    // 设置播放页面大小
    playerLayer.frame = CGRectMake(0, 0, _accordingView.frame.size.width, _accordingView.frame.size.height);
    
    // 设置画面缩放模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 在视图上添加播放器
    [_accordingView.layer addSublayer:playerLayer];
    
    [self createSendAndCancelView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification   object:_videoPlayer.currentItem];
    
       // 开始播放
    [_videoPlayer play];
}

- (void)playbackFinished:(NSNotification *)noti
{
    
    NSLog(@"MP4文件读完了");
    
    [_videoPlayer seekToTime:kCMTimeZero];
    
    [_videoPlayer play];
    
}

//切换前后置
-(void)changeCrameBtnClick {
    AVCaptureDevice *currentDevice=[_captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [_captureSession beginConfiguration];
    //移除原有输入对象
    [_captureSession removeInput:_captureDeviceInput];
    //添加新的输入对象
    if ([_captureSession canAddInput:toChangeDeviceInput]) {
        [_captureSession addInput:toChangeDeviceInput];
        _captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [_captureSession commitConfiguration];
}

//重新录制
-(void)resteVideoRecord {
    
    [_videoPlayer pause];
    
    [UIView animateWithDuration:0.2 animations:^{
        _accordingView.alpha = 0.0;
        
    }];
    
}


#pragma mark - 私有方法
/**
 *  取得指定位置的摄像头
 *  @param position 摄像头位置
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

//开始进度条动画
-(void)startProgressAnimate {
    
    NSLog(@"123123123123");
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = _recordBtn.frame;
        frame.origin.y = self.view.frame.size.height - 80 - 80;
        _recordBtn.frame = frame;
        
    }];

    //启动计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoTimer) userInfo:nil repeats:YES];
    
    //显示进度条
    _progressView.hidden = NO;
    
}

//停止动画进度
-(void)stopProgressAnimate {
    
    NSLog(@"12321321312312");
    
    //显示进度条
    _progressView.hidden = YES;
    

    CGRect frame               = _progressLoadingView.frame;
    frame.size.width           = 0;
    _progressLoadingView.frame = frame;
  
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = _recordBtn.frame;
        frame.origin.y = self.view.frame.size.height - 80 - 40;
        _recordBtn.frame = frame;
        
    }];
    
    
    [_timer invalidate];
    
}

-(void)videoTimer {
    
    _recordTime++;
    
    if(_recordTime > VIDEO_MAX_TIME){
        
        //录制完毕,关闭定时器
        _recordTime = 0;
        [_timer invalidate];
        
        
        NSLog(@"自动录制完毕...");
        [self startRecord];
        
        _progressView.hidden = YES;
        
        //恢复文字
        [_recordBtn setTitle:@"录制" forState:UIControlStateNormal];
        
        return;
        
        
    }
    
    CGFloat progressBoxW     = _progressView.frame.size.width;
    CGFloat everySecondW     = progressBoxW / VIDEO_MAX_TIME;

    CGFloat nowProgressValue = everySecondW * _recordTime;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame               = _progressLoadingView.frame;
        frame.size.width           = nowProgressValue;
        _progressLoadingView.frame = frame;
        
    }];
 
    
}

@end
