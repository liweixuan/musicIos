#import "CustomNavigationController.h"

@interface CustomNavigationController () {
    
    UINavigationBar * _bar;
    NSShadow        * _shadow;

}
@end

@implementation CustomNavigationController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //去掉NavigationBar的下边线
    [self removeBottomLine];
    
    //自定义NavigationBar中的一些样式
    _bar = [UINavigationBar appearance];
    
    //设置不透明
    self.navigationBar.translucent = NO;
    
    //设置阴影
    self.navigationBar.layer.shadowColor = [UIColor grayColor].CGColor;
    
    //设置阴影偏移范围
    self.navigationBar.layer.shadowOffset = CGSizeMake(3,3);
    
    //设置阴影颜色的透明度
    self.navigationBar.layer.shadowOpacity = 0.1;

    //判断是否使用了图片作为导航条背景
    if(IS_IMG_NAV){
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:IMG_NAV_NAME] forBarMetrics:UIBarMetricsDefault];
    }else{
        [_bar setBarTintColor:HEX_COLOR(NAV_BG_COLOR)];
    }
    
    //设置字体风格(文字颜色，阴影颜色，阴影偏移，字体大小)
    _shadow    = [[NSShadow alloc] init];
    _shadow.shadowColor  = [UIColor clearColor];
    _shadow.shadowOffset = CGSizeMake(0,0);
    
    NSDictionary *fontStyle = @{
            NSForegroundColorAttributeName:HEX_COLOR(NAV_FONT_COLOR),
            NSShadowAttributeName:_shadow,
            NSFontAttributeName:[UIFont fontWithName:NAV_FONT_STYLE_COLOR size:NAV_FONT_SIZE_COLOR]
    };
    [_bar setTitleTextAttributes:fontStyle];
    
    //更改后退按钮颜色
    [_bar setTintColor:HEX_COLOR(NAV_BACK_COLOR)];
    
    
    
    
}

#pragma mark - 去掉NavigationBar的下边线
-(void)removeBottomLine {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
}

#pragma mark - 统一设置 返回按钮的风格在push时
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    if(!IS_NAV_BACK_TITLE){
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        viewController.navigationItem.backBarButtonItem = item;
    }
    
}


@end
