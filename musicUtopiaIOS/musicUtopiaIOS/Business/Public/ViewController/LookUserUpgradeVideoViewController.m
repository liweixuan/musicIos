//
//  LookUserUpgradeVideoViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LookUserUpgradeVideoViewController.h"
#import "UserUpgradeVideoViewCell.h"
#import "VideoPlayerViewController.h"

@interface LookUserUpgradeVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
}
@end

@implementation LookUserUpgradeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"升级视频";
    
    //初始化数据
    [self initVar];

    //创建≈列表
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
    
    NSArray * params = @[@{@"key":@"uuv_uid",@"value":@(userID)},@{@"key":@"uuv_cid",@"value":@(self.cid)}];
    NSString * url   = [G formatRestful:API_USER_UPGRADE_VIDEO Params:params];
    
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


-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] initWithFrame:CGRectMake(0,15,D_WIDTH,D_HEIGHT_NO_NAV - 15) style:UITableViewStylePlain];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tableview];
    
    _tableview.marginBottom = 10;
    
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserUpgradeVideoViewCell * cell = [[UserUpgradeVideoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.dictData = _tableData[indexPath.row];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
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
@end
