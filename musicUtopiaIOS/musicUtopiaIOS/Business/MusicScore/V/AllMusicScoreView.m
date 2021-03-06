//
//  AllMusicScoreView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AllMusicScoreView.h"
#import "AllMusicScoreCell.h"
#import "LoadingView.h"

@interface AllMusicScoreView()<UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation AllMusicScoreView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
        
    }
    return self;
}

-(void)initVar {
    _tableData = [NSArray array];
}

-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    //获取曲谱类别
    [NetWorkTools GET:API_MUSIC_SCORE_CATEGORY params:nil successBlock:^(NSArray *array) {
        
        REMOVE_LOADVIEW
        
        _tableData = array;
        
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
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    
    _tableview.marginBottom = 10;
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllMusicScoreCell * cell = [[AllMusicScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    [self.delegate musicScoreCategoryClick:[dictData[@"msc_id"] integerValue]];
}
@end
