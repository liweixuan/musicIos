#import "InstrumentEvaluationViewController.h"
#import "UpgradeMusicScoreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoViewController.h"

@interface InstrumentEvaluationViewController ()<VideoDelegate>
{
    UIImageView * _videoCover;
    UIImageView * _playerVideoIcon;
    UIImageView * _addVideoIcon;
    UILabel     * _addVideoHint;
    UIButton    * _resetBtn;
    
    NSURL       * _videoUrl;
    NSString    * _videoEndUrl;
    
    NSInteger     _nowCid;
    NSInteger     _nowLevel;
}
@end

@implementation InstrumentEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乐器评测";
    
    //
    [self initVar];
    
    //创建导航菜单
    [self createNav];
    
    //创建视图
    [self createView];
    
}

-(void)initVar {
 
    _nowCid   = self.cid;
    _nowLevel = self.level + 1;
    
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"评测曲谱", upgradeMusicScore)
}

-(void)createView {
    
    //上传评测视频标题图片
    UIImageView * evaluationIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
        .L_ImageName(@"send_video_normal")
        .L_AddView(self.view);
    }];
    
    //上传评测演奏标题
    UILabel * evaluationLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([evaluationIcon right]+ICON_MARGIN_CONTENT,[evaluationIcon top]+2,D_WIDTH,TITLE_FONT_SIZE))
        .L_Text(@"上传评测视频")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
    //提示信息
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 200, [evaluationIcon top]+2,200,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_Text(@"古典吉他 / 2 级")
        .L_textAlignment(NSTextAlignmentRight)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
    
    _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[evaluationLabel bottom]+10,D_WIDTH - CARD_MARGIN_LEFT * 2,280))
        .L_BgColor([UIColor whiteColor])
        .L_radius(5)
        .L_AddView(self.view);
    }];
    
    
    _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,280/2 - 60/2 + 20, 60, 60))
        .L_ImageName(@"addIcon")
        .L_Event(YES)
        .L_Click(self,@selector(addVideoClick))
        .L_radius(30)
        .L_AddView(self.view);
    }];
    
    _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,[_videoCover height]/2 - 60/2, 60, 60))
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
        .L_Text(@"评测视频")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(self.view);
    }];
    
    //创建提示信息
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([_videoCover left],[_videoCover bottom], [_videoCover width],80))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_numberOfLines(0)
        .L_Text(@"注意：上传视频应不超过5分钟以上,可以点击【评测曲谱】查看需要演奏的乐曲,可在该曲谱中任意选择一首进行升级评测,视频提交后评测通过后您在该乐器的级别将的到提升")
        .L_lineHeight(6)
        .L_AddView(self.view);
    }];
    
    //更改按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,D_HEIGHT_NO_NAV - 55, D_WIDTH - CARD_MARGIN_LEFT * 2,BOTTOM_BUTTON_HEIGHT))
        .L_TargetAction(self,@selector(upgradeClick),UIControlEventTouchUpInside)
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"提交升级视频",UIControlStateNormal)
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
}


-(void)upgradeMusicScore {
    NSLog(@"查看过级曲谱");
    
    UpgradeMusicScoreViewController * upgradeMusicScoreVC = [[UpgradeMusicScoreViewController alloc] init];
    upgradeMusicScoreVC.cid   = _nowCid;
    upgradeMusicScoreVC.level = _level;
    [self.navigationController pushViewController:upgradeMusicScoreVC animated:YES];
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


-(void)playerVideoClick {
    
}

//选择视频回调
-(void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image {
    
    _videoCover.image = image;
    
    _videoUrl   = url;
    
    _playerVideoIcon.hidden = NO;
    _resetBtn.hidden        = NO;
    _addVideoIcon.hidden    = YES;
    _addVideoHint.hidden    = YES;
}


-(void)upgradeClick{

    //判断是否有视频数据，视频上传操作
    if(_videoUrl != nil){
        
        [self startActionLoading:@"正在上传视频..."];
        
        NSString * dir = @"userUpgradeVideo";
        
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
                            
                            //上传升级申请
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self userUpgradeSubmit];
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
}

-(void)userUpgradeSubmit {

    //上传第一帧图片作为封面图
    [self startActionLoading:@"正在提交升级评测申请..."];
    [NetWorkTools uploadImage:@{@"image":_videoCover.image,@"imageDir":@"userUpgradeVideo"} Result:^(BOOL results, NSString *fileName) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if(!results){
                [self endActionLoading];
                SHOW_HINT(@"图片上传失败");
                return;
            }
            
            
            NSDictionary * addParams = @{
                                         @"uuv_video_url" : _videoEndUrl,
                                         @"uuv_cid"       : @(_nowCid),
                                         @"uuv_level"     : @(_nowLevel),
                                         @"uuv_uid"       : @([UserData getUserId]),
                                         @"uuv_image_url" : fileName
            };
            
            NSLog(@"%@",addParams);
            
            
            [NetWorkTools POST:API_USER_UPGRADE_APPLY params:addParams successBlock:^(NSArray *array) {
                [self endActionLoading];
                
                SHOW_HINT(@"升级视频上传成功，请等待评测");
                
                
                
            } errorBlock:^(NSString *error) {
                [self endActionLoading];
                SHOW_HINT(error);
            }];
            
        });
        
    }];
}
@end
