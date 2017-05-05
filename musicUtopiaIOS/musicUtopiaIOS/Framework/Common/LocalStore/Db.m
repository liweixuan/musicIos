#import "Db.h"

@implementation Db


+(NSString *)getDatabasePath {
    
    //获取数据库创建路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:LOCALSTORE_DB_NAME];
    return filename;
    
}

@end
