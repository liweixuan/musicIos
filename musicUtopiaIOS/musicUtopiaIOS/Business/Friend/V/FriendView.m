#import "FriendView.h"
#import "FriendCell.h"
#import "LoadingView.h"
#import "UserDetailViewController.h"
#import "SearchFriendViewController.h"

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
        
        
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
        
    }
    return self;
}



-(void)getData:(NSDictionary *)params Type:(NSString *)type {

    
    //获取好友列表
    NSArray  * fParams = @[@{@"key":@"f_username",@"value":params[@"u_username"]}];
    NSString * url     = [G formatRestful:API_FRIENDS_SEARCH Params:fParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        REMOVE_LOADVIEW
        
        _tableData = array;
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
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
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,120));
    }];
    
    //创建搜索框
//    UITextField * searchField = [UITextField TextFieldInitWith:^(UITextField *text) {
//        text
//        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,2.5,[headerView width],42))
//        .L_BgColor([UIColor whiteColor])
//        .L_radius_NO_masksToBounds(20)
//        .L_shadowOpacity(0.2)
//        .L_shadowOffset(CGSizeMake(3,3))
//        .L_ShadowColor([UIColor grayColor])
//        .L_AddView(headerView);
//    }];
    
    UIView * searchField = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,2.5,[headerView width],42))
        .L_BgColor([UIColor whiteColor])
        .L_radius_NO_masksToBounds(20)
        .L_shadowOpacity(0.2)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_Click(self,@selector(searchFriendClick))
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
        .L_Frame(CGRectMake(0,[_fieldLeftView height]/2 - MIDDLE_ICON_SIZE/2 - 2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Event(YES)
        .L_Click(self,@selector(searchFriendClick))
        .L_ImageName(@"sousuo")
        .L_AddView(_fieldLeftView);
    }];
    
    //占位标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([searchIcon right]+CONTENT_PADDING_LEFT,-2,100,[_fieldLeftView height]))
        .L_Text(@"搜索好友")
        .L_isEvent(YES)
        .L_Click(self,@selector(searchFriendClick))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_fieldLeftView);
    }];
    
    //左侧间隔
//    UIView * leftPaddingView = [UIView ViewInitWith:^(UIView *view) {
//        view
//        .L_Frame(CGRectMake(0,0,15,[searchField height]));
//    }];
    //searchField.L_LeftView(leftPaddingView);
    
    
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
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,10,40,40))
        .L_ImageName(@"find_friends")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_radius(5)
        .L_AddView(findFriendView);
    }];
    

    //标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([findFriendIcon right]+CONTENT_PADDING_LEFT,0, 100,[findFriendView height]))
        .L_Font(TITLE_FONT_SIZE)
        .L_Text(@"好友推荐")
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_AddView(findFriendView);
    }];
    
    //右侧箭头
    UIImageView * ricon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([findFriendView width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE,[findFriendView height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(@"fanhui")
        .L_AddView(findFriendView);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([ricon left] - 100, [ricon top],100,ATTR_FONT_SIZE))
        .L_Text(@"开启朋友发现之旅")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(findFriendView);
    }];
    
    
    //好友列表图标
//    UIImageView * friendIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//        imgv
//        .L_Frame(CGRectMake([findFriendView left],[findFriendView bottom]+20,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
//        .L_ImageName(ICON_DEFAULT)
//        .L_AddView(headerView);
//    }];
    
//    //好友列表标题
//    [UILabel LabelinitWith:^(UILabel *la) {
//        la
//        .L_Frame(CGRectMake([findFriendView left],[findFriendView bottom]+20,100,CONTENT_FONT_SIZE))
//        .L_Font(CONTENT_FONT_SIZE)
//        .L_Text(@"好友列表")
//        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
//        .L_AddView(headerView);
//    }];
    
    _tableview.tableHeaderView = headerView;
    
    
    
}

//搜索好友点击
-(void)searchFriendClick {
 
    SearchFriendViewController * searchFriendVC = [[SearchFriendViewController alloc] init];
    searchFriendVC.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:searchFriendVC animated:YES];
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell * cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"行点击...");
    
    //获取好友信息
    NSDictionary * dictData = _tableData[indexPath.row];
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dictData[@"u_id"] integerValue];
    userDetailVC.username = dictData[@"u_username"];
    userDetailVC.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:userDetailVC animated:YES];
}

#pragma mark - 事件
-(void)findFriendClick {
    [self.delegate findFriendClick];
}


- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
@end
