//
//  PartnerView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PartnerView.h"
#import "LoadingView.h"
#import "PartnerCell.h"
#import "PartnerModel.h"
#import "PartnerFrame.h"

@interface PartnerView()<UITableViewDelegate,UITableViewDataSource,PartnerCellDelegate>
{
    UIView * _loadView;
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
    NSInteger          _skip;
}
@end

@implementation PartnerView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        NSLog(@"找伙伴视图初始化...");
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];

        
        
    }
    return self;
}

-(void)initVar {
    _tableData = [NSMutableArray array];
    _skip      = 0;
}


-(void)createTableView {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5,0,0,0));
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
    
    _tableview.marginBottom = 10;
    
}

//数据获取
-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求找找伙伴列表数据...");
    
    //创建加载中遮罩
    if([type isEqualToString:@"init"]){
        _skip = 0;
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
    }
    
    NSArray  * getParams = @[@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url       = [G formatRestful:API_PARTNER_SEARCH Params:getParams];
    
    //请求动态数据
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            REMOVE_LOADVIEW
        }
        
        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableview headerEndRefreshing];
            [_tableview resetNoMoreData];
            _tableview.mj_footer.hidden = NO;
        }

        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多动态信息");
            return;
        }
        
        //将数据转化为数据模型
        for(NSDictionary * dict in array){

            //初始化数据源
            PartnerModel * model = [PartnerModel partnerWithDict:dict];
            PartnerFrame * frame = [[PartnerFrame alloc] initWithPartner:model];

            [tempArr addObject:frame];
        }

        if([type isEqualToString:@"more"]){
            [_tableData addObjectsFromArray:tempArr];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _tableData = tempArr;
            
        }
        
        //更新表视图
        [_tableview reloadData];
        
        
    } errorBlock:^(NSString *error) {

        //向控制器发送错误
        [self.delegate requestFaild:1];
        
    }];
    
    
    
}

-(void)loadNewData {
    _skip = 0;
    [self getData:nil Type:@"reload"];
    
}

-(void)loadMoreData {
    _skip += PAGE_LIMIT;
    [self getData:nil Type:@"more"];
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PartnerCell  * cell      = [[PartnerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    PartnerFrame * frameData = _tableData[indexPath.row];
    
    //设置位置
    cell.partnerFrame = frameData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置代理
    cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PartnerFrame * frameData = _tableData[indexPath.row];
    CGFloat cellHeight       = frameData.cellHeight;
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取当前动态ID
    PartnerFrame * partnerFrame = _tableData[indexPath.row];
    NSInteger userId   = partnerFrame.partnerModel.userId;
    NSString *username = partnerFrame.partnerModel.username;
    
    //向外传递
    [self.delegate publicUserHeaderClick:userId UserName:username];
    NSLog(@"行点击...");
}

#pragma mark - 事件处理
//动态用户头像点击
-(void)userHeaderClick:(PartnerCell *)cell {
    
    //获取当前动态ID
    NSIndexPath * indxPath = [_tableview indexPathForCell:cell];
    PartnerFrame * partnerFrame = _tableData[indxPath.row];
    NSInteger userId   = partnerFrame.partnerModel.userId;
    NSString *username = partnerFrame.partnerModel.username;
    
    //向外传递
    [self.delegate publicUserHeaderClick:userId UserName:username];
    
    
}


@end
