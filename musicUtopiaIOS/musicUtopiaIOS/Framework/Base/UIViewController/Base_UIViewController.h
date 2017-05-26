@protocol ViewEventDelegate <NSObject>
-(void)dataReset;
@end


@interface Base_UIViewController : UIViewController<ViewEventDelegate>

//开启操作加载请求
-(void)startActionLoading:(NSString *)MSG;

//关闭操作加载请求
-(void)endActionLoading;

//开启加载请求动画
-(void)startLoading;

//结束加载请求动画
-(void)endLoading;

//创建错误显示视图
-(void)startError:(NSString *)errorMsg;

//创建数据为空时显示视图
-(void)startEmpty;

@property(nonatomic,strong)id<ViewEventDelegate> delegate;

@end
