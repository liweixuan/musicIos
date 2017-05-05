#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //启动画面过渡
    UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    
    //判断设备
    if(IS_IPHONE_4){
        startImageView.image = [UIImage imageNamed:@"launch_screen_4s.jpg"];
    }else{
        startImageView.image = [UIImage imageNamed:@"launch_screen_other.jpg"];
    }
    
    //将启动视图添加至控制器
    [self.view addSubview:startImageView];
}


@end
