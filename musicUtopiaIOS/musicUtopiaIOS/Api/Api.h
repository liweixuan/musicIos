/***** 互动相关 ******/

extern NSString * const API_DYNAMIC_SEARCH;          //获取动态数据
extern NSString * const API_DYNAMIC_ADD;             //新增动态数据
extern NSString * const API_DYNAMIC_COMMENT_SEARCH;  //获取动态评论
extern NSString * const API_DYNAMIC_REPLY;           //评论动态信息
extern NSString * const API_DYNAMIC_COMMENT_REPLY;   //回复动态评论信息
extern NSString * const API_DYNAMIC_ZAN;             //为动态点赞
extern NSString * const API_DYNAMIC_COMMENT_ZAN;     //为动态评论点赞
extern NSString * const API_DYNAMIC_DELETE;          //删除动态信息

extern NSString * const API_PARTNER_SEARCH;          //获取找伙伴数据
extern NSString * const API_ORGANIZATION_SEARCH;     //获取团体数据
extern NSString * const API_ORGANIZATION_INFO;       //获取团体详细
extern NSString * const API_MATCH_SEARCH;            //获取比赛详细
extern NSString * const API_PARTNER_ADD;             //新增找伙伴信息

/***** 团体相关 ******/
extern NSString * const API_ORGANIZATION_ADD;             //创建团体
extern NSString * const API_ORGANIZATION_MEMBER;          //获取团体成员
extern NSString * const API_ORGANIZATION_APPLY_SEARCH;    //获取团体请求信息
extern NSString * const API_PARTNER_ADD;                  //新增找伙伴信息
extern NSString * const API_ORGANIZATION_AGREE_OR_REFUSE; //同意或拒绝团体请求
extern NSString * const API_ORGANIZATION_PHOTOS;          //获取团体某相册下所有照片
extern NSString * const API_ORGANIZATION_UPDATE;          //更新团体信息

/***** 通用相关 ******/
extern NSString * const API_OFFICIAL_CATEGORY;       //获取官方乐器分类课程
extern NSString * const API_COMMENT_LOCATION;        //获取省市区信息
extern NSString * const API_COMMENT_ALL_LOCATION;    //获取全部省市区信息
extern NSString * const API_GET_VERSION;             //获取最新版本号

/***** 用户相关 ******/
extern NSString * const API_USER_CONCERN;              //关注某用户
extern NSString * const API_USER_LOGIN;                //用户登录
extern NSString * const API_USER_REGISTER;             //用户注册
extern NSString * const API_USER_BASIC_INFO;           //获取用户基本信息
extern NSString * const API_USER_DETAIL_INFO;          //获取用户详细信息
extern NSString * const API_USER_INFO_AND_IS_FRIEND;   //获取用户基本信息，包含是否为好友的判断
extern NSString * const API_ACCURATE_USER;             //精确筛选用户
extern NSString * const API_USER_UPDATE_LOCATION;      //更新用户位置信息
extern NSString * const API_LOOKAROUND_USER;           //获取附近的用户
extern NSString * const API_RADIO_USER;                //获取上传有交友音频的用户
extern NSString * const API_CONCERN_SEARCH;            //获取所有关注的用户
extern NSString * const API_USER_ORGANIZATION_SEARCH;  //获取用户的所有所在群组
extern NSString * const API_USER_DETAIL;               //获取用户基本信息
extern NSString * const API_USER_PLAY_VIDEO_SEARCH;    //获取用户个人演奏集
extern NSString * const API_USER_PLAY_VIDEO_DELETE;    //删除用户个人演奏视频
extern NSString * const API_USER_PLAY_VIDEO_ADD;       //新增用户个人演奏视频
extern NSString * const API_USER_PARTAKE_MATCH;        //获取用户参与的比赛信息
extern NSString * const API_USER_QUIT_MATCH;           //用户退出比赛
extern NSString * const API_USER_ALL_INSTRUMENT_LEVEL; //获取当前用户的所有乐器等级
extern NSString * const API_USER_UPGRADE_MUSIC_SCORE;  //获取升级演奏的曲谱
extern NSString * const API_USER_UPGRADE_APPLY;        //新增升级评测申请
extern NSString * const API_USER_UPGRADE_VIDEO;        //获取用户升级时所演奏的视频
extern NSString * const API_USER_UPDATE_INFO;          //修改用户资料
extern NSString * const API_USER_CREATE_USER_ORGANIZATION; //获取用户为团长的团体

/***** 注册相关 ******/
extern NSString * const API_SMS_REGISTER_CODE;       //发送注册短信验证码
extern NSString * const API_VERIFY_PHONE_CODE;       //验证手机短信验证码是否正确

/***** 融云相关 ******/
extern NSString * const API_RONGCLOUD_TOKEN;         //获取融云TOKEN

/***** 好友相关 ******/
extern NSString * const API_FRIENDS_SEARCH;          //获取好友列表
extern NSString * const API_APPLY_FRIENDS_SEARCH;    //获取好友请求列表
extern NSString * const API_APPLY_FRIENDS;           //申请成为好友
extern NSString * const API_AGREE_OR_REFUSE;         //好友请求同意或拒绝
extern NSString * const API_DELETE_FRIEND;           //删除好友

/***** 比赛相关 ******/
extern NSString * const API_MATCH_PARTAKE;           //参与比赛
extern NSString * const API_MATCH_DETAIL;            //获取比赛详细
extern NSString * const API_MATCH_USER_VIDEO_COMMENT;//获取某用户的比赛视频评论
extern NSString * const API_MATCH_ADD_VIDEO_COMMENT; //添加某用户的比赛视频评论
extern NSString * const API_MATCH_VOTE;              //为某用户比赛视频投票

/***** 曲谱相关 ******/
extern NSString * const API_MUSIC_SCORE_CATEGORY;      //获取曲谱分类
extern NSString * const API_MUSIC_SCORE_SEARCH;        //获取曲谱信息
extern NSString * const API_MUSIC_SCORE_DETAIL;        //获取乐谱详细
extern NSString * const API_COLLECT_MUSIC_SCORE;       //收藏乐谱
extern NSString * const API_COLLECT_MUSIC_SCORE_SEARCH;//获取用户收藏的乐谱
extern NSString * const API_ADD_MUSIC_SCORE_HOT;       //更新曲谱热度
extern NSString * const API_DELETE_COLLECT_MUSIC_SCORE;//删除个人收藏的曲谱

/***** 文章相关 ******/
extern NSString * const API_ARTICLE_SEARCH;            //获取文章列表
extern NSString * const API_ARTICLE_ZAN;               //为文章点赞
extern NSString * const API_ARTICLE_COMMENT_ZAN;       //为文章评论点赞
extern NSString * const API_ARTICLE_REPLY;             //文章回复
extern NSString * const API_ARTICLE_REPLY_COMMENT;     //文章评论回复
extern NSString * const API_ARTICLE_SEARCH_COMMENT;    //获取文章评论信息

/***** 视频相关 ******/
extern NSString * const API_VIDEO_SEARCH;              //获取音乐视频
extern NSString * const API_VIDEO_COMMENT_SEARCH;      //获取视频评论
extern NSString * const API_VIDEO_REPLY;               //视频回复
extern NSString * const API_VIDEO_REPLY_COMMENT;       //视频评论回复
extern NSString * const API_VIDEO_COMMENT_ZAN;         //为视频评论点赞
