#import "Base_UIView.h"

@class DynamicFrame;
@protocol DynamicViewDelegate <NSObject>

//向外传递动态评论点击事件
-(void)dynamicCommentClick:(DynamicFrame *)dynamicFrame;

//向外传递赞点击事件
-(void)dynamicZanClick:(NSInteger)dynamicId NowView:(UILabel *)label NowZanCount:(NSInteger)zanCount ZanBlock:(void (^)())zanBlock;

//向外传递关注点击事件
-(void)dynamicConcernClick:(NSInteger)userId ConcernBlock:(void (^)())concernBlock;

//向外传递动态头像点击事件
-(void)publicUserHeaderClick:(NSInteger)userId UserName:(NSString *)username;

//向外传递网络请求错误
-(void)requestFaild:(NSInteger)menuIdx;

//删除该条动态信息
-(void)deleteDynamic:(NSInteger)dynamicId;

//播放视频
-(void)dynamicVideoPlayer:(NSString *)videoUrl;

@end

@interface DynamicView : Base_UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) id<DynamicViewDelegate> delegate;

@property(nonatomic,strong)NSDictionary * paramsDict;

@property(nonatomic,strong)NSDictionary * filterParamsDict;

@property(nonatomic,assign)BOOL isDeleteBtn; //是否出现删除按钮

-(void)reloadData;

//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@end
