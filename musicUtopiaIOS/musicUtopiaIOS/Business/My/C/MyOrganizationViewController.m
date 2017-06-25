//
//  MyOrganizationViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyOrganizationViewController.h"
#import "MyCenterOrganizationCell.h"
#import "MyOrganizationEditViewController.h"

@interface MyOrganizationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
}
@end

@implementation MyOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的团体";
    
    //初始化变量
    [self initVar];
    
    //创建表视图
    [self createTableView];

   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //获取数据
    [self initData];
}

-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {
    
    NSArray  * getParams = @[@{@"key":@"o_create_userid",@"value":@([UserData getUserId])}];
    NSString * url       = [G formatRestful:API_USER_CREATE_USER_ORGANIZATION Params:getParams];
    
    [self startLoading];
    
    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
       
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            //初始化数据源
            OrganizationModel * model = [OrganizationModel organizationWithDict:dict];
            OrganizationFrame * frame = [[OrganizationFrame alloc] initWithOrganization:model];
            
            [tempArr addObject:frame];
        }
 
        //更新数据数据
        _tableData = tempArr;

        
        //更新表视图
        [_tableview reloadData];
        
        
        
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        NSLog(@"%@",error);
        
    }];
    
    
}

-(void)createTableView {
    
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(5,0,0,0));
    }];
 
    _tableview.marginBottom = 10;
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCenterOrganizationCell  * cell      = [[MyCenterOrganizationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    CGFloat cellHeight       = frameData.cellHeight - 22;

    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    OrganizationFrame * frameData = _tableData[indexPath.row];
    MyOrganizationEditViewController * myOrganizationEditVC = [[MyOrganizationEditViewController alloc] init];
    myOrganizationEditVC.organizationId = frameData.organizationModel.organizationId;
    [self.navigationController pushViewController:myOrganizationEditVC animated:YES];
}
@end
