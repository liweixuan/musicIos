#import "MyPlayVideoViewController.h"
#import "MyVideoCell.h"
#import "AddMyPlayVideoViewController.h"
#import "VideoPlayerViewController.h"

@interface MyPlayVideoViewController ()<UITableViewDelegate,UITableViewDataSource,MyVideoDelegate>
{
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
    
    NSInteger          _skip;
}
@end

@implementation MyPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频演奏集";
    
    //初始化数据
    [self initVar];
    
    //创建导航菜单
    if(self.userid == [UserData getUserId]){
        [self createNav];
    }
    
    //创建演奏集列表
    [self createTableview];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //获取数据
    [self initData:@"init"];
}

-(void)initVar {
    
    _tableData = [NSMutableArray array];
    _skip      = 0;
    
}

-(void)initData:(NSString *)type {
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    
    NSInteger userID = [UserData getUserId];
    if(self.userid != 0){
        userID = self.userid;
    }
    
    NSArray * params = @[
                         @{@"key":@"upv_uid",@"value":@(userID)},
                         @{@"key":@"skip",@"value":@(_skip)},
                         @{@"key":@"limit",@"value":@(PAGE_LIMIT)}
  ];
    NSString * url   = [G formatRestful:API_USER_PLAY_VIDEO_SEARCH Params:params];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        if([type isEqualToString:@"init"]){
             [self endLoading];
            
            if(array.count < PAGE_LIMIT){
                [_tableview footerEndRefreshingNoData];
                _tableview.mj_footer.hidden = YES;
            }
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
            SHOW_HINT(@"已无更多演奏视频");
            return;
        }
        
        
        if([type isEqualToString:@"more"]){
            [_tableData addObjectsFromArray:[array mutableCopy]];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _tableData = [array mutableCopy];
            
        }
        
        
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        SHOW_HINT(error);
    }];
    
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"添加视频",addPlayVideo)
}

-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] initWithFrame:CGRectMake(0,15,D_WIDTH,D_HEIGHT_NO_NAV - 15) style:UITableViewStylePlain];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    
    [self.view addSubview:_tableview];
    
    _tableview.marginBottom = 10;
    
}

-(void)loadNewData {
    
    _skip = 0;
    [self initData:@"reload"];
    
    
}

-(void)loadMoreData {
    
    _skip += PAGE_LIMIT;
    [self initData:@"more"];
    
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyVideoCell * cell = [[MyVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.dictData = _tableData[indexPath.row];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    cell.delegate = self;
    
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];

    NSString * videoUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"upv_url"]];
    
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc] init];
    videoPlayerVC.videoUrl = videoUrlStr;
    videoPlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoPlayerVC animated:YES completion:nil];


}

-(void)addPlayVideo {
    PUSH_VC(AddMyPlayVideoViewController, YES, @{});
}

-(void)deletePlayVideoBtn:(MyVideoCell *)cell {
    

    //确定删除
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认操作" message:@"确定要删除该条演奏视频吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
        NSDictionary * dictData = _tableData[indexPath.row];
        
        NSDictionary * params = @{@"upv_id":dictData[@"upv_id"]};
        [self startActionLoading:@"正在删除视频..."];
        [NetWorkTools POST:API_USER_PLAY_VIDEO_DELETE params:params successBlock:^(NSArray *array) {
            [self endActionLoading];
            
            SHOW_HINT(@"视频删除成功");
            
            [_tableData removeObjectAtIndex:indexPath.row];
            [_tableview reloadData];
            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(error);
        }];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   
}
@end
