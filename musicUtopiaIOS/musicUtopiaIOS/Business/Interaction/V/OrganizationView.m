#import "OrganizationView.h"
#import "LoadingView.h"
#import "OrganizationModel.h"
#import "OrganizationFrame.h"
#import "OrganizationCell.h"

@interface OrganizationView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * _loadView;
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
    
    NSInteger          _skip;
}
@end

@implementation OrganizationView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        
        NSLog(@"找团体视图初始化...");
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        
        
    }
    return self;
}

-(void)initVar {
    _skip = 0;
    _tableData = [NSMutableArray array];
}

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
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10,0,0,0));
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

//数据获取
-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求找找伙伴列表数据...");
    
    //创建加载中遮罩
    if([type isEqualToString:@"init"]){
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
    }
    
    NSArray  * getParams = @[@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url       = [G formatRestful:API_ORGANIZATION_SEARCH Params:getParams];
    
    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
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
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            //初始化数据源
            OrganizationModel * model = [OrganizationModel organizationWithDict:dict];
            OrganizationFrame * frame = [[OrganizationFrame alloc] initWithOrganization:model];
 
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
        
        NSLog(@"%@",error);
        
    }];
    
    
    
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
    
    OrganizationCell  * cell      = [[OrganizationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    OrganizationFrame * frameData = _tableData[indexPath.row];
    
    //设置位置
    cell.organizationFrame = frameData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置代理
    //cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationFrame * frameData = _tableData[indexPath.row];
    CGFloat cellHeight       = frameData.cellHeight;
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationFrame * frameData = _tableData[indexPath.row];
    [self.delegate organizationItemClick:frameData.organizationModel.organizationId];
}

@end
