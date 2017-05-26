/*
 * 文件：项目全部配置相关文件
 * 描述：用于对项目中的全局进行统一配置管理
 */

extern BOOL const       IS_IMG_NAV;                         //是否图片作为导航条背景
extern NSString * const IMG_NAV_NAME;                       //导航条图片的名称，IS_IMG_NAV为真时生效
extern BOOL const       IS_NAV_BACK_TITLE;                  //是否保留后退文字
extern NSInteger const  STATUS_COLOR;                       //状态栏颜色(0-黑色 1-白色)
extern BOOL const       IS_SHOW_NETWORK_ACTIVITY_INDICATOR; //是否在网络请求时开启状态栏加载器
extern NSString * const IMAGE_SERVER;                       //图片服务器地址
extern NSInteger const  PAGE_LIMIT;                         //每页显示数据量


extern NSInteger const  NETWORK_TIMEOUT;                    //网络请求超时时间
extern NSInteger const  DEFAULT_TAB_INDEX;                  //应用打开时默认显示第几个TAB项
extern NSInteger const  LAUNCH_WAIT_TIME;                   //启动画面等待时间
extern NSInteger const  TABLE_HEADER_REFRESH_STYLE;         //列表视图下拉刷新方式（0-普通 1-动画,如果为动画需要传递图片组的文件头名称）
extern NSString * const TABLE_HEADER_REFRESH_IMAGES;        //为动画模式时的头文件名称


extern BOOL const       IS_OPEN_LOCALSTORE;                 //是否开启离线存储功能,开启该功能可以进行本地表创建的配置
extern NSInteger const  LOCALSTORE_TYPE;                    //离线存储的方式（0-本地数据库存储）
extern NSString * const LOCALSTORE_MODEL_CREATE_TABLES;     //需要创建表的数据模型类,以'｜'隔开（当开启离线存储功能时会使用）
extern NSString * const LOCALSTORE_DB_NAME;                 //本地数据库名称
extern BOOL const       IS_UPDATE_TABLE_SCHEMA;             //表结构发生变化是否重新创建表结构（数据会清除）


extern NSString * const UPDATE_TABLES;                      //表结构发生变化时需要更新的指定表,以'｜'隔开,需要 IS_UPDATE_TABLE_SCHEMA=YES 配置才会生效
extern NSString * const IMAGE_DEFAULT;                      //正方形图片占位图
extern NSString * const RECTANGLE_IMAGE_DEFAULT;            //长方形图片占位图
extern NSString * const TOP_RECTANGLE_IMAGE_DEFAULT;        //竖方形图片占位图
extern NSString * const VIDEO_DEFAULT;                      //视频占位图
extern NSString * const MOBILE_VIDEO_DEFAULT;               //手机小视频占位图
extern NSString * const HEADER_DEFAULT;                     //头像占位图
extern NSString * const ICON_DEFAULT;                       //图标占位图
extern NSString * const AUDIO_DEFAULT;                      //音频占位图
