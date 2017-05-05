#import "MatchDetailViewController.h"
#import "MatchDetailCell.h"

@interface MatchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation MatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比赛详细";
    
    //初始化数据
    
    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderView];
}

//创建表视图
-(void)createTableview {
    
    
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

//创建头部视图
-(void)createHeaderView {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,260));
    }];
    
    //获奖情况标题
    UILabel * awardsLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, 0, [headerView width] - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Text(@"获奖情况")
        .L_AddView(headerView);
    }];
    
    //创建卡片容器
    UIView * awardsBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[awardsLabel bottom]+10,D_WIDTH - CARD_MARGIN_LEFT * 2,190))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //比赛曲目标题
    UILabel * matchTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP+5,[awardsBox width] - 100,CONTENT_FONT_SIZE))
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_Text(@"小星星变奏曲：古典吉他")
        .L_AddView(awardsBox);
    }];
    
    //状态
    UIButton * statusButton = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([awardsBox width] - 60 - CONTENT_PADDING_LEFT, [matchTitle top] - 8, 60, 30))
        .L_BgColor(HEX_COLOR(@"#cccccc"))
        .L_Font(CONTENT_FONT_SIZE)
        .L_Title(@"已结束",UIControlStateNormal)
        .L_radius(5)
        .L_AddView(awardsBox);
    } buttonType:UIButtonTypeCustom];
    
    //奖品容器视图
    UIView * awardsItemBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[statusButton bottom]+10, [awardsBox width] - CONTENT_PADDING_LEFT * 2, 120))
        .L_AddView(awardsBox);
    }];
    
    //创建前三名奖品
    NSArray * awardsArr = @[
                            @{@"image":RECTANGLE_IMAGE_DEFAULT,@"text":@"第一名奖品",@"order":@"第一名"},
                            @{@"image":@"test4.jpg",@"text":@"第二名奖品",@"order":@"第二名"},
                            @{@"image":RECTANGLE_IMAGE_DEFAULT,@"text":@"第三名奖品",@"order":@"第三名"}
                            ];
    
    //宽度
    CGFloat awardsItemW = ([awardsItemBox width] - 10*2 )/3;
    
    for(int i =0;i<awardsArr.count;i++){
        
        NSDictionary * dictData = awardsArr[i];
        
        CGFloat marginLeft = i*10;
        
        if(i == 0){
            marginLeft = 0;
        }
        
        CGFloat ax  = i * awardsItemW + marginLeft;
        
        UIView * awardsItem = [UIView ViewInitWith:^(UIView *view) {
           
            view
            .L_Frame(CGRectMake(ax, 0, awardsItemW, [awardsItemBox height]))
            .L_BgColor([UIColor grayColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(awardsItemBox);
            
        }];
        
        UIImageView * awardsImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(0,0,[awardsItem width],80))
            .L_ImageName(dictData[@"image"])
            .L_AddView(awardsItem);
        }];
        
        //奖品名称
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,([awardsItem height] - 40)/2 - 40/2, [awardsItem width],40))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_Text(dictData[@"text"])
            .L_AddView(awardsItem);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,[awardsImage bottom],[awardsItem width],40))
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_Text(dictData[@"order"])
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_AddView(awardsItem);
        }];
        
    }
    
    
    //投票标题
    UILabel * voteLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[awardsBox bottom]+20, [headerView width] - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Text(@"投票情况")
        .L_AddView(headerView);
    }];
    
  
    
    _tableview.tableHeaderView = headerView;
}


-(void)loadNewData {
    [_tableview headerEndRefreshing];
}

-(void)loadMoreData {
    [_tableview footerEndRefreshing];
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchDetailCell * cell = [[MatchDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dictData = @{};

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

@end
