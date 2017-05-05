#import "ChatroomViewController.h"
#import "ChatroomListCell.h"
#import "CreateChatroomViewController.h"
#import "ChatroomChatViewController.h"

@interface ChatroomViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主题聊天室";
    
    //创建导航按钮
    [self createNav];
    
    //创建列表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];
    
}

//创建导航按钮
-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"创建",createRoom);
}

//创建列表视图
-(void)createTableview {
    
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
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,130));
    }];
    
    //创建卡片容器
    UIView * headerBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,D_WIDTH - CARD_MARGIN_LEFT * 2,80))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //左侧人数显示
    UILabel * userCountLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,80/2-TITLE_FONT_SIZE/2 - 12,30,TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Text(@"99")
        .L_AddView(headerBox);
    }];
    
    //在线标识文字
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[userCountLabel bottom] + 5,30,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"在线")
        .L_AddView(headerBox);
    }];
    
    //右侧分割线
    UIView * rightLine = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake([userCountLabel right]+CONTENT_PADDING_LEFT,10,1,[headerBox height] - 20))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(headerBox);
    }];
    
    //创建图标
    UIImageView * officialIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        
        imgv
        .L_Frame(CGRectMake([rightLine right]+CONTENT_PADDING_LEFT,12,50,50))
        .L_ImageName(IMAGE_DEFAULT)
        .L_radius(25)
        .L_AddView(headerBox);
    }];
    
    //标题
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([officialIcon right]+CONTENT_PADDING_LEFT,0,200,[headerBox height]))
        .L_Text(@"官方问答聊天室")
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_AddView(headerBox);
    }];
    
    //会员标题
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT+2,[headerBox bottom]+20, 100,TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_Text(@"会员")
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_AddView(headerView);
    }];
    
    
    _tableview.tableHeaderView = headerView;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatroomListCell * cell = [[ChatroomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PUSH_VC(ChatroomChatViewController, YES, @{});
}

#pragma mark - 事件
-(void)createRoom {
    PUSH_VC(CreateChatroomViewController,YES,@{});
}
@end
