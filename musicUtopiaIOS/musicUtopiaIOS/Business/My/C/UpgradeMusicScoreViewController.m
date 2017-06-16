//
//  UpgradeMusicScoreViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UpgradeMusicScoreViewController.h"
#import "MusicScoreItemCell.h"
#import "MusicScoreDetailViewController.h"
#import "UpgradeMusicScoreCell.h"

@interface UpgradeMusicScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation UpgradeMusicScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评测曲谱";
    
    //初始化变量
    [self initVar];
    
    //创建表视图
    [self createTableView];
    
    [self initData];
    
    
}

-(void)initVar {
    
    _tableData = [NSArray array];
    
}

-(void)initData {
    
    [self startLoading];
    
    self.cid   = 9;
    self.level = 1;
    
    //获取曲谱
    NSArray  * getParams = @[@{@"key":@"uclms_cid",@"value":@(self.cid)},@{@"key":@"uclms_level",@"value":@(self.level)}];
    NSString * url   = [G formatRestful:API_USER_UPGRADE_MUSIC_SCORE Params:getParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];

        _tableData = array;
        
        NSLog(@"####%@",_tableData);
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
    }];
    
}

-(void)createTableView {
    
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    
    _tableview.marginBottom = 10;

    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpgradeMusicScoreCell * cell = [[UpgradeMusicScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];

    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    musicScoreDetailVC.musicScoreName = dictData[@"ms_name"];
    musicScoreDetailVC.imageCount     = [dictData[@"mu_page"] integerValue];
    musicScoreDetailVC.musicScoreId   = [dictData[@"ms_id"] integerValue];
    musicScoreDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];

}
@end
