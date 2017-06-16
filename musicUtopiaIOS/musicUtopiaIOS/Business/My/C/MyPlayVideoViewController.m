#import "MyPlayVideoViewController.h"
#import "MyVideoCell.h"
#import "AddMyPlayVideoViewController.h"
#import "VideoPlayerViewController.h"

@interface MyPlayVideoViewController ()<UITableViewDelegate,UITableViewDataSource,MyVideoDelegate>
{
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
}
@end

@implementation MyPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的演奏集";
    
    //初始化数据
    [self initVar];
    
    //创建导航菜单
    [self createNav];
    
    //创建演奏集列表
    [self createTableview];
    
    //获取数据
    [self initData];
}

-(void)initVar {
    
    _tableData = [NSMutableArray array];
    
}

-(void)initData {
    
    [self startLoading];
    
    NSInteger userID = [UserData getUserId];
    if(self.userid != 0){
        userID = self.userid;
    }
    
    NSArray * params = @[@{@"key":@"upv_uid",@"value":@(userID)}];
    NSString * url   = [G formatRestful:API_USER_PLAY_VIDEO_SEARCH Params:params];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        NSLog(@"加载完毕...");

        _tableData = [array mutableCopy];
        
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
    [_tableview headerEndRefreshing];
}

-(void)loadMoreData {
    [_tableview footerEndRefreshing];
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
    
    NSLog(@"%@",dictData);
    
    
    
}
@end
