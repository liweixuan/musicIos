#import "AppDelegate+Expand.h"
#import "MenuTabBarController.h"
#import "CustomNavigationController.h"
#import "LaunchScreenViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ConditionFilterViewController.h"

#import "UserDetailViewController.h"
#import "PartakeMatchViewController.h"
#import "MatchUserVideoViewController.h"
#import "InstrumentEvaluationViewController.h"


@implementation AppDelegate (Expand)

-(void)initWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

-(void)initTabBar {
    
    MenuTabBarController *menuTabController = [[MenuTabBarController alloc] init];
    menuTabController.selectedIndex = DEFAULT_TAB_INDEX;
    self.window.rootViewController = menuTabController;

//    InstrumentEvaluationViewController * cc = [[InstrumentEvaluationViewController alloc] init];
//    CustomNavigationController * nav = [[CustomNavigationController alloc] initWithRootViewController:cc];
//    self.window.rootViewController = nav;
    
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

//初始化地图
-(void)initMap {
    NSLog(@"初始化地图KEY");
    [AMapServices sharedServices].apiKey = AMapAppKey;
}

//初始化融云
-(void)initRongCloud {
    [[RCIMClient sharedRCIMClient] initWithAppKey:RongCloudAppKey];
}

//判断是否登录
-(BOOL)isLogin {
    NSLog(@"判断是否登录...");
    if(![UserData UserIsLogin]){
        return NO;
    }
    
    return YES;
    
    
}

//连接融云IM
-(void)connentRongCloud:(void (^)())connentEndBlock{
    
    NSLog(@"开始连接融云服务器...");
    
    //查看本地是否存储了融云TOKEN
    NSString * rongToken = [UserData getRongCloudToken];
    if(rongToken != nil){
        
        NSLog(@"有融云TOKEN，直接连接...");
        
        //直接连接融云
        [[RCIMClient sharedRCIMClient] connectWithToken:rongToken
                                                success:^(NSString *userId) {
                                                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                                    connentEndBlock();
                                                } error:^(RCConnectErrorCode status) {
                                                    NSLog(@"登陆的错误码为:%ld", (long)status);
                                                } tokenIncorrect:^{
                                                    NSLog(@"token错误");
                                                }];
 
    }else{
        
        NSLog(@"无融云TOKEN，向服务器请求后连接...");

        //获取个人信息
        NSDictionary * userInfo = [UserData getUserInfo];
        
        //获取TOKEN所需参数
        NSDictionary * params = @{
            @"userId"      : userInfo[@"u_username"],
            @"name"        : userInfo[@"u_nickname"],
            @"portraitUri" : userInfo[@"u_header_url"],
        };
 
        //获取融云连接TOKEN
        [NetWorkTools POST:API_RONGCLOUD_TOKEN params:params successBlock:^(NSArray *array) {
            
            NSLog(@"融云TOKEN获取成功");
            
            NSDictionary * dictData = (NSDictionary *)array;
            
            //融云TOKEN
            NSString * rToken = dictData[@"rongCloudToken"];
            
            //保存在本地
            [UserData saveRongCloudToken:rToken];
            
            //直接连接融云
            [[RCIMClient sharedRCIMClient] connectWithToken:rongToken
                                                    success:^(NSString *userId) {
                                                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                                        connentEndBlock();
                                                    } error:^(RCConnectErrorCode status) {
                                                        NSLog(@"登陆的错误码为:%ld", (long)status);
                                                    } tokenIncorrect:^{
                                                        NSLog(@"token错误");
                                                    }];
            
        } errorBlock:^(NSString *error) {
            NSLog(@"%@",error);
        }];
  
    }
 
}

-(void)updateNowLocation {
    
    NSLog(@"更新当前位置");
    //初始化操作对象
    AMapLocationManager * locationManager = [[AMapLocationManager alloc] init];
    
    //带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //定位超时时间，最低2s，此处设置为2s
    locationManager.locationTimeout = 10;
    
    //逆地理请求超时时间，最低2s，此处设置为2s
    locationManager.reGeocodeTimeout = 10;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
   
        CLLocationCoordinate2D lc = location.coordinate;
        
        //获取到经纬度坐标，更新进用户位置
        NSLog(@"^^^^^^%f",lc.latitude);
        NSLog(@"^^^^^^%f",lc.longitude);
        
        NSString * lcStr = [NSString stringWithFormat:@"%f,%f",lc.longitude,lc.latitude];
        NSDictionary * userInfo = [UserData getUserInfo];
        NSDictionary * updateLocationParams = @{
                                                    @"userid"    : userInfo[@"u_id"],
                                                    @"username"  : userInfo[@"u_username"],
                                                    @"nickname"  : userInfo[@"u_nickname"],
                                                    @"headerUrl" : userInfo[@"u_header_url"],
                                                    @"sex"       : userInfo[@"u_sex"],
                                                    @"userGoodInstrument" : userInfo[@"u_good_instrument"],
                                                    @"longitude" : @(lc.longitude),
                                                    @"latitude"  : @(lc.latitude)
        };
        [NetWorkTools POST:API_USER_UPDATE_LOCATION params:updateLocationParams successBlock:^(NSArray *array) {
            NSLog(@"用户位置更新成功");
            
            //更新本地保存的用户当前位置信息数据
            [UserData saveUserLocation:lcStr];
            
        } errorBlock:^(NSString *error) {
            NSLog(@"用户位置更新失败");
        }];
    }];
    
}

