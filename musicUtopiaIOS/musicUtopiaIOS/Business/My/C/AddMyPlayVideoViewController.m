#import "AddMyPlayVideoViewController.h"
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AddMyPlayVideoViewController ()<VideoDelegate>
{
    UIImageView * _videoCover;
    UIImageView * _playerVideoIcon;
    UIImageView * _addVideoIcon;
    UILabel     * _addVideoHint;
    UIButton    * _resetBtn;
    NSURL       * _videoUrl;
    NSString    * _videoEndUrl;
    UITextField * _videoNameInput;
}
@end

@implementation AddMyPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加视频集";
    
    [self initVar];
    
    //
    [self createNav];
    
    //创建视图
    [self createView];
}

-(void)initVar {
    _videoEndUrl = @"";
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"确定上传",submitPlayView);
}

-(void)createView {
    
    //创建视频名称录入框
    _videoNameInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,D_WIDTH - CARD_MARGIN_LEFT * 2, TEXTFIELD_HEIGHT))
        .L_Placeholder(@"视频名称")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_PaddingLeft(10)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    }];
    
    _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_videoNameInput bottom]+15,D_WIDTH - CARD_MARGIN_LEFT * 2,280))
        .L_BgColor([UIColor whiteColor])
        .L_ImageMode(UIViewContentModeScaleAspectFill)
        .L_radius(5)
        .L_AddView(self.view);
    }];
    
    
    _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,[_videoNameInput bottom]+15 + (280/2 - 60/2 - 20), 60, 60))
        .L_ImageName(@"addIcon")
        .L_Event(YES)
        .L_Click(self,@selector(addVideoClick))
        .L_radius(30)
        .L_AddView(self.view);
    }];
    
    _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,[_videoNameInput bottom]+15 + (280/2 - 60/2 - 20), 60, 60))
        .L_Event(YES)
        .L_Click(self,@selector(playerVideoClick))
        .L_ImageName(@"bofang")
        .L_radius(30)
        .L_AddView(self.view);
    }];
    _playerVideoIcon.hidden = YES;
    
    //更改按钮
    _resetBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(D_WIDTH/2 - 120/2,[_playerVideoIcon bottom] +15, 120,35))
        .L_TargetAction(self,@selector(addVideoClick),UIControlEventTouchUpInside)
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"重新上传",UIControlStateNormal)
        .L_Font(CONTENT_FONT_SIZE)
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_Alpha(0.8)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
    _resetBtn.hidden = YES;
    
    
    _addVideoHint = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/2 - 100/2,[_addVideoIcon bottom]+15,100,TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_Text(@"我的演奏视频")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
    //创建提示信息
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([_videoCover left],[_videoCover bottom], [_videoCover width],50))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"注意：上传视频应不超过5分钟以上")
        .L_AddView(self.view);
    }];
    
}

-(void)playerVideoClick {
    NSLog(@"播放视频");
}


-(void)addVideoClick {
    
    
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择视频" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        videoVC.delegate = self;
        [self presentViewController:videoVC animated:YES completion:nil];
        
    }];
    
    [videoAlertController addAction:cancelAction];
    [videoAlertController addAction:deleteAction];
    
    [self presentViewController:videoAlertController animated:YES completion:nil];
    
    
}

//选择视频回调
-(void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image {
    
    _videoCover.image       = image;
    _videoUrl               = url;
    _playerVideoIcon.hidden = NO;
    _resetBtn.hidden        = NO;
    _addVideoIcon.hidden    = YES;
    _addVideoHint.hidden    = YES;
}

-(void)submitPlayView {
    
    NSLog(@"!!!!!%@",_videoUrl);
    
    if([_videoNameInput.text isEqualToString:@""]){
        SHOW_HINT(@"视频名称不能为空");
        return;
    }
    
    //判断是否有视频数据，视频上传操作
    if(_videoUrl != nil){
        
        
        NSString * dir = @"userPlayVideo";
        
        //转化成MP4
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
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self startActionLoading:@"正在上传视频..."];
                        });
                        [NetWorkTools uploadVideo:@{@"video":videoData,@"videoDir":dir} Result:^(BOOL results, NSString *fileName) {
                            
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
                            
                            //上传个人演奏集
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self createUserPlayVideo];
                            });
                            
                        }];
                        
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }else {
        SHOW_HINT(@"您还没有上传演奏视频");
    }
    
}

-(void)createUserPlayVideo {
    
    //上传第一帧图片作为封面图
    [self startActionLoading:@"正在添加个人演奏集..."];
    [NetWorkTools uploadImage:@{@"image":_videoCover.image,@"imageDir":@"userPlayVideo"} Result:^(BOOL results, NSString *fileName) {
   
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            if(!results){
                [self endActionLoading];
                SHOW_HINT(@"图片上传失败");
                return;
            }
            
            
            NSDictionary * addParams = @{
                @"upv_url"       : _videoEndUrl,
                @"upv_name"      : _videoNameInput.text,
                @"upv_uid"       : @([UserData getUserId]),
                @"upv_image_url" : fileName
            };
            
            
            [NetWorkTools POST:API_USER_PLAY_VIDEO_ADD params:addParams successBlock:^(NSArray *array) {
                [self endActionLoading];
                
                SHOW_HINT(@"演奏视频添加成功");
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } errorBlock:^(NSString *error) {
                [self endActionLoading];
                SHOW_HINT(error);
            }];
            
        });
        
       
    }];
    
}
@end
