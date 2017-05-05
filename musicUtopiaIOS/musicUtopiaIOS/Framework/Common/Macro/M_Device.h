#ifndef M_Device_h
#define M_Device_h

/*
 * 判断设备型号
 */
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) 
#define IS_IPAD          [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4      (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5      (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/*
 * 判断系统版本
 */
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5         floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6         floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7         floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8         floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9         floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0

/*
 * 屏幕尺寸相关
 */
#define D_HEIGHT               [[UIScreen mainScreen] bounds].size.height            //屏幕高度（物理屏）
#define D_WIDTH                [[UIScreen mainScreen] bounds].size.width             //屏幕宽度
#define D_HEIGHT_NO_STATUS     [[UIScreen mainScreen] bounds].size.height - 20       //除去状态栏之外的屏幕高度
#define D_HEIGHT_NO_NAV        [[UIScreen mainScreen] bounds].size.height - 64       //除去状态栏+导航条的屏幕高度
#define D_HEIGHT_NO_NAV_STATUS [[UIScreen mainScreen] bounds].size.height - 64 - 49  //除去状态栏+导航条+底部Tab的屏幕高度


#endif
