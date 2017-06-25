#import "Api.h"

//服务器地址
#define SERVER_IP @"http://192.168.0.107:3200"

NSString * const API_DYNAMIC_SEARCH               = SERVER_IP @"/_dynamic/search";
NSString * const API_DYNAMIC_ADD                  = SERVER_IP @"/_dynamic/add";
NSString * const API_DYNAMIC_COMMENT_SEARCH       = SERVER_IP @"/_dynamic/searchComment";
NSString * const API_DYNAMIC_REPLY                = SERVER_IP @"/_dynamic/replyDynamic";
NSString * const API_DYNAMIC_COMMENT_REPLY        = SERVER_IP @"/_dynamic/replyDynamicComment";
NSString * const API_DYNAMIC_ZAN                  = SERVER_IP @"/_dynamic/zan";
NSString * const API_DYNAMIC_COMMENT_ZAN          = SERVER_IP @"/_dynamic/commentZan";
NSString * const API_DYNAMIC_DELETE               = SERVER_IP @"/_dynamic/delete";
NSString * const API_PARTNER_SEARCH               = SERVER_IP @"/_partner/search";
NSString * const API_ORGANIZATION_SEARCH          = SERVER_IP @"/_organization/search";
NSString * const API_ORGANIZATION_INFO            = SERVER_IP @"/_organization/info";
NSString * const API_MATCH_SEARCH                 = SERVER_IP @"/_match/search";
NSString * const API_OFFICIAL_CATEGORY            = SERVER_IP @"/_musicCategory/search";
NSString * const API_ORGANIZATION_ADD             = SERVER_IP @"/_organization/add";
NSString * const API_PARTNER_ADD                  = SERVER_IP @"/_partner/add";
NSString * const API_ORGANIZATION_MEMBER          = SERVER_IP @"/_organization/members";
NSString * const API_ORGANIZATION_APPLY_SEARCH    = SERVER_IP @"/_organization/applySearch";
NSString * const API_ORGANIZATION_AGREE_OR_REFUSE = SERVER_IP @"/_organization/agreeOrRefuse";
NSString * const API_ORGANIZATION_PHOTOS          = SERVER_IP @"/_organization/photos";
NSString * const API_ORGANIZATION_UPDATE          = SERVER_IP @"/_organization/updateInfo";
NSString * const API_USER_CONCERN                 = SERVER_IP @"/_user/addUserConcern";
NSString * const API_USER_LOGIN                   = SERVER_IP @"/_user/login";
NSString * const API_COMMENT_LOCATION             = SERVER_IP @"/_common/location";
NSString * const API_COMMENT_ALL_LOCATION         = SERVER_IP @"/_common/allLocation";
NSString * const API_GET_VERSION                  = SERVER_IP @"/_common/getVersion";
NSString * const API_FRIENDS_SEARCH               = SERVER_IP @"/_friends/searchFriends";
NSString * const API_USER_UPDATE_LOCATION         = SERVER_IP @"/_user/updateUserLocation";
NSString * const API_LOOKAROUND_USER              = SERVER_IP @"/_user/lookAroundSearch";
NSString * const API_RADIO_USER                   = SERVER_IP @"/_user/radioSearch";
NSString * const API_CONCERN_SEARCH               = SERVER_IP @"/_user/concernSearch";
NSString * const API_USER_ORGANIZATION_SEARCH     = SERVER_IP @"/_user/organizationSearch";
NSString * const API_USER_DETAIL                  = SERVER_IP @"/_user/info";
NSString * const API_USER_PLAY_VIDEO_SEARCH       = SERVER_IP @"/_user/searchPlayVideo";
NSString * const API_USER_PLAY_VIDEO_DELETE       = SERVER_IP @"/_user/deletePlayVideo";
NSString * const API_USER_PLAY_VIDEO_ADD          = SERVER_IP @"/_user/addPlayVideo";
NSString * const API_USER_PARTAKE_MATCH           = SERVER_IP @"/_user/getPartakeMatch";
NSString * const API_USER_QUIT_MATCH              = SERVER_IP @"/_user/quitMatch";
NSString * const API_SMS_REGISTER_CODE            = SERVER_IP @"/_sms/registerCode";
NSString * const API_USER_REGISTER                = SERVER_IP @"/_user/register";
NSString * const API_VERIFY_PHONE_CODE            = SERVER_IP @"/_user/verifyPhoneCode";
NSString * const API_RONGCLOUD_TOKEN              = SERVER_IP @"/_rongCloud/getToken";
NSString * const API_USER_BASIC_INFO              = SERVER_IP @"/_user/basicInfo";
NSString * const API_ACCURATE_USER                = SERVER_IP @"/_user/accurateSearch";
NSString * const API_USER_DETAIL_INFO             = SERVER_IP @"/_user/info";
NSString * const API_USER_INFO_AND_IS_FRIEND      = SERVER_IP @"/_user/infoAndIsFriend";
NSString * const API_USER_ALL_INSTRUMENT_LEVEL    = SERVER_IP @"/_user/allInstrumentLevel";
NSString * const API_USER_UPGRADE_MUSIC_SCORE     = SERVER_IP @"/_user/upgradeMusicScore";
NSString * const API_USER_UPGRADE_APPLY           = SERVER_IP @"/_user/upgradeApply";
NSString * const API_USER_UPGRADE_VIDEO           = SERVER_IP @"/_user/upgradeVideo";
NSString * const API_USER_UPDATE_INFO             = SERVER_IP @"/_user/updateInfo";
NSString * const API_USER_CREATE_USER_ORGANIZATION= SERVER_IP @"/_user/createUserOrganization";
NSString * const API_APPLY_FRIENDS_SEARCH         = SERVER_IP @"/_friends/applySearch";
NSString * const API_AGREE_OR_REFUSE              = SERVER_IP @"/_friends/agreeOrRefuse";
NSString * const API_DELETE_FRIEND                = SERVER_IP @"/_friends/delete";
NSString * const API_APPLY_FRIENDS                = SERVER_IP @"/_friends/apply";
NSString * const API_MATCH_PARTAKE                = SERVER_IP @"/_match/partake";
NSString * const API_MATCH_DETAIL                 = SERVER_IP @"/_match/detail";
NSString * const API_MATCH_USER_VIDEO_COMMENT     = SERVER_IP @"/_match/userVideoComment";
NSString * const API_MATCH_ADD_VIDEO_COMMENT      = SERVER_IP @"/_match/addUserVideoComment";
NSString * const API_MATCH_VOTE                   = SERVER_IP @"/_match/matchVote";
NSString * const API_MUSIC_SCORE_CATEGORY         = SERVER_IP @"/_musicScore/getCategory";
NSString * const API_MUSIC_SCORE_SEARCH           = SERVER_IP @"/_musicScore/getMusicScore";
NSString * const API_MUSIC_SCORE_DETAIL           = SERVER_IP @"/_musicScore/getMusicScoreDetail";
NSString * const API_COLLECT_MUSIC_SCORE          = SERVER_IP @"/_musicScore/collectMusicScore";
NSString * const API_COLLECT_MUSIC_SCORE_SEARCH   = SERVER_IP @"/_musicScore/collectMusicScoreSearch";
NSString * const API_ADD_MUSIC_SCORE_HOT          = SERVER_IP @"/_musicScore/addMusicScoreHot";
NSString * const API_DELETE_COLLECT_MUSIC_SCORE   = SERVER_IP @"/_musicScore/deleteCollectMusicScore";
NSString * const API_ARTICLE_SEARCH               = SERVER_IP @"/_article/search";
NSString * const API_ARTICLE_ZAN                  = SERVER_IP @"/_article/zan";
NSString * const API_ARTICLE_COMMENT_ZAN          = SERVER_IP @"/_article/commentZan";
NSString * const API_ARTICLE_REPLY                = SERVER_IP @"/_article/replyArticle";
NSString * const API_ARTICLE_REPLY_COMMENT        = SERVER_IP @"/_article/replyArticleComment";
NSString * const API_ARTICLE_SEARCH_COMMENT       = SERVER_IP @"/_article/searchComment";
NSString * const API_VIDEO_SEARCH                 = SERVER_IP @"/_video/search";
NSString * const API_VIDEO_COMMENT_SEARCH         = SERVER_IP @"/_video/searchComment";
NSString * const API_VIDEO_REPLY                  = SERVER_IP @"/_video/replyVideo";
NSString * const API_VIDEO_REPLY_COMMENT          = SERVER_IP @"/_video/replyVideoComment";
NSString * const API_VIDEO_COMMENT_ZAN            = SERVER_IP @"/_video/commentZan";
