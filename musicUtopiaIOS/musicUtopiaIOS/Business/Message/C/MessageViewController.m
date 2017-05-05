#import "MessageViewController.h"
#import "MessageCell.h"
#import "PrivateChatViewController.h"
#import "MyPopView.h"
#import "ChatroomViewController.h"
#import "MusicVideoViewController.h"
#import "MusicArticleViewController.h"
#import "RichScanViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
    UIView           * _fieldLeftView;
    UIView           * _popView;
    UIView           * _maskView;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    //创建导航顶部按钮+菜单
    [self createNav];
    
    //创建右上角弹出菜单
    [self createPopView];
    
    //创建列表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self maskBoxClick];
}

//创建导航顶部按钮+菜单
-(void)createNav {
    
    //展开按钮
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(openMenuClick))
        .L_ImageName(ICON_DEFAULT);
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
                             @{@"icon":ICON_DEFAULT,@"text":@"聊天室"},
                             @{@"icon":ICON_DEFAULT,@"text":@"音乐文章"},
                             @{@"icon":ICON_DEFAULT,@"text":@"音乐视频"},
                             @{@"icon":ICON_DEFAULT,@"text":@"扫一扫"}
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
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_fieldLeftView);
    }];
    
    //占位标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([searchIcon right]+CONTENT_PADDING_LEFT,-2,50,[_fieldLeftView height]))
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
    return 10;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell * cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    PUSH_VC(PrivateChatViewController,YES,@{});
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


@end
