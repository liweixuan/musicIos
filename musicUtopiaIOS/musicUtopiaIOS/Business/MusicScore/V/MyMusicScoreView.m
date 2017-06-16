//
//  MyMusicScoreView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyMusicScoreView.h"
#import "MusicScoreItemCell.h"
#import "LoadingView.h"
#import "MusicScoreDetailViewController.h"

@interface MyMusicScoreView()<UITableViewDelegate,UITableViewDataSource,MusicScoreItemCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    
    BOOL               _isEdit; //是否为编辑模式
    NSInteger          _skip;
}
@end

@implementation MyMusicScoreView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        
    }
    return self;
}

-(void)initVar {
    _tableData = [NSMutableArray array];
    _isEdit    = NO;
    _skip      = 0;
}

-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    //创建加载中遮罩
    if([type isEqualToString:@"init"]){
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
    }
    
    //获取曲谱
    NSArray  * getParams = @[@{@"key":@"u_id",@"value":@([UserData getUserId])},@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url   = [G formatRestful:API_COLLECT_MUSIC_SCORE_SEARCH Params:getParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            REMOVE_LOADVIEW
            
            if(array.count < PAGE_LIMIT){
                _tableview.mj_footer.hidden = YES;
                [_tableview resetNoMoreData];
            }
            
        }
        
        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableview headerEndRefreshing];
            _tableview.mj_footer.hidden = NO;
            [_tableview resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多曲谱");
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
        REMOVE_LOADVIEW
        SHOW_HINT(error);
    }];
    
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
    
    
    _tableview.marginBottom = 10;
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
    
    MusicScoreItemCell * cell = [[MusicScoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.isEdit   = _isEdit;
    
    cell.dictData = dictData;
    
    cell.delegate = self;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    [self.delegate musicScoreClick:dictData];
    
}

-(void)editMode:(BOOL)isEdit {
    _isEdit = isEdit;
    [_tableview reloadData];
}

-(void)deleteMyMusicScore:(MusicScoreItemCell *)cell {
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    NSDictionary * dictData = _tableData[indexPath.row];
    NSInteger cmsId = [dictData[@"cms_id"] integerValue];

    [self.delegate deleteMyMusicScoreClick:cmsId Index:indexPath.row];
    
       
}

-(void)deleteIdxCell:(NSInteger)index {
    
    NSLog(@"%ld",(long)index);
    
    //删除当前数据源
    [_tableData removeObjectAtIndex:index];
    
    [_tableview reloadData];

    
}
@end
