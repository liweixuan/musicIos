#import "DynamicModel.h"

@implementation DynamicModel
-(instancetype)   initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.dynamicId    = [dict[@"d_id"] integerValue];
        self.headerUrl    = dict[@"u_header_url"];
        self.userId       = [dict[@"d_uid"] integerValue];
        self.dynamicType  = [dict[@"d_type"] integerValue];
        self.userAge      = [dict[@"u_age"] integerValue];
        self.images       = dict[@"images"];
        self.videoType    = [dict[@"d_video_type"] integerValue];
        self.videoUrl     = [BusinessEnum getEmptyString:dict[@"d_video_url"]];
        self.username     = dict[@"u_username"];
        self.nickname     = dict[@"u_nickname"];
        self.videoImage   = dict[@"d_video_image"];
        self.sexIcon      = [BusinessEnum getSexIcon:[dict[@"u_sex"] integerValue]];
        self.sex          = [BusinessEnum getSex:[dict[@"u_sex"] integerValue]];
        self.cname        = dict[@"c_name"];
        self.cIcon        = [BusinessEnum getCategoryIcon:dict[@"c_name"]];
        self.location     = [BusinessEnum getEmptyString:dict[@"d_location"]];
        self.cid          = [dict[@"d_cid"] integerValue];
        self.content      = dict[@"d_content"];
        self.tag          = [BusinessEnum getEmptyString:dict[@"d_tags"]];
        self.commentCount = [dict[@"d_comment_count"] integerValue];
        self.zanCount     = [dict[@"d_zan_count"] integerValue];
        
    }
    return self;
}

+(instancetype)dynamicWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
