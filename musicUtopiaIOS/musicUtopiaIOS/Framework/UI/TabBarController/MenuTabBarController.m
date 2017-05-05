#import "MenuTabBarController.h"
#import "CustomNavigationController.h"

@interface MenuTabBarController(){
    NSMutableArray * _tabBarItemArr; //保存所有的tabbaritem对象
}
@end

@implementation MenuTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建菜单
    [self createMainMenu];
    
}

#pragma mark - 创建主菜单
-(void)createMainMenu {
    
    //获取创建菜单所需plist数据
    NSString *menuPlist   = [[NSBundle mainBundle] pathForResource:@"MainMenuData" ofType:@"plist"];
    NSArray  *menuDataArr = [NSArray arrayWithContentsOfFile:menuPlist];
 
    NSMutableArray *menuViewControllerArr = [NSMutableArray array];
    for(int i = 0;i<menuDataArr.count;i++){
        
        //拿出每项数据
        NSDictionary *controllerData = menuDataArr[i];
        NSString *vcName = [controllerData objectForKey:@"controller"];
        Class controllerClass = NSClassFromString(vcName);
        id controllerObject = [[controllerClass alloc] init];
        
        //创建导航控制器
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:controllerObject];
        [menuViewControllerArr addObject:nav];
    }
    
    //将导航控制器加入到tabbar控制器中
    self.viewControllers = menuViewControllerArr;
    
    //设置tabbar为不透明
    self.tabBar.translucent = NO;
    
    //获取底部tabbar视图
    UITabBar *tabBar = self.tabBar;
    
    //设置tabbar视图的背景颜色
    tabBar.barTintColor = HEX_COLOR(TAB_BG_COLOR);
    
    //设置tabbar被选中时的字体颜色
    tabBar.tintColor = HEX_COLOR(TAB_FONT_COLOR);

    //初始化用于保存tabbaritem对象的数组
    _tabBarItemArr = [NSMutableArray array];
    
    //获取每个tabbaritem菜单对象,并保存
    for(int i=0;i<menuDataArr.count;i++){
        
        //拿出每项菜单数据
        NSDictionary *itemData = menuDataArr[i];
        
        UITabBarItem *item = [tabBar.items objectAtIndex:i];        //取item对象
        item.title         = [itemData objectForKey:@"itemName"];   //设置菜单名称
        
        //设置标题位置
        item.titlePositionAdjustment = UIOffsetMake(0, -4);
        
        //为每个item设置tag值
        item.tag = i;
        
        //设置选中时图片
        item.selectedImage = [[UIImage imageNamed:[itemData objectForKey:@"itemIconHLName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //设置默认图片
        item.image = [[UIImage imageNamed:[itemData objectForKey:@"itemIconName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //存储item对象
        [_tabBarItemArr addObject:item];
    }
    
}


@end
