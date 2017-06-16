#import "OrganizationUserViewController.h"
#import "OrganizationUserCell.h"
#import "UserDetailViewController.h"

@interface OrganizationUserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation OrganizationUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团体成员";
    
    //
    [self initVar];

    //创建表视图
    [self createTableview];
    
    //初始化数据
    [self initData];
}

-(void)initVar {
    _tableData = [NSArray array];
}

-(void)initData {
    
    [self startLoading];
    
    NSArray * params = @[@{@"key":@"o_id",@"value":@(self.organizationId)}];
    NSString * url   = [G formatRestful:API_ORGANIZATION_MEMBER Params:params];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        _tableData = array;
        
        [_tableview reloadData];
        
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
    }];
    
}

//创建表视图
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
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationUserCell * cell = [[OrganizationUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dictData[@"u_id"] integerValue];
    userDetailVC.username = dictData[@"u_username"];
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
    
}
@end
