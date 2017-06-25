/*
 * 文件：App主入口文件扩展方法
 * 描述：App主入口文件扩展方法，用来创建需要在入口文件中进行执行初始化方法
 *      例如：三方SDK初始化，主界面选择等
 */


#import "AppDelegate.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface AppDelegate (Expand)

//@property(nonatomic,strong)AMapLocationManager * appLocationManager;

-(void)initWindow;        //初始化窗口

-(void)initTabBar;        //初始化底部菜单

-(void)initLaunchScreen:(void (^)())launchBlock; //初始化启动界面

-(void)setStatusStyle;    //设置状态栏相关

-(void)initAppConfig;     //执行应用初始化工作

-(void)initMap;           //初始化地图

-(void)initRongCloud;     //初始化融云

-(BOOL)isLogin;           //是否登录

-(void)updateNowLocation; //更新当前位置

-(void)connentRongCloud:(void (^)())connentEndBlock; //连接融云IM

-(BOOL)isNewVersion:(void (^)())versionBlock;   //是否有新版本，以及是否强制更新的判断

-(void)updateVersionHint;  //弹出更新提示（如果有新版本）

-(void)isGuide:(void (^)(BOOL isGoGuide))guideBlock;  //是否进入引导页

@end
