//
//  MusicScoreCategoryViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicScoreCategoryViewController.h"
#import "MusicScoreItemCell.h"
#import "MusicScoreDetailViewController.h"
#import "SearchMusicScoreViewController.h"
#import "MusicScoreFilterView.h"
#import "MusicScorePrevImageViewController.h"

@interface MusicScoreCategoryViewController()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    UIView           * _fieldLeftView;
    UIView           * _popView;
    UIView           * _maskView;
    UIView           * _maskBoxView;             //遮罩总视图
    
    MusicScoreFilterView * _musicScoreFilterView;
    
    NSInteger          _skip;
}
@end

@interface MusicScoreCategoryViewController ()

@end

@implementation MusicScoreCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曲谱列表";
    
    //初始化变量
    [self initVar];
    
    //创建导航右侧图标
    [self createNav];
    
    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];

    //创建遮罩视图
    [self createMaskView];
    
    //创建各个菜单筛选项视图
    [self createFilterView];

    //初始化数据
    [self initData:@"init"];

}

-(void)initVar {
    _skip      = 0;
    _tableData = [NSMutableArray array];
}

-(void)initData:(NSString *)type {
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    //获取参数
    NSArray * params = @[@{@"key":@"ms_mscid",@"value":@(self.cid)},@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url   = [G formatRestful:API_MUSIC_SCORE_SEARCH Params:params];
    
    //获取曲谱信息
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        //删除加载动画
        if([type isEqualToString:@"init"]){
            [self endLoading];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多曲谱");
            return;
        }
        
        if([type isEqualToString:@"more"]){
            [_tableData addObjectsFromArray:array];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _tableData = [array mutableCopy];
            
        }

        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        SHOW_HINT(error);
    }];
    
}

//创建各个菜单筛选项视图
-(void)createFilterView {
    
    _musicScoreFilterView = [[MusicScoreFilterView alloc] initWithFrame:CGRectMake(D_WIDTH,0,D_WIDTH-80,D_HEIGHT)];
    _musicScoreFilterView.backgroundColor = HEX_COLOR(VC_BG);
    [self.navigationController.view addSubview:_musicScoreFilterView];
    
    
}


//创建导航右侧图标
-(void)createNav {
    
    //展开按钮
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,NAV_ICON_WIDTH, NAV_ICON_WIDTH))
        .L_Click(self,@selector(filterClick))
        .L_ImageName(@"fenleichaxun.jpg");
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;

    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    //列表视图事件部分
    __weak typeof(self) weakSelf = self;

    
    //上拉加载更多
    _tableview.loadMoreData = ^(){
        [weakSelf loadMoreData];
        
    };
    
    _tableview.marginBottom = 10;
    
}

-(void)loadMoreData {
    
    _skip = _skip += PAGE_LIMIT;
    [self initData:@"more"];

}

//创建全局遮罩视图
-(void)createMaskView {
    _maskBoxView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.navigationController.view);
    }];

    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,70));
    }];
    
    [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,[headerView width],TEXTFIELD_HEIGHT))
        .L_BgColor([UIColor whiteColor])
        .L_radius_NO_masksToBounds(20)
        .L_Click(self,@selector(searchMusciScore))
        .L_shadowOpacity(0.2)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_AddView(headerView);
    }];
    
    //默认占位视图
    _fieldLeftView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(D_WIDTH/2 - 150/2,15,150,TEXTFIELD_HEIGHT))
        .L_AddView(headerView);
    }];
    
    //占位标签
    UIImageView * searchIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(10,[_fieldLeftView height]/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(@"sousuo")
        .L_AddView(_fieldLeftView);
    }];
    
    //占位标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([searchIcon right]+CONTENT_PADDING_LEFT,0,150,[_fieldLeftView height]))
        .L_Text(@"根据曲谱名称搜索")
        .L_isEvent(YES)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Click(self,@selector(searchMusciScore))
        .L_AddView(_fieldLeftView);
    }];
    
    
    _tableview.tableHeaderView = headerView;
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicScoreItemCell * cell = [[MusicScoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    
    NSDictionary * dictData = _tableData[indexPath.row];
    musicScoreDetailVC.musicScoreName = dictData[@"ms_name"];
    musicScoreDetailVC.imageCount     = [dictData[@"mu_page"] integerValue];
    musicScoreDetailVC.musicScoreId   = [dictData[@"ms_id"] integerValue];
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];
}

#pragma mark - 事件
-(void)searchMusciScore {
    SearchMusicScoreViewController * searchMusicScoreVC = [[SearchMusicScoreViewController alloc] init];
    //searchMusicScoreVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    searchMusicScoreVC.musicScoreCategoryID = self.cid;
    [self.navigationController pushViewController:searchMusicScoreVC animated:YES];
    //[self presentViewController:searchMusicScoreVC animated:YES completion:nil];
}


//筛选按钮点击时
-(void)filterClick {
    NSLog(@"筛选...");
    
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.3;
        [_musicScoreFilterView setX:80];
    }];
}

//遮罩视图点击时
-(void)maskBoxClick {
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.0;
        [_musicScoreFilterView setX:D_WIDTH];
    }];
}




@end
