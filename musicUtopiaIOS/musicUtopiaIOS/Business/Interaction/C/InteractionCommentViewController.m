#import "InteractionCommentViewController.h"
#import "DynamicCell.h"
#import "DynamicCommentCell.h"
#import "DynamicCommentFrame.h"

@interface InteractionCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _replyView;
    NSMutableArray   * _tableData;
}
@end

@implementation InteractionCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态评论";
    NSLog(@"要查询的动态信息为：%@",self.dynamicFrame.dynamicModel.headerUrl);
    
    [self initVar];
    
    [self initData];

    //创建表视图
    [self createTableview];
    
    
    //创建底部回复框
    [self createReplyView];
    
}

-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {
    
    NSArray * tempArr = @[
                   @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"999",@"commentContent":@"庆历四年春， 滕子京谪守巴陵郡。 越明年， 政通人和， 百废具兴。 乃重修岳阳楼， 增其旧制， 刻唐贤今人诗赋于其上。 属予作文以记之。"},
                   @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"10",@"commentContent":@"予观夫巴陵胜状， 在洞庭一湖。"},
                   @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"9",@"commentContent":@"庆历四年的春天，滕子京被降职到巴陵郡做太守。到了第二年，政事顺利，百姓和乐，各种荒废的事业都兴办起来了。于是重新修建岳阳楼，扩大它原有的规模，把唐代名家和当代人的赋刻在它上面。嘱托我写一篇文章来记述这件事情。我观看那巴陵郡的美好景色，全在洞庭湖上。"},
                   @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"100",@"commentContent":@"庆历四年春"},
                   @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"29",@"commentContent":@"庆历四年春， 滕子京谪守巴陵郡。 越明年， 政通人和， 百废具兴。"}
                   ];
    
    for(int i =0;i<tempArr.count;i++){
        DynamicCommentFrame * frame = [[DynamicCommentFrame alloc] initWithDynamicComment:tempArr[i]];
        [_tableData addObject:frame];
    }
    
    
    
}

//创建底部回复框
-(void)createReplyView {
    
    _replyView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,D_HEIGHT - 64 - 50,D_WIDTH,50))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.8)
        .L_AddView(self.view);
    }];
    
    //回复输入框
    [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_replyView height]/2 - 38/2,[_replyView width] - 80, 38))
        .L_Placeholder(@"为该动态新增评论")
        .L_PaddingLeft(10)
        .L_BgColor(HEX_COLOR(@"F5F5F5"))
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_replyView);
    }];
    
    //发送按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_replyView width] - 75, [_replyView height]/2 - 30/2,80,30))
        .L_Title(@"回复",UIControlStateNormal)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_AddView(_replyView);
    } buttonType:UIButtonTypeCustom];
    
    
}

//创建表视图
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(0,0,50,0));
    }];
    
    _tableview.marginBottom = 10;
    
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

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        DynamicCell * cell  = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dynamicFrame   = self.dynamicFrame;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        DynamicCommentCell * cell = [[DynamicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle    = UITableViewCellSelectionStyleNone;
        
        //数据
        DynamicCommentFrame * frame = _tableData[indexPath.row - 1];
        cell.dynamicCommentFrame = frame;
        return cell;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return self.dynamicFrame.cellHeight;
    }

    DynamicCommentFrame * frame = _tableData[indexPath.row - 1];
    return frame.cellHeight;
}

-(void)loadNewData {
    [_tableview headerEndRefreshing];
}

-(void)loadMoreData {
    [_tableview footerEndRefreshing];
}

@end
