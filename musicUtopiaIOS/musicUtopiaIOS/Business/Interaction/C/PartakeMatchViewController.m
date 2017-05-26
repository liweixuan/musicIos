#import "PartakeMatchViewController.h"
#import "VideoViewController.h"

@interface PartakeMatchViewController ()<VideoDelegate>
{
    UIImageView       * _videoCover;
    UIImageView       * _playerVideoIcon;
    UIImageView       * _addVideoIcon;
}
@end

@implementation PartakeMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与比赛";
    
    [self createNav];
    
    //创建视图
    [self createView];
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"确定参赛",submitMatch);
}

-(void)createView {
    
    _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,D_WIDTH - CARD_MARGIN_LEFT * 2,250))
        .L_BgColor([UIColor whiteColor])
        .L_radius(5)
        .L_AddView(self.view);
    }];
    
    
    _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 20, 60, 60))
        .L_ImageName(@"addIcon")
        .L_Event(YES)
        .L_Click(self,@selector(addVideoClick))
        .L_radius(30)
        .L_AddView(self.view);
    }];
    
    _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 20, 60, 60))
        .L_ImageName(@"bofang")
        .L_radius(30)
        .L_AddView(self.view);
    }];
    _playerVideoIcon.hidden = YES;
    
    [UILabel LabelinitWith:^(UILabel *la) {
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
    NSLog(@"11111");
   _videoCover.image = image;
}


-(void)submitMatch{
    NSLog(@"确定参赛...");
}
@end
