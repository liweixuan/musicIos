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

@interface MusicArticleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView     * _filterScrollView;
    NSArray          * _categoryArr;
    NSMutableArray   * _categoryLabelArr;
    NSArray          * _articleArr;
    Base_UITableView * _tableview;
    
}
@end

@implementation MusicArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐文章";
    
    //获取相应数据
    [self initData];
    
    //创建顶部筛选菜单
    [self createFilterView];
    
    //创建列表视图
    [self createTableview];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
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
            .L_Text(dictData[@"text"])
            .L_Tag(i)
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

-(void)initData {
    
    _categoryLabelArr = [NSMutableArray array];
    
    _categoryArr = @[
                     @{@"text":@"全部"},
                     @{@"text":@"民谣吉他"},
                     @{@"text":@"钢琴"},
                     @{@"text":@"古典吉他"},
                     @{@"text":@"小提琴"},
                     @{@"text":@"二胡"},
                     @{@"text":@"电音吉他"},
                     @{@"text":@"大提琴"},
                     @{@"text":@"小号"},
                     @{@"text":@"电声贝斯"},
                     @{@"text":@"长笛"},
                     @{@"text":@"萨克斯管"},
                     @{@"text":@"单簧管"},
                     @{@"text":@"口琴"},
                     @{@"text":@"尤克里里"},
                     @{@"text":@"架子鼓"}
                     ];
    
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
    
    
}

//创建列表视图
-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] initWithFrame:CGRectMake(0,[_filterScrollView bottom]+15,D_WIDTH,D_HEIGHT_NO_NAV_STATUS - 15) style:UITableViewStylePlain];
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
    return _articleArr.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary * dictData = _articleArr[indexPath.row];
    
    if([dictData[@"type"] integerValue] == 1){
        
        ArticleNormalCell    * cell = [[ArticleNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dictData = dictData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if([dictData[@"type"] integerValue] == 2){
        
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
    
    if([dictData[@"type"] integerValue] == 1){
        return 100;
    }else if([dictData[@"type"] integerValue] == 2){
        return 240;
    }else{
        return 165;
    }
    
    return 80;
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
    
    NSLog(@"%ld",(long)vTag);
    
}


-(void)loadNewData {
    [_tableview headerEndRefreshing];
}

-(void)loadMoreData {
    [_tableview footerEndRefreshing];
}

@end