//是否进入引导页
-(BOOL)isNewVersion:(void (^)())versionBlock {

    
    //获取最新版本信息
    NSArray * params = @[@{@"key":@"type",@"value":@"0"}];
    NSString * url   = [G formatRestful:API_GET_VERSION Params:params];
    
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        NSDictionary * dictData = (NSDictionary *)array;
        

        /*** 对比版本号是否需要升级 ***/
        
        //获取应用当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        //判断版本号
        NSArray * curVerAry = [currentVersion componentsSeparatedByString:@"."];
        NSArray * newVerAry = [dictData[@"av_version"] componentsSeparatedByString:@"."];

        
        BOOL isUpdate = NO;
        
        //对比主版本号
        if([newVerAry[0] integerValue] > [curVerAry[0] integerValue]){
            
            isUpdate = YES;
            
        }else{
 
            //判断副版本号
            if([newVerAry[1] integerValue] > [curVerAry[1] integerValue]){
                
                isUpdate = YES;
                
                
            }else{
                
                //判断次版本号
                NSInteger nV = newVerAry.count == 3 ? [newVerAry[2] integerValue] : 0;
                NSInteger cV = curVerAry.count == 3 ? [curVerAry[2] integerValue] : 0;
                
                
                if(nV > cV){
                        
                    isUpdate = YES;
                        
                }else{
                    
                    //记录是否有更新
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"updateVersion"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"updateVersion"];
                        
                    versionBlock();
                    return;
                }
                
            }
        }
        
        if(isUpdate){
            
            //记录是否有更新
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"updateVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"updateVersion"];


            //需要强制更新
            if([dictData[@"av_is_force"] integerValue] == 1){
                
                //判断是否强制更新
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本，本版本更新较大，需要进行统一更新，给您带来不便，请见谅" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                     NSLog(@"强制更新操作");
            
            
                }];
                
                [alertController addAction:okAction];
                UIWindow *aW = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
                aW.rootViewController = [[UIViewController alloc]init];
                aW.windowLevel = UIWindowLevelAlert + 1;
                [aW makeKeyAndVisible];
                [aW.rootViewController presentViewController:alertController animated:YES completion:nil];
             
            }else{
                
                versionBlock();
                
            }
        }
        
    } errorBlock:^(NSString *error) {
        versionBlock();
    }];
    
    return NO;
}

//弹出更新提示（如果有新版本）
-(void)updateVersionHint {
    
    NSString * isNewVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"updateVersion"];
    
    if([isNewVersion isEqualToString:@"yes"]){
        
        
        //判断是否强制更新
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本，前往去更新" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"强制更新操作");
            
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        UIWindow *aW = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        aW.rootViewController = [[UIViewController alloc]init];
        aW.windowLevel = UIWindowLevelAlert + 1;
        [aW makeKeyAndVisible];
        [aW.rootViewController presentViewController:alertController animated:YES completion:nil];
 
        
    }
    
}

//是否进入引导页
-(void)isGuide:(void (^)(BOOL isGoGuide))guideBlock {
    
    
    NSString *bundleVersionKey = (NSString *)kCFBundleVersionKey;
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[bundleVersionKey];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:bundleVersionKey];
    
    if ([bundleVersion isEqualToString:saveVersion]) {
        
        NSLog(@"直接进入控制器");
        guideBlock(NO);
        
    }else{
        
        NSLog(@"第一次使用APP");
        [[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:bundleVersionKey];
        guideBlock(YES);
    }
    
}
@end
