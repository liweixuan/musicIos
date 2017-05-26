#import "ApplyFriendViewController.h"
#import "ApplyFriendCell.h"

@interface ApplyFriendViewController ()<UITableViewDelegate,UITableViewDataSource,ApplyFriendCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
}
@end

@implementation ApplyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友请求";
    
    [self initVar];
    
    //创建导航顶部按钮+菜单
    [self createNav];
    
    //创建列表视图
    [self createTableview];
    
    [self initData];
    
    //标记为已读
    [RongCloudData readConversationAllMessage:@"ADD_FRIEND_SYSTEM_USER" ConversationType:ConversationType_PRIVATE];
}

-(void)initVar{
    _tableData = [NSMutableArray array];
}

-(void)createNav {
    
}

-(void)createTableview {
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    

    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
}

-(void)initData {
    
    [self startLoading];
    
    //获取用户详细信息
    NSString * username = [UserData getUsername];
    NSArray  * params = @[@{@"key":@"username",@"value":username}];
    NSString * url = [G formatRestful:API_APPLY_FRIENDS_SEARCH Params:params];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        _tableData = [array mutableCopy];
        
        [_tableview reloadData];
        
        NSLog(@"%@",array);
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        NSLog(@"%@",error);
    }];
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyFriendCell * cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];


    cell.dictData = _tableData[indexPath.row];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(void)agreedToBtnClick:(ApplyFriendCell *)cell {
    
    NSIndexPath * indexPath    = [_tableview indexPathForCell:cell];
    NSMutableDictionary * dict = [_tableData[indexPath.row] mutableCopy];
    
    NSInteger frl_id = [dict[@"frl_id"] integerValue];
    NSDictionary * params = @{@"frl_id":@(frl_id),@"type":@"1"};
    
    [self startActionLoading:@"处理中..."];
    [NetWorkTools POST:API_AGREE_OR_REFUSE params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"已处理");
        
        NSLog(@"%@",array);
        
        //更改数据源
        [dict setObject:@(1) forKey:@"frl_status"];
        
        [_tableData replaceObjectAtIndex:indexPath.row withObject:dict];
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        NSLog(@"%@",error);
        [self endActionLoading];
    }];
    
    
}

-(void)refusedToBtnClick:(ApplyFriendCell *)cell {
    
    NSIndexPath * indexPath    = [_tableview indexPathForCell:cell];
    NSMutableDictionary * dict = [_tableData[indexPath.row] mutableCopy];
    
    NSInteger frl_id = [dict[@"frl_id"] integerValue];
    NSDictionary * params = @{@"frl_id":@(frl_id),@"type":@"0"};
    
    [self startActionLoading:@"处理中..."];
    [NetWorkTools POST:API_AGREE_OR_REFUSE params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"已处理");
        
        NSLog(@"%@",array);
        
        //更改数据源
        [dict setObject:@(2) forKey:@"frl_status"];
        
        [_tableData replaceObjectAtIndex:indexPath.row withObject:dict];
        
        [_tableview reloadData];
      
    } errorBlock:^(NSString *error) {
        NSLog(@"%@",error);
        [self endActionLoading];
    }];
    
}
@end
