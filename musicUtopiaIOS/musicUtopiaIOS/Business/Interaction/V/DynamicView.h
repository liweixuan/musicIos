#import "Base_UIView.h"

@class DynamicFrame;
@protocol DynamicViewDelegate <NSObject>

//向外传递动态评论点击事件
-(void)dynamicCommentClick:(DynamicFrame *)dynamicFrame;

//向外传递赞点击事件
-(void)dynamicZanClick:(NSInteger)dynamicId NowView:(UILabel *)label NowZanCount:(NSInteger)zanCount;

//向外传递关注点击事件
-(void)dynamicConcernClick:(NSInteger)userId;

//向外传递动态头像点击事件
-(void)publicUserHeaderClick:(NSInteger)userId UserName:(NSString *)username;

//向外传递网络请求错误
-(void)requestFaild:(NSInteger)menuIdx;

@end

@interface DynamicView : Base_UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) id<DynamicViewDelegate> delegate;

//获取动态数据
-(void)getData:(NSDictionary *)params Type:(NSString *)type;

@end
