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
}
@end

@implementation ConditionFilterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选结果";
    
    [self initVar];
    
    [self initData];
    
    [self createView];
}

-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {
    
    [self startLoading];
    NSString * url = [G formatRestful:API_ACCURATE_USER Params:self.filterParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {

        [self endLoading];
        
        _tableData = [array mutableCopy];
        
        [_tableview reloadData];
        
        NSLog(@"%lu",(unsigned long)array.count);
    
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
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
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
    PUSH_VC(UserDetailViewController,YES, @{});
}

@end
