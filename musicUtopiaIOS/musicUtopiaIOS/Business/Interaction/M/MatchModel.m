#import "MatchModel.h"

@implementation MatchModel
-(instancetype)   initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.matchId                = [dict[@"m_id"] integerValue];
        self.matchName              = dict[@"m_name"];
        self.cid                    = [dict[@"m_cid"] integerValue];
        self.cName                  = dict[@"c_name"];
        self.matchInvolvementCount  = [dict[@"m_involvement_count"] integerValue];
        self.matchStartTimeUnix     = [dict[@"m_start_time"] integerValue];
        self.matchStartTime         = [G formatData:self.matchStartTimeUnix Format:@"YYYY-MM-dd"];
        self.matchEndTimeUnix       = [dict[@"m_end_time"] integerValue];
        self.matchEndTime           = [G formatData:self.matchEndTimeUnix Format:@"YYYY-MM-dd"];
        self.matchType              = [dict[@"m_type"] integerValue];
        self.matchTypeStr           = [BusinessEnum getMatchTypeString:self.matchType];
        self.matchCreateTime        = [dict[@"m_create_time"] integerValue];
        self.cIcon                  = [BusinessEnum getCategoryIcon:dict[@"c_name"]];
        self.nowStatus              = [dict[@"m_status"] integerValue];
        
    }
    return self;
}

+(instancetype)matchWithDict  :(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
