#import "FirendsModel.h"

@implementation FirendsModel

//创建数据模型
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.fid        = dict[@"fid"];
        self.headerUrl  = dict[@"headerUrl"];
        self.userName   = dict[@"userName"];
        self.nickName   = dict[@"nickName"];
        self.showCount  = dict[@"showCount"];
        self.zanCount   = dict[@"zanCount"];
        self.createDate = dict[@"createDate"];
    }
    return self;
}

+(instancetype)firendsWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+(NSDictionary *) createTable {

    //创建表语句
    NSString *createTableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( \
                                    id INTEGER PRIMARY KEY AUTOINCREMENT, \
                                    fid TEXT,   \
                                    headerUrl TEXT,   \
                                    userName INTEGER, \
                                    nickName TEXT, \
                                    showCount INTEGER, \
                                    zanCount INTEGER, \
                                    createDate DATE )",[self class]];
    
    NSDictionary * settingDict = @{
      @"createTableSql" : createTableStr
    };

    return settingDict;
}

@end
