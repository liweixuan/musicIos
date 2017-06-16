//
//  MusicArticleViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicArticleViewController.h"
#import "ArticleNormalCell.h"
#import "ArticleBigImageCell.h"
#import "ArticleMoreImageCell.h"
#import "MusicArticleDetailViewController.h"
#import "MusicArticlePreviewImageViewController.h"

@interface MusicArticleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView     * _filterScrollView;
    NSMutableArray   * _categoryArr;
    NSMutableArray   * _categoryLabelArr;
    NSMutableArray   * _articleArr;
    Base_UITableView * _tableview;
    
    NSInteger          _nowSelectCid;  //当前选择类别ID
    
    NSInteger          _skip;
    
}
@end

@implementation MusicArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐文章";
    
    //初始化变量
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
    _articleArr   = [NSMutableArray array];
    
    _categoryLabelArr = [NSMutableArray array];
    _categoryArr      = [LocalData getStandardMusicCategory];
    [_categoryArr insertObject:@{@"icon":@"",@"c_id":@(0) ,@"c_name":@"全部"} atIndex:0];
    
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

-(void)initData:(NSString *)type {
    

    //获取文章列表信息
    NSArray * params = @[
                         @{@"key":@"a_cid",@"value":@(_nowSelectCid)},
                         @{@"key":@"skip" ,@"value":@(_skip)},
                         @{@"key":@"limit",@"value":@(PAGE_LIMIT)}
    ];
    NSString * url = [G formatRestful:API_ARTICLE_SEARCH Params:params];
    
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    if([type isEqualToString:@"selectCategory"]){
        [self startActionLoading:@"文章获取中..."];
    }
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        if([type isEqualToString:@"init"]){
            [self endLoading];
        }
        
        if([type isEqualToString:@"selectCategory"]){
            [self endActionLoading];
        }
        
        if([type isEqualToString:@"reload"]){
            [_articleArr removeAllObjects];
            [_tableview  headerEndRefreshing];
            _tableview.mj_footer.hidden = NO;
            [_tableview  resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多文章信息");
            return;
        }
        
        
        if([type isEqualToString:@"more"]){
            [_articleArr addObjectsFromArray:[array mutableCopy]];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _articleArr = [array mutableCopy];
            
        }
        
        
        [_tableview reloadData];
        
        
        
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
    }];
    
    /*
    _articleArr = @[
                    @{@"type":@(1),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导，钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导"},
                    @{@"type":@(2),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导"},
                    @{@"type":@(3),@"image":@[
                              @{@"imageUrl":RECTANGLE_IMAGE_DEFAULT},
                              @{@"imageUrl":RECTANGLE_IMAGE_DEFAULT},
                              @{@"imageUrl":RECTANGLE_IMAGE_DEFAULT},
                              @{@"imageUrl":RECTANGLE_IMAGE_DEFAULT}
                              ],@"title":@"钢琴入门指导"},
                    @{@"type":@(1),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导"},
                    @{@"type":@(1),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导"},
                    @{@"type":@(2),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导"},
                    @{@"type":@(1),@"image":RECTANGLE_IMAGE_DEFAULT,@"title":@"钢琴入门指导，钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导钢琴入门指导"}
                    ];
    
    */
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
    
    _tableview.marginBottom = 10;
    
    
    
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articleArr.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary * dictData = _articleArr[indexPath.row];
    
    if([dictData[@"a_type"] integerValue] == 1){
        
        ArticleNormalCell    * cell = [[ArticleNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dictData = dictData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if([dictData[@"a_type"] integerValue] == 2){
        
        ArticleBigImageCell  * cell = [[ArticleBigImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dictData = dictData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        ArticleMoreImageCell * cell = [[ArticleMoreImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dictData = dictData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    return nil;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _articleArr[indexPath.row];
    
    if([dictData[@"a_type"] integerValue] == 1){
        return 100;
    }else if([dictData[@"a_type"] integerValue] == 2){
        return 240;
    }else{
        return 165;
    }
    
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _articleArr[indexPath.row];
    
    //图片展示
    if([dictData[@"a_type"] integerValue] == 3){

        MusicArticlePreviewImageViewController * musciArticlePImageVC = [[MusicArticlePreviewImageViewController alloc] init];
        musciArticlePImageVC.aid = [dictData[@"a_id"] integerValue];
        musciArticlePImageVC.imageType = 1;
        musciArticlePImageVC.imageArr  = dictData[@"images"];
        musciArticlePImageVC.imageIdx  = 0;
        
        musciArticlePImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:musciArticlePImageVC animated:YES completion:nil];
        

    //普通文章
    }else{
        
        PUSH_VC(MusicArticleDetailViewController,YES,@{@"newsDetail":dictData});

    }
    
    
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
