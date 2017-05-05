#import <Foundation/Foundation.h>

@interface FirendsModel : NSObject
@property(nonatomic,strong)NSString * fid;
@property(nonatomic,strong)NSString * headerUrl;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * nickName;
@property(nonatomic,strong)NSString * showCount;
@property(nonatomic,strong)NSString * zanCount;
@property(nonatomic,strong)NSString * createDate;

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)firendsWithDict:(NSDictionary *)dict;
+(NSDictionary *) createTable;
@end
