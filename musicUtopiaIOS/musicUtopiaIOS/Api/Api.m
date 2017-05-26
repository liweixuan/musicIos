#import "Api.h"

//服务器地址
#define SERVER_IP @"http://192.168.10.123:3200"

NSString * const API_DYNAMIC_SEARCH           = SERVER_IP @"/_dynamic/search";
NSString * const API_DYNAMIC_ADD              = SERVER_IP @"/_dynamic/add";
NSString * const API_DYNAMIC_COMMENT_SEARCH   = SERVER_IP @"/_dynamic/searchComment";
NSString * const API_DYNAMIC_REPLY            = SERVER_IP @"/_dynamic/replyDynamic";
NSString * const API_DYNAMIC_ZAN              = SERVER_IP @"/_dynamic/zan";

NSString * const API_PARTNER_SEARCH           = SERVER_IP @"/_partner/search";
NSString * const API_ORGANIZATION_SEARCH      = SERVER_IP @"/_organization/search";
NSString * const API_ORGANIZATION_INFO        = SERVER_IP @"/_organization/info";
NSString * const API_MATCH_SEARCH             = SERVER_IP @"/_match/search";
NSString * const API_OFFICIAL_CATEGORY        = SERVER_IP @"/_musicCategory/search";
NSString * const API_ORGANIZATION_ADD         = SERVER_IP @"/_organization/add";

NSString * const API_USER_CONCERN             = SERVER_IP @"/_user/addUserConcern";
NSString * const API_USER_LOGIN               = SERVER_IP @"/_user/login";
NSString * const API_COMMENT_LOCATION         = SERVER_IP @"/_common/location";
NSString * const API_COMMENT_ALL_LOCATION     = SERVER_IP @"/_common/allLocation";
NSString * const API_FRIENDS_SEARCH           = SERVER_IP @"/_friends/searchFriends";
NSString * const API_USER_UPDATE_LOCATION     = SERVER_IP @"/_user/updateUserLocation";
NSString * const API_LOOKAROUND_USER          = SERVER_IP @"/_user/lookAroundSearch";
NSString * const API_RADIO_USER               = SERVER_IP @"/_user/radioSearch";
NSString * const API_CONCERN_SEARCH           = SERVER_IP @"/_user/concernSearch";
NSString * const API_USER_ORGANIZATION_SEARCH = SERVER_IP @"/_user/organizationSearch";
NSString * const API_USER_DETAIL              = SERVER_IP @"/_user/info";

NSString * const API_SMS_REGISTER_CODE        = SERVER_IP @"/_sms/registerCode";
NSString * const API_USER_REGISTER            = SERVER_IP @"/_user/register";
NSString * const API_VERIFY_PHONE_CODE        = SERVER_IP @"/_user/verifyPhoneCode";
NSString * const API_RONGCLOUD_TOKEN          = SERVER_IP @"/_rongCloud/getToken";
NSString * const API_USER_BASIC_INFO          = SERVER_IP @"/_user/basicInfo";
NSString * const API_ACCURATE_USER            = SERVER_IP @"/_user/accurateSearch";

NSString * const API_APPLY_FRIENDS_SEARCH     = SERVER_IP @"/_friends/applySearch";
NSString * const API_AGREE_OR_REFUSE          = SERVER_IP @"/_friends/agreeOrRefuse";
NSString * const API_APPLY_FRIENDS            = SERVER_IP @"/_friends/apply";
