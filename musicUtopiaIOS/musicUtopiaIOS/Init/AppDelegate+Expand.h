/*
 * 文件：App主入口文件扩展方法
 * 描述：App主入口文件扩展方法，用来创建需要在入口文件中进行执行初始化方法
 *      例如：三方SDK初始化，主界面选择等
 */


#import "AppDelegate.h"

@interface AppDelegate (Expand)

-(void)initWindow;  //初始化窗口

-(void)initTabBar;  //初始化底部菜单

-(void)initLaunchScreen:(void (^)())launchBlock; //初始化启动界面

-(void)setStatusStyle; //设置状态栏相关

-(void)initAppConfig;  //执行应用初始化工作

@end