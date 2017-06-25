#import <Foundation/Foundation.h>

@interface DynamicModel : NSObject

@property(nonatomic,assign) NSInteger  dynamicId;     //动态ID
@property(nonatomic,copy)   NSString * headerUrl;     //用户头像
@property(nonatomic,assign) NSInteger  userId;        //用户ID
@property(nonatomic,assign) NSInteger  userAge;       //用户年龄
@property(nonatomic,assign) NSInteger  dynamicType;   //动态类型
@property(nonatomic,copy)   NSArray  * images;        //图片类型的动态数组
@property(nonatomic,assign) NSInteger  videoType;     //视频类型 0-本地 1-三方
@property(nonatomic,copy)   NSString * videoUrl;      //视频地址
@property(nonatomic,copy)   NSString * videoImage;    //视频标题图
@property(nonatomic,copy)   NSString * username;      //用户帐号
@property(nonatomic,copy)   NSString * nickname;      //用户昵称
@property(nonatomic,copy)   NSString * sexIcon;       //性别图标名
@property(nonatomic,copy)   NSString * sex;           //性别
@property(nonatomic,copy)   NSString * location;      //所在位置
@property(nonatomic,assign) NSInteger  cid;           //乐器类型ID
@property(nonatomic,copy)   NSString * cname;         //乐器名称
@property(nonatomic,copy)   NSString * cIcon;         //乐器分类图标
@property(nonatomic,copy)   NSString * content;       //动态内容
@property(nonatomic,copy)   NSString * tag;           //标签
@property(nonatomic,assign) NSInteger  commentCount;  //评论数
@property(nonatomic,assign) NSInteger  zanCount;      //点赞数
@property(nonatomic,assign) BOOL isZan;               //是否点过赞
@property(nonatomic,assign) BOOL isGuanZhu;           //是否关注过

-(instancetype)   initWithDict:(NSDictionary *)dict;
+(instancetype)dynamicWithDict:(NSDictionary *)dict;

@end
