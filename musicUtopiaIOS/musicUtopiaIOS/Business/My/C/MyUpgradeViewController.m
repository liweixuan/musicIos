//
//  MyUpgradeViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyUpgradeViewController.h"
#import "MyUpgradeCell.h"
#import "AddUpgradeInstrumentViewController.h"
#import "InstrumentEvaluationViewController.h"

@interface MyUpgradeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation MyUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前等级";
    
    [self initVar];
    
    //创建导航
    [self createNav];
    
    //创建表视图
    [self  createTableview];
    
    //初始化数据
    [self initData];
}

-(void)initVar {
    
    _tableData = [NSArray array];
    
}

-(void)initData {
    
    //获取当前用户的已评测乐器等级
    NSArray * params = @[@{@"key":@"u_id",@"value":@([UserData getUserId])}];
    NSString * url   = [G formatRestful:API_USER_ALL_INSTRUMENT_LEVEL Params:params];
    [self startLoading];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        _tableData = array;
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        
    }];
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R", @"新增评测", addInstrument);
}

-(void)createTableview {
    
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyUpgradeCell * cell = [[MyUpgradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];

    NSInteger cid   = [dictData[@"ul_cid"] integerValue];
    NSInteger level = [dictData[@"ul_level"] integerValue];
    
    InstrumentEvaluationViewController * instrumentEvalutaionVC = [[InstrumentEvaluationViewController alloc] init];
    instrumentEvalutaionVC.cid   = cid;
    instrumentEvalutaionVC.level = level;
    [self.navigationController pushViewController:instrumentEvalutaionVC animated:YES];
    
}

#pragma mark - 点击事件
-(void)addInstrument {
    
    PUSH_VC(AddUpgradeInstrumentViewController, YES, @{@"alreadyCategoryArr":_tableData});
    
}
@end
