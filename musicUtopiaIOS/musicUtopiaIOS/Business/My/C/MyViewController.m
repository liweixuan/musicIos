#import "MyViewController.h"
#import "CardCell.h"
#import "GONMarkupParser_All.h"
#import "MyCell.h"
#import "MyEditViewController.h"
#import "SettingViewController.h"
#import "MyDynamicViewController.h"
#import "MyPlayVideoViewController.h"
#import "MyPartakeMatchViewController.h"
#import "MyHistoryMatchViewController.h"
#import "MyUpgradeViewController.h"

@interface MyViewController()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSDictionary     * _tableDictData;
}
@end

@implementation MyViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    //初始化变量
    [self initVar];
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"编辑",editInfoClick)

    //初始化数据
    [self initData];
    

    //开始加载
    [self startLoading];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
}

-(void)initVar {
    _tableDictData = [NSDictionary dictionary];
}

-(void)initData {
    
    //获取个人信息
    NSInteger uid       = [UserData getUserId];
    NSString * username = [UserData getUsername];
    
    NSArray * params = @[@{@"key":@"u_id",@"value":@(uid)},@{@"key":@"u_username",@"value":username}];
    NSString * url   = [G formatRestful:API_USER_DETAIL_INFO Params:params];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        _tableDictData = (NSDictionary *)array;

        //创建表视图
        [self createTableview];
        
        //创建头部视图
        [self createHeaderview];

        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        NSLog(@"%@",error);
    }];
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
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(-15,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}
//创建头部视图
-(void)createHeaderview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,380));
    }];

    //头视图容器
    UIView * headerBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,210))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_AddView(headerView);
    }];
    
     //背景
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,-55,D_WIDTH,190))
        .L_ImageName(@"my_header_bg")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(headerBox);
    }];
    
    //头像
    NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_tableDictData[@"u_header_url"]];
    NSLog(@"%@",headerUrl);
    UIImageView * headerImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 70/2,70/2+20,70,70))
        .L_ImageUrlName(headerUrl,HEADER_DEFAULT)
        .L_Round()
        .L_AddView(headerBox);
    }];
    
    //右侧编辑按钮
