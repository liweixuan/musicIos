//
//  MusicVideoViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicVideoViewController.h"
#import "VideoCell.h"
#import "MusicArticlePreviewImageViewController.h"
#import "MusicVideoDetailViewController.h"

@interface MusicVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView     * _filterScrollView;
    NSMutableArray   * _categoryArr;
    NSMutableArray   * _categoryLabelArr;
    NSMutableArray   * _videoArr;
    Base_UITableView * _tableview;
    
    NSInteger          _nowSelectCid;  //当前选择类别ID
    
    NSInteger          _skip;
    
}
@end

@implementation MusicVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐视频";
    
    [self initVar];

    
    //创建顶部筛选菜单
    [self createFilterView];
    
    //创建列表视图
    [self createTableview];
    
    
    //获取相应数据
    [self initData:@"init"];

}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
}

-(void)initVar {
    _skip         = 0;
    _nowSelectCid = 0;
    _categoryArr  = [NSMutableArray array];
    _videoArr     = [NSMutableArray array];
    
    _categoryLabelArr = [NSMutableArray array];
    _categoryArr      = [LocalData getStandardMusicCategory];
    [_categoryArr insertObject:@{@"icon":@"",@"c_id":@(0) ,@"c_name":@"全部"} atIndex:0];
    
}


-(void)initData:(NSString *)type {
    
    
    //获取文章列表信息
    NSArray * params = @[
                         @{@"key":@"v_cid",@"value":@(_nowSelectCid)},
                         @{@"key":@"skip" ,@"value":@(_skip)},
                         @{@"key":@"limit",@"value":@(PAGE_LIMIT)}
                         ];
    NSString * url = [G formatRestful:API_VIDEO_SEARCH Params:params];
    
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    if([type isEqualToString:@"selectCategory"]){
        [self startActionLoading:@"视频获取中..."];
    }
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        NSLog(@"%@",array);
        
        if([type isEqualToString:@"init"]){
            [self endLoading];
        }
        
        if([type isEqualToString:@"selectCategory"]){
            [self endActionLoading];
        }
        
        if([type isEqualToString:@"reload"]){
            [_videoArr removeAllObjects];
            [_tableview  headerEndRefreshing];
            _tableview.mj_footer.hidden = NO;
            [_tableview  resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多视频信息");
            return;
        }
        
        
        if([type isEqualToString:@"more"]){
            [_videoArr addObjectsFromArray:[array mutableCopy]];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _videoArr = [array mutableCopy];
            
        }
        
        
        [_tableview reloadData];
        
        
        
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
    }];

}

-(void)createFilterView {
    
    UIView * filterBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,50))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_AddView(self.view);
    }];
    
    _filterScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,0,[filterBox width],[filterBox height]))
        .L_BgColor([UIColor whiteColor])
        .L_bounces(YES)
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_AddView(filterBox);
    }];
 
    //获取乐器分类
    CGFloat categoryItemH = [_filterScrollView height];
    
    CGFloat scrollWidth   = _categoryArr.count * 80;
    
    for(int i=0;i<_categoryArr.count;i++){
        
        NSDictionary * dictData = _categoryArr[i];
        
        CGFloat cx = i * 80;
        
        UIView * categoryView = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(cx,0,80,categoryItemH))
            .L_AddView(_filterScrollView);
        }];
        
        
        UIColor * categoryColor = HEX_COLOR(CONTENT_FONT_COLOR);
        
        if(i == 0){
            categoryColor = HEX_COLOR(APP_MAIN_COLOR);
        }
        
        UILabel * categoryLabel = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,0, [categoryView width],categoryItemH))
            .L_Text(dictData[@"c_name"])
            .L_Tag([dictData[@"c_id"] integerValue])
            .L_Font(CONTENT_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_isEvent(YES)
            .L_TextColor(categoryColor)
            .L_Click(self,@selector(catgeoryClick:))
            .L_AddView(categoryView);
        }];
       
        [_categoryLabelArr addObject:categoryLabel];
        
    }
    
    _filterScrollView.contentSize = CGSizeMake(scrollWidth,[_filterScrollView height]);
    
    
}


//创建列表视图
-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] initWithFrame:CGRectMake(0,[_filterScrollView bottom]+10,D_WIDTH,D_HEIGHT_NO_NAV_STATUS - 15) style:UITableViewStylePlain];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    
    [self.view addSubview:_tableview];

    
    
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videoArr.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell * cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _videoArr[indexPath.row];
    
    cell.dictData = dictData;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _videoArr[indexPath.row];
    
    MusicVideoDetailViewController * musicVideoDetailVC = [[MusicVideoDetailViewController alloc] init];
    musicVideoDetailVC.videoId = [dictData[@"v_id"] integerValue];
    [self.navigationController pushViewController:musicVideoDetailVC animated:YES];
    
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}


#pragma mark - 事件

//分类事件点击
-(void)catgeoryClick:(UITapGestureRecognizer *)tap {
    
    NSInteger vTag = tap.view.tag;
    
    //清除所有样式
    for(int i =0;i<_categoryLabelArr.count;i++){
        UILabel * la = (UILabel *)_categoryLabelArr[i];
        la.textColor = HEX_COLOR(CONTENT_FONT_COLOR);
    }
    
    //当前选中的
    UILabel * nowLabel = (UILabel *)tap.view;
    nowLabel.textColor = HEX_COLOR(APP_MAIN_COLOR);
    
    _nowSelectCid = vTag;
    
    _skip = 0;
    
    _tableview.mj_footer.hidden = NO;
    [_tableview resetNoMoreData];
    
    [self initData:@"selectCategory"];
    
}

-(void)loadNewData {
    
    _skip = 0;
    [self initData:@"reload"];
    
    
}

-(void)loadMoreData {
    
    _skip += PAGE_LIMIT;
    [self initData:@"more"];
    
}
@end
