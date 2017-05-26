//
//  ListenFriendViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ListenFriendViewController.h"
#import "ListenFriendCell.h"

@interface ListenFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    NSInteger          _skip;
    UIView           * _radioHintView;
}
@end

@implementation ListenFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"听朋友";
    
    //初始化变量
    [self initVar];
    
    //创建导航按钮
    [self createNav];
    
    //创建表视图
    [self createTableView];
    
    //获取附近人的数据
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
    
    NSArray * paramsArr = @[
                            @{@"key":@"skip",@"value":@(_skip)},
                            @{@"key":@"limit",@"value":@(PAGE_LIMIT)}
                            ];
    
    NSString * url = [G formatRestful:API_RADIO_USER Params:paramsArr];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            [self endLoading];
        }
        
        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableview headerEndRefreshing];
            [_tableview resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
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
        NSLog(@"%@",error);
    }];
    
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"添加音频",addRadio);
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(15,0,0,0));
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
    _skip = 0;
    [self initData:@"reload"];
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
    
    ListenFriendCell * cell = [[ListenFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    NSLog(@"用户详细");
}

-(void)addRadio {
    NSLog(@"add");
}
@end
