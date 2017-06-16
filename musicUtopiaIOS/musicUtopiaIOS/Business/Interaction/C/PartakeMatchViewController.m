#import "PartakeMatchViewController.h"
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicScoreDetailViewController.h"

@interface PartakeMatchViewController ()<VideoDelegate>
{
    UIImageView * _videoCover;
    UIImageView * _playerVideoIcon;
    UIImageView * _addVideoIcon;
    UILabel     * _addVideoHint;
    UIButton    * _resetBtn;
    
    NSURL       * _videoUrl;
    NSString    * _videoEndUrl;
}
@end

@implementation PartakeMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与比赛";
    
    [self initVar];
    
    
    [self createNav];
    
    //创建视图
    [self createView];
    
        NSLog(@"%ld",(long)self.matchId);
        NSLog(@"%ld",(long)self.musicScorePage);
        NSLog(@"%ld",(long)self.musicScoreId);
        NSLog(@"%@",self.musicScoreName);
}

-(void)initVar {
    _videoEndUrl = @"";
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"参赛曲谱",matchMusicScore);
}

-(void)createView {
    
    _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,D_WIDTH - CARD_MARGIN_LEFT * 2,280))
        .L_BgColor([UIColor whiteColor])
        .L_radius(5)
        .L_AddView(self.view);
    }];
    
    
    _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,280/2 - 60/2 - 20, 60, 60))
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
        .L_Text(@"参赛演奏视频")
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
    
    //提交按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,D_HEIGHT_NO_NAV - BOTTOM_BUTTON_HEIGHT - 15,D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"提交参赛视频",UIControlStateNormal)
        .L_TargetAction(self,@selector(partakeMatch),UIControlEventTouchUpInside)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_ShadowColor([UIColor grayColor])
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
}

-(void)playerVideoClick {
    NSLog(@"播放视频");
}


-(void)addVideoClick {
    
    
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
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
  
    _videoCover.image = image;
    
    _videoUrl   = url;
    
    _playerVideoIcon.hidden = NO;
    _resetBtn.hidden        = NO;
    _addVideoIcon.hidden    = YES;
    _addVideoHint.hidden    = YES;
}


-(void)submitMatch{
    NSLog(@"确定参赛...");
    
    //判断是否有视频数据，视频上传操作
    if(_videoUrl != nil){

        
        NSString * dir = @"userMatchVideo";
        
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
                            
                            //创建团体
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self partakeMatch];
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

-(void)partakeMatch {
    NSLog(@"参赛接口提交...");
    
    if([_videoEndUrl isEqualToString:@""]){
        SHOW_HINT(@"请先上传参赛视频");
        return;
    }
    
    NSDictionary * params = @{
            @"mpu_mid":@(self.matchId),
            @"mpu_uid":@([UserData getUserId]),
            @"mpu_video_url":_videoEndUrl
    };
    
    [self startActionLoading:@"参赛信息提交中..."];
    [NetWorkTools POST:API_MATCH_PARTAKE params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        SHOW_HINT(@"比赛参与成功,已上传您的参赛视频");
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
}

//查看参赛曲谱
-(void)matchMusicScore {
    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    musicScoreDetailVC.musicScoreName = self.musicScoreName;
    musicScoreDetailVC.imageCount     = self.musicScorePage;
    musicScoreDetailVC.musicScoreId   = self.musicScoreId;
    musicScoreDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];
}
@end
