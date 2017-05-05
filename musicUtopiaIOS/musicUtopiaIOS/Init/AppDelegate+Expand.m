#import "AppDelegate+Expand.h"
#import "MenuTabBarController.h"
#import "CustomNavigationController.h"
#import "LaunchScreenViewController.h"

#import "CreateInteractionViewController.h"
#import "OrganizationDetailViewController.h"
#import "MatchDetailViewController.h"
#import "OfficialMusicScoreViewController.h"
#import "OrganizationUserViewController.h"
#import "CreateChatroomViewController.h"
#import "LoginViewController.h"
#import "OfficialNoteDetailViewController.h"
#import "RegisterViewController.h"
#import "PrivateChatViewController.h"


@implementation AppDelegate (Expand)

-(void)initWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

-(void)initTabBar {
    
//    MenuTabBarController *menuTabController = [[MenuTabBarController alloc] init];
//    menuTabController.selectedIndex = DEFAULT_TAB_INDEX;
//    self.window.rootViewController = menuTabController;
    
    PrivateChatViewController * cc = [[PrivateChatViewController alloc] init];
    CustomNavigationController * nav = [[CustomNavigationController alloc] initWithRootViewController:cc];
    self.window.rootViewController = nav;
    
}

-(void)initLaunchScreen:(void (^)())launchBlock {
    
    //获取自定义启动页图片
    LaunchScreenViewController * launchVC = [[LaunchScreenViewController alloc] init];
    self.window.rootViewController = launchVC;
    
    //延迟加载
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LAUNCH_WAIT_TIME * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        launchBlock();
    });
}

-(void)setStatusStyle {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:STATUS_COLOR];
}


-(void)initAppConfig {
    
    //读取是否开启本地存储，如有开启则创建相应数据表
    if(IS_OPEN_LOCALSTORE){
        
        NSLog(@"%@",[Db getDatabasePath]);
        
        //打开数据表
        FMDatabase * db = [FMDatabase databaseWithPath:[Db getDatabasePath]];
        if(![db open]){
            LOG(@"本地数据库打开失败...");
            return;
        }
        
        //获取配置文件中需要创建本地数据库的数据模型
        NSString * modelStr = LOCALSTORE_MODEL_CREATE_TABLES;
        NSArray  * modelArr = [modelStr componentsSeparatedByString:@"|"];
        
        //保存创建成功的表数量
        NSInteger createSuccessTableCount = 0;
        
        //应当需要创建的表
        NSInteger endSuccessTabaleCount   = modelArr.count;
 
        //循环每一个模型取出模型中的建表语句
        for(int i = 0;i<modelArr.count;i++){
            
            //获取相关类
            Class className = NSClassFromString(modelArr[i]);

            if(className != nil){

                //取出建表数据
                NSDictionary *dict = [className createTable];

                //获取建表语句
                NSString * createSql = dict[@"createTableSql"];
                
                //判断是否需要更新表结构
                if(IS_UPDATE_TABLE_SCHEMA){

                    //判断是否有指定需要更新的表
                    if([UPDATE_TABLES rangeOfString:modelArr[i]].location != NSNotFound){
    
                        //删除原有表
                        [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",modelArr[i]]];
                        
                    }
                    
                }
                
                //创建该表
                BOOL result = [db executeUpdate:createSql];
                    
                if(result){
                    createSuccessTableCount++;
                }
                
            }
        }

        //判断是否全部创建完成
        if(createSuccessTableCount == endSuccessTabaleCount){
            LOG(@"数据表全部创建完成,共: %ld 张",(long)endSuccessTabaleCount);
        }else{
            LOG(@"数据表部分创建完成,应创建 %ld 张,实际创建: %ld 张",(long)endSuccessTabaleCount,(long)createSuccessTableCount);
        }
    }
}
@end
