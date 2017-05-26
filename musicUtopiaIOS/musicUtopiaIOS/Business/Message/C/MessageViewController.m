#import "MessageViewController.h"
#import "MessageCell.h"
#import "PrivateChatViewController.h"
#import "MyPopView.h"
#import "ChatroomViewController.h"
#import "MusicVideoViewController.h"
#import "MusicArticleViewController.h"
#import "RichScanViewController.h"
#import "ApplyFriendViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSMutableArray   * _tableData;
    UIView           * _fieldLeftView;
    UIView           * _popView;
    UIView           * _maskView;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    [self initVar];

    //创建导航顶部按钮+菜单
    [self createNav];
    
    //创建右上角弹出菜单
    [self createPopView];
    
    //创建列表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];
    
    //监听接收消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:@"RECEIVED_RCMESSAGE" object:nil];

    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self maskBoxClick];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self initData];
}

-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {

    _tableData = [[RongCloudData getConversationList] mutableCopy];
    [_tableview reloadData];
    
    NSLog(@"%@",_tableData);
    
    //更新未读消息总数
    NSInteger unmessageCount = [RongCloudData getUnMessageCount];
    TAB_UNMESSAGE_COUNT(unmessageCount)
    
}

//创建导航顶部按钮+菜单
-(void)createNav {
    
    //展开按钮
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,-1,18, 18))
        .L_Click(self,@selector(openMenuClick))
        .L_ImageName(@"jiahao");
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //忽略消息按钮
    R_NAV_TITLE_BTN(@"L",@"忽略",ignoreunMessage);
    
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    _tableview.marginBottom = 10;

}


//创建右上角弹窗
-(void)createPopView {
    
    //创建遮罩
    _maskView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.navigationController.view);
    }];
    

    _popView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(D_WIDTH - 100 - CONTENT_PADDING_LEFT,70,100,130))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_shadowOpacity(0.2)
        .L_Alpha(0.0)
        .L_ShadowColor([UIColor blackColor])
        .L_shadowOffset(CGSizeMake(3,3))
        .L_radius_NO_masksToBounds(5)
        .L_AddView(self.navigationController.view);
    }];
    
    _popView.hidden = YES;
    
    MyPopView * triangleView = [[MyPopView alloc] initWithFrame:CGRectMake([_popView width]-30,-10,25,15)];
    [_popView addSubview:triangleView];
    
    //在容器中创建菜单
    NSArray * popMenuArr = @[
                             @{@"icon":@"liaotianshi",@"text":@"聊天室"},
                             @{@"icon":@"wenzhang",@"text":@"音乐文章"},
                             @{@"icon":@"shipin",@"text":@"音乐视频"},
                             @{@"icon":@"saoyisao",@"text":@"扫一扫"}
    ];
    
    CGFloat popMenuY = 5.0;
    
    for(int i=0;i<popMenuArr.count;i++){
        
        UIView * popMenuBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, popMenuY,[_popView width] - CONTENT_PADDING_LEFT * 2,30))
            .L_tag(i)
            .L_Click(self,@selector(popMenuClick:))
            .L_AddView(_popView);
        }];
        
        //标题图标
        UIImageView * popMenuIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(0,[popMenuBox height]/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(popMenuArr[i][@"icon"])
            .L_AddView(popMenuBox);
        }];
        
        //标题
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([popMenuIcon right]+10,0, 60, [popMenuBox height]))
            .L_TextColor([UIColor whiteColor])
            .L_Text(popMenuArr[i][@"text"])
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(popMenuBox);
        }];
        
        if(i <= popMenuArr.count - 2){
            
            //分割线
            [UIView ViewInitWith:^(UIView *view) {
                view
                .L_Frame(CGRectMake(0,[popMenuBox height]-1, [popMenuBox width], 1))
                .L_BgColor(HEX_COLOR(@"#E0E0E0"))
                .L_AddView(popMenuBox);
            }];
            
        }
        
        
        
        popMenuY = [popMenuBox bottom];
    }
    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,70));
    }];
    
    //创建搜索框
    UITextField * searchField = [UITextField TextFieldInitWith:^(UITextField *text) {
       text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,[headerView width],TEXTFIELD_HEIGHT))
        .L_BgColor([UIColor whiteColor])
        .L_radius_NO_masksToBounds(20)
        .L_shadowOpacity(0.2)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_AddView(headerView);
    }];
    
    searchField.enabled = YES;
    
    //默认占位视图
    _fieldLeftView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(D_WIDTH/2 - 80/2,15,80,TEXTFIELD_HEIGHT))
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
        .L_Frame(CGRectMake([searchIcon right]+CONTENT_PADDING_LEFT,0,50,[_fieldLeftView height]))
        .L_Text(@"搜索")
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_fieldLeftView);
    }];
    
    //左侧间隔
    UIView * leftPaddingView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,15,[searchField height]));
    }];
    searchField.L_LeftView(leftPaddingView);

    
    _tableview.tableHeaderView = headerView;
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell * cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    RCConversation * rcc = _tableData[indexPath.row];
    
    cell.conversaction = rcc;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //当前会话信息
    RCConversation * rcc = _tableData[indexPath.row];
    
    if([rcc.targetId isEqualToString:@"ADD_FRIEND_SYSTEM_USER"]){
        PUSH_VC(ApplyFriendViewController,YES,@{});
        
        
    }else{
        PUSH_VC(PrivateChatViewController,YES,@{@"conversation":rcc});
    }
    
    
    
    
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除。。。。");
        
        //获取要删除会话的ID
        RCConversation * rcc    = _tableData[indexPath.row];
        NSString * targetId     = rcc.targetId;
        RCConversationType type = rcc.conversationType;
        
        BOOL isDelete = [RongCloudData removeTargetConversation:targetId ConversationType:type];
        
        //本地数据会话删除成功
        if(isDelete){
            
            //删除当前数据源
            [_tableData removeObjectAtIndex:indexPath.row];
            
            //删除UI
            [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //重新计算未读消息数
            NSInteger unmessageCount = [RongCloudData getUnMessageCount];
            TAB_UNMESSAGE_COUNT(unmessageCount)
            
        }
 
        
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - 事件
-(void)openMenuClick {

   [UIView animateWithDuration:0.3 animations:^{
       _popView.hidden = NO;
       _popView.alpha  = 1.0;
       _maskView.alpha = 0.3;
   }];
    
}

//菜单点击
-(void)popMenuClick:(UITapGestureRecognizer *)tap {
    NSInteger tagv = tap.view.tag;
    
    if(tagv == 0){
        
        PUSH_VC(ChatroomViewController, YES, @{});
        
    }else if(tagv == 1){
        
        PUSH_VC(MusicArticleViewController, YES, @{});

        
    }else if(tagv == 2){
        
        PUSH_VC(MusicVideoViewController, YES, @{});
        
    }else{
        
        PUSH_VC(RichScanViewController, YES, @{});

    }
}

//遮罩点击时
-(void)maskBoxClick {
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0.0;
        _popView.alpha  = 0.0;
    } completion:^(BOOL finished) {
        _popView.hidden = YES;
    }];
}

//忽略消息
-(void)ignoreunMessage {
    NSLog(@"忽略未读消息");
    [RongCloudData ignoreunAllMessage];
    [_tableview reloadData];
    
}

#pragma mark - 融云消息接收
-(void)receivedMessage:(NSNotification *)sender {

    _tableData = [[RongCloudData getConversationList] mutableCopy];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    
    
    
    
}
@end
