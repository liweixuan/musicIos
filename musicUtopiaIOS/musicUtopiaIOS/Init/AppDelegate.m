#import "AppDelegate.h"
#import "AppDelegate+Expand.h"
#import "HintManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 * 应用程序启动，并进行初始化时候调用该方法
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //初始化window
    [self initWindow];
    
    //初始化启动界面
    [self initLaunchScreen:^{
        
        //初始化应用相关配置
        [self initAppConfig];
        
        //初始化底部菜单
        [self initTabBar];
        
        //设置状态栏相关
        [self setStatusStyle];
        
    }];

    return YES; 
}


/*
 * 当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

/*
 * 当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

/*
 * 当程序从后台将要重新回到前台时候调用
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

/*
 * 当应用程序入活动状态执行
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {

}

/*
 * iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

/*
 * 当系统时间发生改变时执行
 */
- (void)applicationSignificantTimeChange:(UIApplication*)application {
    
}


/*
 * 当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作
 */
- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
