//
//  MatchView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MatchView.h"
#import "LoadingView.h"
#import "MatchCell.h"

@interface MatchView()<UITableViewDelegate,UITableViewDataSource,MatchCellDelegate>
{
    UIView * _loadView;
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation MatchView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        NSLog(@"找比赛视图初始化...");
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        //创建加载中遮罩
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
        
    }
    return self;
}

-(void)initVar {
    _tableData = [NSArray array];
}


//数据获取
-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求比赛列表数据...");
    
    //请求动态数据
    [NetWorkTools GET:API_MATCH_SEARCH params:nil successBlock:^(NSArray *array) {
        
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
        
        //删除加载动画
        REMOVE_LOADVIEW
        
        
    } errorBlock:^(NSString *error) {
        
        //向控制器发送错误
       //[self.delegate requestFaild:0];
        
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
    
    
    [self addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10,0,0,0));
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
    
    //向外传递
    [self.delegate voteClick:matchId];
    
    
}

@end
