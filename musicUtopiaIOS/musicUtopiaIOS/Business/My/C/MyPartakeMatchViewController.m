//
//  MyPartakeMatchViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyPartakeMatchViewController.h"
#import "MatchCell.h"
#import "MatchDetailViewController.h"

@interface MyPartakeMatchViewController ()<UITableViewDelegate,UITableViewDataSource,MatchCellDelegate>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
    NSInteger          _skip;
}
@end

@implementation MyPartakeMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在参与的比赛";

    //初始化变量
    [self initVar];
    
    //创建表视图
    [self createTableView];
    
    //初始化数据
    [self initData];
    
    
}

-(void)initVar {
    _tableData = [NSArray array];
    _skip      = 0;
}

-(void)initData {
    
    //加载开始动画
    [self startLoading];
    
    //参数拼接
    NSArray * params = @[
                    @{@"key":@"mpu_uid",@"value":@([UserData getUserId])},
                    @{@"key":@"type",@"value":@(0)},
                    @{@"key":@"skip",@"value":@(_skip)},
                    @{@"key":@"limit",@"value":@(PAGE_LIMIT)}
    ];
    
    NSString * url = [G formatRestful:API_USER_PARTAKE_MATCH Params:params];
    
    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        NSLog(@"####%@",array);

        //删除加载动画
        [self endLoading];
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            //初始化数据源
            MatchModel * model = [MatchModel matchWithDict:dict];
            MatchFrame * frame = [[MatchFrame alloc] initWithMatch:model];
            
            [tempArr addObject:frame];
        }
        
        //更新数据数据
        _tableData = tempArr;
        
        //更新表视图
        [_tableview reloadData];

        
        
    } errorBlock:^(NSString *error) {
        
        
        
    }];
    
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
    
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10,0,0,0));
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
    [_tableview headerEndRefreshing];
}

-(void)loadMoreData {
    [_tableview footerEndRefreshing];
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchCell  * cell      = [[MatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    MatchFrame * frameData = _tableData[indexPath.row];
    
    //设置位置
    cell.matchFrame = frameData;
    
    cell.isPartakeMatch = YES;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置代理
    cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchFrame * frameData = _tableData[indexPath.row];
    CGFloat cellHeight       = frameData.cellHeight;
    return cellHeight;
}

#pragma mark - 事件处理
//去投票点击
-(void)voteClick:(MatchCell *)cell {
    
    //获取当前动态ID
    NSIndexPath * indxPath = [_tableview indexPathForCell:cell];
    MatchFrame * matchFrame = _tableData[indxPath.row];
    NSInteger matchId = matchFrame.matchModel.matchId;
    PUSH_VC(MatchDetailViewController, YES, @{@"matchId":@(matchId)});
 
    
}

//查看比赛结果
-(void)matchResultClick:(MatchCell *)cell {
    
    //获取当前动态ID
    NSIndexPath * indxPath = [_tableview indexPathForCell:cell];
    MatchFrame * matchFrame = _tableData[indxPath.row];
    NSInteger matchId = matchFrame.matchModel.matchId;
    PUSH_VC(MatchDetailViewController, YES, @{@"matchId":@(matchId)});
}

//参与比赛点击
-(void)partakeMatchClick:(MatchCell *)cell {
    
}

//退出比赛
-(void)quitMatchClick:(MatchCell *)cell {
    
    NSIndexPath * indxPath  = [_tableview indexPathForCell:cell];
    MatchFrame * matchFrame = _tableData[indxPath.row];
    NSInteger matchId       = matchFrame.matchModel.matchId;
    NSInteger userId        = [UserData getUserId];
    
    NSDictionary * params = @{@"m_id":@(matchId),@"u_id":@(userId)};
    
    [self startActionLoading:@"比赛退出中..."];
    [NetWorkTools POST:API_USER_QUIT_MATCH params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"您已成功退出该比赛");
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    NSLog(@"%ld",(long)matchId);
    
}
@end
