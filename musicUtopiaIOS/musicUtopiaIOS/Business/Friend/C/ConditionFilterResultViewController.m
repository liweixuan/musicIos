//
//  ConditionFilterResultViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ConditionFilterResultViewController.h"
#import "FriendCell.h"
#import "UserDetailViewController.h"

@interface ConditionFilterResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    NSInteger          _skip;
}
@end

@implementation ConditionFilterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选结果";
    
    [self initVar];
    
    [self createView];

    [self initData:@"init"];
}

-(void)initVar {
    _tableData = [NSMutableArray array];
    _skip = 0;
}

-(void)initData:(NSString *)type {
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    [self.filterParams addObject:@{@"key":@"skip",@"value":@(_skip)}];
    [self.filterParams addObject:@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url = [G formatRestful:API_ACCURATE_USER Params:self.filterParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        if([type isEqualToString:@"init"]){
            [self endLoading];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多用户");
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
            NSLog(@"%@",error);
    }];
    
}

-(void)createView {
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
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
    
    //上拉加载更多
    _tableview.loadMoreData = ^(){
        NSLog(@"loadMoreData...");
        [weakSelf loadMoreData];
        
    };
    
    _tableview.marginBottom = 10;
}

-(void)loadMoreData {
    
    _skip += PAGE_LIMIT;
    [self initData:@"more"];
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell * cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取好友信息
    NSDictionary * dictData = _tableData[indexPath.row];
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dictData[@"u_id"] integerValue];
    userDetailVC.username = dictData[@"u_username"];
    userDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDetailVC animated:YES];
}

@end