//    [UILabel LabelinitWith:^(UILabel *la) {
//        la
//        .L_Frame(CGRectMake(D_WIDTH - 40 ,40,40,SUBTITLE_FONT_SIZE))
//        .L_Font(SUBTITLE_FONT_SIZE)
//        .L_Text(@"编辑")
//        .L_isEvent(YES)
//        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
//        .L_Click(self,@selector(editInfoClick))
//        .L_AddView(headerBox);
//    }];
    

    
    //昵称
    UILabel * nicknameLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/2 - 80 / 2,[headerImage bottom]+CONTENT_PADDING_TOP,80,SUBTITLE_FONT_SIZE))
        .L_Text(_tableDictData[@"u_nickname"])
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(headerBox);
    }];
    
    //性别标签
    NSString * sexIconStr = [BusinessEnum getSexIcon:[_tableDictData[@"u_sex"] integerValue]];
    UIImageView * sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - SMALL_ICON_SIZE/2 - ATTR_FONT_SIZE/2,[nicknameLabel bottom]+CONTENT_PADDING_TOP,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(sexIconStr)
        .L_AddView(headerBox);
    }];
    
    //性别内容
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([sexIcon right]+ICON_MARGIN_CONTENT,[sexIcon top],30,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_Text([BusinessEnum getSex:[_tableDictData[@"u_sex"] integerValue]])
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(headerBox);
    }];
    
    //乐币
    NSString *musicMoney = [NSString stringWithFormat:@"M币: <color value='#FFA500'>%@</>",_tableDictData[@"u_money"]];
    
    UILabel * musicMoneyTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,[sexIcon bottom]+10, [headerBox width]/2, SUBTITLE_FONT_SIZE))
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(headerBox);
    }];
    
    NSAttributedString *musicMoneyStr = [[GONMarkupParserManager sharedParser] attributedStringFromString:musicMoney error:nil];
    musicMoneyTitle.attributedText = musicMoneyStr;
    
    //当前最高乐器级别
    NSDictionary * levelDict = _tableDictData[@"instrumentLevels"][0];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([headerBox width]/2,[sexIcon bottom]+10, [headerBox width]/2, SUBTITLE_FONT_SIZE))
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text([NSString stringWithFormat:@"%@：%@级",levelDict[@"c_name"],levelDict[@"ul_level"]])
        .L_AddView(headerBox);
    }];
    
    //创建用户信息卡片
    UIView * userInfoBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[headerBox bottom]+CONTENT_PADDING_TOP,D_WIDTH - CARD_MARGIN_LEFT * 2,150))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //创建用户信息统计容器
    UIView * userInfoCountView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,5,[userInfoBox width],50))
        .L_AddView(userInfoBox);
    }];

    //循环创建4个统计数
    NSArray * countArr = @[
                           @{@"text":@"好友",@"count":_tableDictData[@"friendCount"]},
                           @{@"text":@"已关注",@"count":_tableDictData[@"userConcernCount"]},
                           @{@"text":@"被关注",@"count":_tableDictData[@"concernUserCount"]},
                           @{@"text":@"团体",@"count":_tableDictData[@"organizationCount"]}
                           ];
    
    //每项的大小
    CGFloat countItemW = [userInfoCountView width]/countArr.count;
    CGFloat countItemH = [userInfoCountView height];
    
    for(int i=0;i<countArr.count;i++){
        
        NSDictionary * dictData = countArr[i];
  
        UIView * countItem = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(i * countItemW,0,countItemW, countItemH))
            .L_AddView(userInfoCountView);
        }];
        
        //总量显示
        UILabel * countLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,5,countItemW - 14,ATTR_FONT_SIZE))
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_Text([NSString stringWithFormat:@"%@",dictData[@"count"]])
            .L_AddView(countItem);
        }];
        
        //标题
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,[countLabel bottom]+CONTENT_PADDING_TOP,countItemW - 14,CONTENT_FONT_SIZE))
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_Text(dictData[@"text"])
            .L_AddView(countItem);
        }];
        
        if(i <= countArr.count - 2){
            
            //右侧分割图标
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                imgv
                .L_Frame(CGRectMake(countItemW - 14, 0, 14, countItemH))
                .L_ImageName(@"test2.jpg")
                .L_ImageMode(UIViewContentModeScaleAspectFit)
                .L_AddView(countItem);
            }];
            
        }
 
    }
    
    //用户信息分割线
    UIView * userMiddleLine = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,[userInfoCountView bottom]+10,[userInfoCountView width],1))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(userInfoBox);
    }];
    
    //资料完善度容器
    UIView * personalDataView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,[userMiddleLine bottom]+CONTENT_PADDING_TOP,[userInfoBox width],60))
        .L_AddView(userInfoBox);
    }];
    
    //资料完善图标
    UIImageView * personalDataIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(10,-2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(@"ziliao")
        .L_AddView(personalDataView);
    }];
    
    //资料完善标题
    UILabel * personalDataTitle = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([personalDataIcon right]+ICON_MARGIN_CONTENT,[personalDataIcon top],120,20))
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Text(@"您的资料完善度：")
        .L_AddView(personalDataView);
    }];
    
    //进入总容器
    UIView * personalDataPercentage = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake([personalDataIcon left],[personalDataTitle bottom] + 7,[personalDataView width]-100,30))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(1,1))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(personalDataView);
    }];
    
    //容器进度
    UIView * progressValueView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,100,30))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_radius(5)
        .L_AddView(personalDataPercentage);
    }];
    
    //容器进度显示
    UILabel * progressValueLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,0,[progressValueView width],[progressValueView height]))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"20%")
        .L_TextColor([UIColor whiteColor])
        .L_AddView(progressValueView);
    }];
    
    //去完善按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake([personalDataPercentage right]+5,[personalDataPercentage top],80,[personalDataPercentage height]))
        .L_Title(@"去完善一下",UIControlStateNormal)
        .L_Font(12)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_TargetAction(self,@selector(editInfoClick),UIControlEventTouchUpInside)
        .L_AddView(personalDataView);
        
        
    } buttonType:UIButtonTypeCustom];
    
    
    /*
     @{@"text":@"官方教师",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
     @{@"text":@"独立教师",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
     @{@"text":@"主播",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
     @{@"text":@"赞助商",@"icon":@"zanzhushang",@"isOpen":@(1)}
     */
    
//    NSArray * identityArr = @[
//                              @{@"text":@"普通会员",@"icon":ICON_DEFAULT,@"isOpen":@(1)},
//                              @{@"text":@"VIP会员",@"icon":ICON_DEFAULT,@"isOpen":@(1)},
//                              ];
    //创建身份容器项
