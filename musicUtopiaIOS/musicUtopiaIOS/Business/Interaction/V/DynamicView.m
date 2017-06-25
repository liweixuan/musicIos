#import "DynamicView.h"
#import "DynamicCell.h"
#import "LoadingView.h"
#import "DynamicModel.h"
#import "DynamicFrame.h"
#import "Base_UIViewController.h"

@interface DynamicView()<DynamicCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    NSInteger          _skip;
    
    NSDictionary     * _filterParams;
}
@end

@implementation DynamicView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        
        
    }
    return self;
}

//初始化变量
-(void)initVar {
    
    _skip         = 0;
    _tableData    = [NSMutableArray array];
    _filterParams = [NSDictionary dictionary];
    
}

//数据获取
-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求动态列表数据...");
    
    //创建加载中遮罩
    if([type isEqualToString:@"init"]){
        _skip = 0;
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
    }

    NSMutableArray  * getParams = [NSMutableArray array];
    [getParams addObject:@{@"key":@"skip",@"value":@(_skip)}];
    [getParams addObject:@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    
    if(self.paramsDict != nil){
        [getParams addObject:self.paramsDict];
    }

    
    if([type isEqualToString:@"search"]){
        
        if(params!=nil){
            _filterParams = [params copy];
        }
        
        [[self viewController] startActionLoading:@"正在筛选..."];
 
    }
    
    if(_filterParams != nil){
        for(int i =0;i<_filterParams.allKeys.count;i++){
            NSDictionary * tempDict = @{@"key":_filterParams.allKeys[i],@"value":_filterParams.allValues[i]};
            [getParams addObject:tempDict];
            
        }
    }
    

    NSString * url = [G formatRestful:API_DYNAMIC_SEARCH Params:getParams];


    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        

        NSMutableArray *tempArr = [NSMutableArray array];
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            REMOVE_LOADVIEW
        }

        
        if([type isEqualToString:@"search"]){
            [[self viewController] endActionLoading];
        }
        

        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableview headerEndRefreshing];
            _tableview.mj_footer.hidden = NO;
            [_tableview resetNoMoreData];
        }
        

        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多动态信息");
            return;
        }

        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            //初始化数据源
            DynamicModel * model = [DynamicModel dynamicWithDict:dict];
            DynamicFrame * frame = [[DynamicFrame alloc] initWithDynamic:model];
            
            [tempArr addObject:frame];
        }

        
        if([type isEqualToString:@"more"]){
            [_tableData addObjectsFromArray:tempArr];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _tableData = tempArr;
            
        }

        //更新表视图
        [_tableview reloadData];
        
        
    } errorBlock:^(NSString *error) {

        //向控制器发送错误
        [self.delegate requestFaild:0];
        
    }];
    
    
    
}

//创建表视图
-(void)createTableView {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5,0,0,0));
    }];
    
    //列表视图事件部分
    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    _tableview.loadNewData = ^(){
        NSLog(@"loadNewData...");
        [weakSelf loadNewData];
        
    };
    
    //上拉加载更多
    _tableview.loadMoreData = ^(){
        NSLog(@"loadMoreData...");
        [weakSelf loadMoreData];
        
    };
    
    _tableview.marginBottom = 10;
    
    
}

-(void)loadNewData {
    
    _skip = 0;
    _filterParams  = nil;
    [self getData:nil Type:@"reload"];
    
    
}

-(void)loadMoreData {
    
    _skip += PAGE_LIMIT;
    [self getData:nil Type:@"more"];

}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicCell  * cell      = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    DynamicFrame * frameData = _tableData[indexPath.row];
    
    //设置位置
    cell.dynamicFrame = frameData;
    
    cell.isDeleteBtn  = self.isDeleteBtn;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置代理
    cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicFrame * frameData = _tableData[indexPath.row];
    CGFloat cellHeight       = frameData.cellHeight;
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取当前动态ID
    DynamicFrame * dynamicFrame = _tableData[indexPath.row];
    
    //向外传递
    [self.delegate dynamicCommentClick:dynamicFrame];
    
}


#pragma mark - 代理
//动态评论点击
-(void)commentClick:(DynamicCell *)cell {
    
    //获取当前动态ID
    NSIndexPath * indxPath = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];

    //向外传递
    [self.delegate dynamicCommentClick:dynamicFrame];
    
}

//动态用户头像点击
-(void)userHeaderClick:(DynamicCell *)cell {
    
    //获取当前动态ID
    NSIndexPath * indxPath = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    NSInteger userId = dynamicFrame.dynamicModel.userId;
    NSString * username = dynamicFrame.dynamicModel.username;
    
    //向外传递
    [self.delegate publicUserHeaderClick:(NSInteger)userId UserName:username];

    
}

//赞点击
-(void)zanClick:(DynamicCell *)cell NowView:(UILabel *)label {
    
    //获取当前动态ID
    NSIndexPath  * indxPath     = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    NSInteger dynamicId         = dynamicFrame.dynamicModel.dynamicId;
    NSInteger dynamicZanCount   = dynamicFrame.dynamicModel.zanCount;
    

    //向外传递
    [self.delegate dynamicZanClick:dynamicId NowView:label NowZanCount:dynamicZanCount ZanBlock:^{
        dynamicFrame.dynamicModel.isZan = YES;
        dynamicFrame.dynamicModel.zanCount = dynamicFrame.dynamicModel.zanCount + 1;
        [_tableview reloadData];
    }];
    
}

//关注点击
-(void)concernClick:(DynamicCell *)cell {
    
    //获取当前动态的发布人ID
    NSIndexPath  * indxPath     = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    NSInteger      userId       = dynamicFrame.dynamicModel.userId;

    [self.delegate dynamicConcernClick:userId ConcernBlock:^{
        dynamicFrame.dynamicModel.isGuanZhu = YES;
        [_tableview reloadData];
    }];
}

//删除动态
-(void)deleteBtnClick:(DynamicCell *)cell {

    
    //获取当前动态ID
    NSIndexPath  * indxPath     = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    NSInteger dynamicId         = dynamicFrame.dynamicModel.dynamicId;

    [self.delegate deleteDynamic:dynamicId];
}

//播放视频
-(void)videoPlayerBtnClick:(DynamicCell *)cell {
    
    //获取视频URL
    NSIndexPath  * indxPath     = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    
    NSString * videoUrlStr = @"";
    if(dynamicFrame.dynamicModel.videoType == 0){
        videoUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dynamicFrame.dynamicModel.videoUrl];
    }else{
        videoUrlStr = dynamicFrame.dynamicModel.videoUrl;
    }

    [self.delegate dynamicVideoPlayer:videoUrlStr];
    
}

//重新加载数据
-(void)reloadData {
    [_tableview beginHeaderRefresh];
}

- (Base_UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[Base_UIViewController class]]) {
            return (Base_UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
@end
