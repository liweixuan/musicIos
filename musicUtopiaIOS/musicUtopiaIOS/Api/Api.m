#import "Api.h"

//服务器地址
#define SERVER_IP @"http://192.168.10.123:3200"

NSString * const API_DYNAMIC_SEARCH      = SERVER_IP @"/_dynamic/search";
NSString * const API_PARTNER_SEARCH      = SERVER_IP @"/_partner/search";
NSString * const API_ORGANIZATION_SEARCH = SERVER_IP @"/_organization/search";
NSString * const API_ORGANIZATION_INFO   = SERVER_IP @"/_organization/info";
NSString * const API_MATCH_SEARCH        = SERVER_IP @"/_match/search";
NSString * const API_OFFICIAL_CATEGORY   = SERVER_IP @"/_musicCategory/search";