//    CGFloat identityItemW = [identityView width]/3;
//    CGFloat identityItemH = 30;
//    
//    for(int i=0;i<identityArr.count;i++){
//        
//        NSDictionary * dictData = identityArr[i];
//        
//        CGFloat col = i % 3;
//
//        CGFloat ix = col * identityItemW;
//
//        CGFloat row = i / 3;
//        
//        //上间距
//        CGFloat marginTop = 0.0;
//        
//        if(row > 0){
//            marginTop = 5;
//        }
//
//        CGFloat iy  = row * identityItemH + marginTop;
//        
//        //创建身份视图项
//        UIView * identityItem = [UIView ViewInitWith:^(UIView *view) {
//            
//            view
//            .L_Frame(CGRectMake(ix,iy,identityItemW, identityItemH))
//            .L_AddView(identityView);
//            
//        }];
//        
//        NSInteger isOpen = [dictData[@"isOpen"] integerValue];
//        
//        //身份图标
//        UIImageView * iconImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
//           imgv
//            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,identityItemH/2- MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
//            .L_ImageMode(UIViewContentModeScaleAspectFit)
//            .L_ImageName(dictData[@"icon"])
//            .L_AddView(identityItem);
//        }];
//        
//        //身份名称
//        UIColor * textColor = nil;
//        if(isOpen == 0){
//            textColor = HEX_COLOR(@"#CCCCCC");
//        }else{
//            textColor = HEX_COLOR(APP_MAIN_COLOR);
//        }
//        [UILabel LabelinitWith:^(UILabel *la) {
//            la
//            .L_Frame(CGRectMake([iconImage right]+CONTENT_PADDING_LEFT, 0,identityItemW, identityItemH))
//            .L_Font(SUBTITLE_FONT_SIZE)
//            .L_Text(dictData[@"text"])
//            .L_TextColor(textColor)
//            .L_AddView(identityItem);
//        }];
//     
//    }
    
    
    _tableview.tableHeaderView = headerView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
    return 0;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell * cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //判断相应列给予相应数据
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":@"wodedongtai",@"text":@"我的动态"};
        }else if(indexPath.row == 1){
            cell.dictData = @{@"icon":@"wodeyanzouji",@"text":@"我的演奏"};
        }else{
            cell.dictData = @{@"icon":@"wodeshoucang",@"text":@"我的收藏"};
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":@"wodebisai",@"text":@"比赛进行"};
        }else if(indexPath.row == 1){
            cell.dictData = @{@"icon":@"lishisaishi",@"text":@"历史赛事"};
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
             cell.dictData = @{@"icon":@"shengjiekaoshi",@"text":@"升级评测"};
        }
    }else{
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":@"shezhi",@"text":@"系统设置"};
        }
    }
    
    

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * titleSectionView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0, 0, D_WIDTH,40));
    }];
    
    //创建标题
    UILabel * titleSection = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(15,0,[titleSectionView width],30))
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(titleSectionView);
    }];
    
    //判断标题
    NSString * titleStr = @"";
    if(section == 0){
        titleStr = @"管理";
    }else if(section == 1){
        titleStr = @"比赛";
    }else if(section == 2){
        titleStr = @"升阶";
    }else{
        titleStr = @"设置";
    }
    
    //设置标题
    titleSection.L_Text(titleStr);
    
    return titleSectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            PUSH_VC(MyDynamicViewController,YES,@{});
            
        }else if(indexPath.row == 1){
            
            PUSH_VC(MyPlayVideoViewController, YES, @{});
            
        }else if(indexPath.row == 2){
            
            
            
        }
    }else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            PUSH_VC(MyPartakeMatchViewController, YES, @{});
        }else{
            PUSH_VC(MyHistoryMatchViewController, YES, @{});
        }
        
    }else if(indexPath.section == 2){
        
        if(indexPath.row == 0){
            
            PUSH_VC(MyUpgradeViewController,YES,@{});
            
        }
    
    }else if(indexPath.section == 3){
        
        if(indexPath.row == 0){
            
            NSLog(@"设置");
            PUSH_VC(SettingViewController, YES, @{});
            
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat sectionHeaderHeight = 30;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}


#pragma mark - 事件
//编辑用户信息
-(void)editInfoClick {
    PUSH_VC(MyEditViewController, YES, @{});
}

@end
