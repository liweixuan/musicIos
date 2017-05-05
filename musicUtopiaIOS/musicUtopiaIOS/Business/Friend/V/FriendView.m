#import "FriendView.h"
#import "FriendCell.h"

@interface FriendView()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
    UIView           * _fieldLeftView;
}
@end

@implementation FriendView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        //创建头部视图
        [self createHeaderTableview];
        
    }
    return self;
}


-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
}


-(void)initVar {
    _tableData = [NSArray array];
}

-(void)createTableView {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
    
    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,160));
    }];
    
    //创建搜索框
    UITextField * searchField = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,2.5,[headerView width],42))
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
        .L_Frame(CGRectMake(D_WIDTH/2 - 80/2,5,80,42))
        .L_AddView(headerView);
    }];
    
    //占位标签
    UIImageView * searchIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(10,[_fieldLeftView height]/2 - MIDDLE_ICON_SIZE/2 - 2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
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
    
    
    //发现好友进入
    UIView * findFriendView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[searchField bottom]+CONTENT_PADDING_TOP,[headerView width],60))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_Click(self,@selector(findFriendClick))
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //发现好友图标
    UIImageView * findFriendIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,10,40,40))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(findFriendView);
    }];
    
    //标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([findFriendIcon right]+CONTENT_PADDING_LEFT,0, 100,[findFriendView height]))
        .L_Font(TITLE_FONT_SIZE)
        .L_Text(@"去发现朋友")
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_AddView(findFriendView);
    }];
    
    //右侧箭头
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([findFriendView width] - CONTENT_PADDING_LEFT - MIDDLE_ICON_SIZE,[findFriendView height]/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(findFriendView);
    
    }];
    
    //好友列表图标
    UIImageView * friendIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([findFriendView left],[findFriendView bottom]+20,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(headerView);
    }];
    
    //好友列表标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([friendIcon right]+ICON_MARGIN_CONTENT,[friendIcon top],100,CONTENT_FONT_SIZE))
        .L_Font(CONTENT_FONT_SIZE)
        .L_Text(@"好友列表")
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(headerView);
    }];
    
    
    
    
    
    _tableview.tableHeaderView = headerView;
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell * cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = @{};
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - 事件
-(void)findFriendClick {
    NSLog(@"。。。");
    [self.delegate findFriendClick];
}

@end