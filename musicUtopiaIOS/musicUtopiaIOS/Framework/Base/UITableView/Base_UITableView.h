#import <UIKit/UIKit.h>

typedef void(^loadNewData)();

typedef void(^loadMoreData)();


@interface Base_UITableView : UITableView
@property(nonatomic,strong)loadNewData  loadNewData;        //下拉刷新回调
@property(nonatomic,strong)loadMoreData loadMoreData;       //上拉加载更多回调
@property(nonatomic,assign)BOOL isCreateHeaderRefresh;      //是否创建下拉刷新控件
@property(nonatomic,assign)BOOL isCreateFooterRefresh;      //是否创建上拉加载更多
@property(nonatomic,assign)CGFloat marginBottom;            //表视图距离底部高度

@property(nonatomic,strong)NSString * headerRefreshString;  //下拉刷新的提示文字
@property(nonatomic,strong)NSString * footerRefreshString;  //上拉加载的提示文字

-(void)headerEndRefreshing;
-(void)footerEndRefreshing;
-(void)footerEndRefreshingNoData;
-(void)resetNoMoreData;

-(void)beginHeaderRefresh;

@end
