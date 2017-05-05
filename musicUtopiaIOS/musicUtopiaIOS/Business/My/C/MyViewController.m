#import "MyViewController.h"
#import "CardCell.h"
#import "GONMarkupParser_All.h"
#import "MyCell.h"
#import "MyEditViewController.h"

@interface MyViewController()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation MyViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";

    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderview];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    UIImageView * bgImageview = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,-55,D_WIDTH,190))
        .L_ImageName(@"my_header_bg")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(headerBox);
    }];
    
    //头像
    UIImageView * headerImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 70/2,[bgImageview bottom] - 55 - 70/2,70,70))
        .L_ImageName(HEADER_DEFAULT)
        .L_AddView(headerBox);
    }];
    
    //右侧编辑按钮
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH - 40 ,40,40,SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_Text(@"编辑")
        .L_isEvent(YES)
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Click(self,@selector(editInfoClick))
        .L_AddView(headerBox);
    }];
    

    
    //昵称
    UILabel * nicknameLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(D_WIDTH/2 - 80 / 2,[headerImage bottom]+CONTENT_PADDING_TOP,80,SUBTITLE_FONT_SIZE))
        .L_Text(@"桃子小姐")
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_AddView(headerBox);
    }];
    
    //性别标签
    UIImageView * sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - SMALL_ICON_SIZE/2 - ATTR_FONT_SIZE/2,[nicknameLabel bottom]+CONTENT_PADDING_TOP,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(headerBox);
    }];
    
    //性别内容
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([sexIcon right]+ICON_MARGIN_CONTENT,[sexIcon top],30,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_Text(@"男")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(headerBox);
    }];
    
    //乐币
    NSString *musicMoney = [NSString stringWithFormat:@"M币: <color value='#FFA500'>200</>"];
    
    UILabel * musicMoneyTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,[sexIcon bottom]+20, [headerBox width]/2, SUBTITLE_FONT_SIZE))
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(headerBox);
    }];
    
    NSAttributedString *musicMoneyStr = [[GONMarkupParserManager sharedParser] attributedStringFromString:musicMoney error:nil];
    musicMoneyTitle.attributedText = musicMoneyStr;
    
    //当前最高乐器级别
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([headerBox width]/2,[sexIcon bottom]+20, [headerBox width]/2, SUBTITLE_FONT_SIZE))
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"古典吉他: 十阶 ")
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
                           @{@"text":@"好友",@"count":@"58"},
                           @{@"text":@"已关注",@"count":@"98"},
                           @{@"text":@"被关注",@"count":@"168"},
                           @{@"text":@"团体",@"count":@"8"}
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
            .L_Text(dictData[@"count"])
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
    
    //身份容器
    UIView * identityView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,[userMiddleLine bottom]+CONTENT_PADDING_TOP,[userInfoBox width],60))
        .L_AddView(userInfoBox);
    }];
    
    NSArray * identityArr = @[
                              @{@"text":@"普通会员",@"icon":ICON_DEFAULT,@"isOpen":@(1)},
                              @{@"text":@"VIP会员",@"icon":ICON_DEFAULT,@"isOpen":@(1)},
                              @{@"text":@"官方教师",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
                              @{@"text":@"独立教师",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
                              @{@"text":@"主播",@"icon":ICON_DEFAULT,@"isOpen":@(0)},
                              @{@"text":@"赞助商",@"icon":@"zanzhushang",@"isOpen":@(1)},
                              ];
    //创建身份容器项
    CGFloat identityItemW = [identityView width]/3;
    CGFloat identityItemH = 30;
    
    for(int i=0;i<identityArr.count;i++){
        
        NSDictionary * dictData = identityArr[i];
        
        CGFloat col = i % 3;

        CGFloat ix = col * identityItemW;

        CGFloat row = i / 3;
        
        //上间距
        CGFloat marginTop = 0.0;
        
        if(row > 0){
            marginTop = 5;
        }

        CGFloat iy  = row * identityItemH + marginTop;
        
        //创建身份视图项
        UIView * identityItem = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_Frame(CGRectMake(ix,iy,identityItemW, identityItemH))
            .L_AddView(identityView);
            
        }];
        
        NSInteger isOpen = [dictData[@"isOpen"] integerValue];
        
        //身份图标
        UIImageView * iconImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,identityItemH/2- MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_ImageName(dictData[@"icon"])
            .L_AddView(identityItem);
        }];
        
        //身份名称
        UIColor * textColor = nil;
        if(isOpen == 0){
            textColor = HEX_COLOR(@"#CCCCCC");
        }else{
            textColor = HEX_COLOR(APP_MAIN_COLOR);
        }
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([iconImage right]+CONTENT_PADDING_LEFT, 0,identityItemW, identityItemH))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_Text(dictData[@"text"])
            .L_TextColor(textColor)
            .L_AddView(identityItem);
        }];
     
    }
    
    
    _tableview.tableHeaderView = headerView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 4;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 2;
    }else if(section == 3){
        return 1;
    }else if(section == 4){
        return 1;
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
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"我的课程"};
        }else if(indexPath.row == 1){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"我的动态"};
        }else if(indexPath.row == 2){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"我的演奏集"};
        }else{
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"我的收藏"};
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"申请成为独立教师"};
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"正在参与的比赛"};
        }else if(indexPath.row){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"历史赛事"};
        }
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"购买视频课程"};
        }
    }else if(indexPath.section == 4){
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"升阶考试"};
        }
    }else{
        if(indexPath.row == 0){
            cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"设置"};
        }
    }
    
    

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"管理";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * titleSectionView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0, 0, D_WIDTH,30));
    }];
    
    //创建标题
    UILabel * titleSection = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,0, 100,30))
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(titleSectionView);
    }];
    
    //判断标题
    NSString * titleStr = @"";
    if(section == 0){
        titleStr = @"管理";
    }else if(section == 1){
        titleStr = @"申请";
    }else if(section == 2){
        titleStr = @"周/月/季赛";
    }else if(section == 3){
        titleStr = @"购买";
    }else if(section == 4){
        titleStr = @"升阶";
    }else{
        titleStr = @"设置";
    }
    
    //设置标题
    titleSection.L_Text(titleStr);
    
    return titleSectionView;
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
