#import "DynamicView.h"
#import "DynamicCell.h"
#import "LoadingView.h"
#import "DynamicModel.h"
#import "DynamicFrame.h"

@interface DynamicView()<DynamicCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    
    NSInteger          _skip;
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
    
    _skip      = 0;
    _tableData = [NSMutableArray array];
    
}

//数据获取
-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求动态列表数据...");
    
    //创建加载中遮罩
    if([type isEqualToString:@"init"]){
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
    }

    NSArray  * getParams = @[@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url       = [G formatRestful:API_DYNAMIC_SEARCH Params:getParams];
    
  
    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {

        NSMutableArray *tempArr = [NSMutableArray array];
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            REMOVE_LOADVIEW
        }
        
        
        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableview headerEndRefreshing];
            [_tableview resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
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
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0,0,0,0));
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
    
    
}

-(void)loadNewData {
    
    _skip = 0;
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
    [self.delegate dynamicZanClick:dynamicId NowView:label NowZanCount:dynamicZanCount];
    
}

//关注点击
-(void)concernClick:(DynamicCell *)cell {
    
    //获取当前动态的发布人ID
    NSIndexPath  * indxPath     = [_tableview indexPathForCell:cell];
    DynamicFrame * dynamicFrame = _tableData[indxPath.row];
    NSInteger      userId       = dynamicFrame.dynamicModel.userId;
    
    [self.delegate dynamicConcernClick:userId];
}


@end
