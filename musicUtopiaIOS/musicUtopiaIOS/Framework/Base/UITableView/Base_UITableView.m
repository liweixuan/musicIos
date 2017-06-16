#import "Base_UITableView.h"

@interface Base_UITableView()
{
    MJRefreshNormalHeader * _normalHeader;
    MJRefreshBackNormalFooter * _normalFooter;
}
@end

@implementation Base_UITableView

-(id)init {
    
    self = [super init];
    if(self){

        //去除多余线条
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self setTableFooterView:view];
        
        

 
    }
    return self;
    
}

-(void)loadNewDataFun {
    
    if (_loadNewData) {
        _loadNewData();
    }
    
}

-(void)loadMoreDataFun {
    
    if (_loadMoreData) {
        _loadMoreData();
    }

}

-(void)headerEndRefreshing {

    [self.mj_header endRefreshing];
    
}

-(void)beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}

-(void)setMarginBottom:(CGFloat)marginBottom {
    
    //设置底部视图高度
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,marginBottom)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footView;
}


-(void)footerEndRefreshing {
    
    [self.mj_footer endRefreshing];
    
}

-(void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

-(void)footerEndRefreshingNoData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

-(void)setIsCreateFooterRefresh:(BOOL)isCreateFooterRefresh {

    if(isCreateFooterRefresh){
        //配置上拉加载更多
        _normalFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataFun)];
        self.mj_footer = _normalFooter;
    }

}

-(void)setHeaderRefreshString:(NSString *)headerRefreshString {
     [_normalHeader setTitle:headerRefreshString forState:MJRefreshStateIdle];
}

-(void)setFooterRefreshString:(NSString *)footerRefreshString {
    [_normalFooter setTitle:footerRefreshString forState:MJRefreshStateIdle];
}

-(void)setIsCreateHeaderRefresh:(BOOL)isCreateHeaderRefresh {

    if(isCreateHeaderRefresh) {
        
         //判断下拉刷新的类型（0-普通 1-动画）
         if(TABLE_HEADER_REFRESH_STYLE) {
        
             MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataFun)];
        
             NSMutableArray *gifArr = [NSMutableArray array];
             for(int i = 0;i<4;i++){
                 UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",TABLE_HEADER_REFRESH_IMAGES,(i+1)]];
                 img = [img reSizeImage:img toSize:CGSizeMake(60,50)];
                 [gifArr addObject:img];
             }
        
             [header setImages:gifArr forState:MJRefreshStateIdle];
             [header setImages:gifArr forState:MJRefreshStatePulling];
             [header setImages:gifArr forState:MJRefreshStateRefreshing];
             
             header.lastUpdatedTimeLabel.hidden = YES;
        
             self.mj_header = header;
        
        
        }else{
        
            _normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataFun)];
            _normalHeader.lastUpdatedTimeLabel.hidden = YES;

            self.mj_header = _normalHeader;
                    
        }
        
    }

    
}
@end
