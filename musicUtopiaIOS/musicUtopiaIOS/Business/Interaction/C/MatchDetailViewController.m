#import "MatchDetailViewController.h"
#import "MatchDetailCell.h"
#import "MatchUserVideoViewController.h"
#import "UserDetailViewController.h"
#import "MusicScoreDetailViewController.h"
#import "MatchPrizeDetailViewController.h"

@interface MatchDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MatchDetailCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSDictionary     * _tableData;
    NSArray          * _userData;
    NSArray          * _awardsArr;
}
@end

@implementation MatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比赛详细";
    
    //初始化数据
    [self initVar];
    
    //创建表视图
    [self createTableview];

    
    //初始化数据
    [self initData:@"init"];
}

-(void)initVar {
    _tableData = [NSDictionary dictionary];
    _userData  = [NSArray array];
    _awardsArr = [NSArray array];
}

-(void)initData:(NSString *)type {
    
    
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    NSArray  * params = @[@{@"key":@"match_id",@"value":@(self.matchId)}];
    NSString * url    = [G formatRestful:API_MATCH_DETAIL Params:params];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {

        
        if([type isEqualToString:@"reload"]){
            [_tableview headerEndRefreshing];
        }
        
        _tableData = (NSDictionary *)array;
        
        
        _userData  = _tableData[@"partakeUser"];
        
   
        [_tableview reloadData];
        
        
        if([type isEqualToString:@"init"]){
            [self endLoading];
            
            //创建头部视图
            [self createHeaderView];
        }

        
        
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
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = NO;
    
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
    
    _tableview.marginBottom = 10;
    
    
}

//创建头部视图
-(void)createHeaderView {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,340));

    }];
    
    //获奖情况标题
//    UILabel * awardsLabel = [UILabel LabelinitWith:^(UILabel *la) {
//       la
//        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, 0, [headerView width] - CONTENT_PADDING_LEFT, TITLE_FONT_SIZE))
//        .L_Font(TITLE_FONT_SIZE)
//        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
//        .L_Text(@"奖品信息")
//        .L_AddView(headerView);
//    }];
    
    //创建卡片容器
    UIView * awardsBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT * 2,325))
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
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP,[awardsBox width] - 100,30))
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Text([NSString stringWithFormat:@"[ %@ ]",_tableData[@"ms_name"]])
        .L_AddView(awardsBox);
    }];


    UIImageView * rightIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([headerView width] - CARD_MARGIN_LEFT,[matchTitle top]+8,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(@"fanhui")
        .L_AddView(headerView);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([rightIcon left] - 8 - 95,[rightIcon top],100,CONTENT_FONT_SIZE))
        .L_Text(@"查看赛事曲谱")
        .L_isEvent(YES)
        .L_Tag([_tableData[@"m_msid"] integerValue])
        .L_Click(self,@selector(showMusicScoreClick:))
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_textAlignment(NSTextAlignmentRight)
        .L_AddView(headerView);
    }];
    
    //奖品容器视图
    UIView * awardsItemBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[matchTitle bottom]+10, [awardsBox width] - CONTENT_PADDING_LEFT * 2, 210))
        .L_AddView(awardsBox);
    }];
    
    NSDictionary * prizaDict = _tableData[@"prize"] == nil ? nil : _tableData[@"prize"];

    NSString * firstName  = prizaDict[@"mp_first_name"]  == nil ? @"--" : prizaDict[@"mp_first_name"];
    NSString * secondName = prizaDict[@"mp_second_name"] == nil ? @"--" : prizaDict[@"mp_second_name"];
    NSString * thridName  = prizaDict[@"mp_third_name"]  == nil ? @"--" : prizaDict[@"mp_third_name"];
    
    NSString * firstRank  =  [BusinessEnum getEmptyString:prizaDict[@"mp_first_rank"]];
    NSString * secondRank =  [BusinessEnum getEmptyString:prizaDict[@"mp_second_rank"]];
    NSString * thridRank  = [BusinessEnum getEmptyString:prizaDict[@"mp_third_rank"]]; 

    
    //创建前三名奖品+用户信息
    _awardsArr = @[
                            @{@"image":prizaDict[@"mp_firest_image"],
                              @"text":firstName,@"order":@"第一名",
                              @"uid":prizaDict[@"mp_first_uid"],
                              @"username":[BusinessEnum getEmptyString:prizaDict[@"u1_username"]],
                              @"nickname":[BusinessEnum getEmptyString:prizaDict[@"u1_nickname"]],
                              @"headerUrl":[BusinessEnum getEmptyString:prizaDict[@"u1_header_url"]],
                              @"rank":firstRank
                            },
                            @{@"image":prizaDict[@"mp_second_image"],
                              @"text":secondName,
                              @"order":@"第二名",
                              @"uid":prizaDict[@"mp_second_uid"],
                              @"username":[BusinessEnum getEmptyString:prizaDict[@"u2_username"]],
                              @"nickname":[BusinessEnum getEmptyString:prizaDict[@"u2_nickname"]],
                              @"headerUrl":[BusinessEnum getEmptyString:prizaDict[@"u2_header_url"]],
                              @"rank":secondRank
                            },
                            @{@"image":prizaDict[@"mp_third_image"],
                              @"text":thridName,
                              @"order":@"第三名",
                              @"uid":prizaDict[@"mp_third_uid"],
                              @"username":[BusinessEnum getEmptyString:prizaDict[@"u3_username"]],
                              @"nickname":[BusinessEnum getEmptyString:prizaDict[@"u3_nickname"]],
                              @"headerUrl":[BusinessEnum getEmptyString:prizaDict[@"u3_header_url"]],
                              @"rank":thridRank
                            }
                            ];
    
    
    //宽度
    CGFloat awardsItemW = ([awardsItemBox width] - 10*2 )/3;
    
    for(int i =0;i<_awardsArr.count;i++){
        
        NSDictionary * dictData = _awardsArr[i];
        
        CGFloat marginLeft = i*10;
        
        if(i == 0){
            marginLeft = 0;
        }
        
        CGFloat ax  = i * awardsItemW + marginLeft;
        
        UIView * awardsItem = [UIView ViewInitWith:^(UIView *view) {
           
            view
            .L_Frame(CGRectMake(ax, 0, awardsItemW, 120))
            .L_BgColor([UIColor grayColor])
            .L_Click(self,@selector(awardsItemClick:))
            .L_tag(i)
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius(5)
            .L_AddView(awardsItemBox);
            
        }];
        
        NSString * prizaUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"image"]];
        
        UIImageView * awardsImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(0,0,[awardsItem width],80))
            .L_ImageUrlName(prizaUrl,IMAGE_DEFAULT)
            .L_raius_location(UIRectCornerTopLeft|UIRectCornerTopRight,5)
            .L_AddView(awardsItem);
        }];
        
        //奖品名称
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(5,0, [awardsItem width] - 10,25))
            .L_Font(12)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_numberOfLines(2)
            .L_Text(@"查看奖品详细")
            .L_AddView(awardsItem);
        }];
        
        UILabel * prizaOrderLabel = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(0,[awardsImage bottom],[awardsItem width],40))
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_TextColor([UIColor whiteColor])
            .L_Text(dictData[@"order"])
            .L_AddView(awardsItem);
        }];
        
        
//        //获奖人信息
//        UIView * smallRect = [UIView ViewInitWith:^(UIView *view) {
//           view
//            .L_Frame(CGRectMake(i*[awardsItem width] + i*10 + [prizaOrderLabel width]/2 - 16/2,[prizaOrderLabel bottom]+10,16,16))
//            .L_BgColor(HEX_COLOR(@"#CCCCCC"))
//            .L_radius(8)
//            .L_AddView(awardsItemBox);
//        }];
//        
//        //竖线
//        UIView * vLine = [UIView ViewInitWith:^(UIView *view) {
//           view
//            .L_Frame(CGRectMake([smallRect left] + [smallRect width]/2 - 2/2,[smallRect bottom],2,26))
//            .L_BgColor(HEX_COLOR(@"#CCCCCC"))
//            .L_AddView(awardsItemBox);
//        }];
        
        //获奖用户头像
        NSString * headerurl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"headerUrl"]];
        UIImageView * headerImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(i*[awardsItem width] + i*10 + [prizaOrderLabel width]/2 - 60/2,[prizaOrderLabel bottom]+10,60,60))
            .L_Event(YES)
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_Tag(i)
            .L_Click(self,@selector(prizaUserHeaderClick:))
            .L_Round()
            .L_AddView(awardsItemBox);
        }];
        
        if([dictData[@"headerUrl"] isEqualToString:@""]){
            headerImage.L_ImageName(@"wenhao");
        }else{
            headerImage.L_ImageUrlName(headerurl,HEADER_DEFAULT);
        }
        
        //用户昵称
        NSString * nickname = @"";
        if([dictData[@"nickname"] isEqualToString:@""]){
            nickname = @"[未结束]";
        }else{
            nickname = dictData[@"nickname"];
        }
        
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(i*[awardsItem width] + i*10 ,[headerImage bottom] + 7,[prizaOrderLabel width],12))
            .L_Font(12)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(nickname)
            .L_textAlignment(NSTextAlignmentCenter)
            .L_AddView(awardsItemBox);
        }];
    }
    
    //状态提示
    UILabel * statusLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT, [awardsItemBox bottom]+15, [headerView width],50))
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Font(TITLE_FONT_SIZE)
        .L_raius_location(UIRectCornerBottomLeft|UIRectCornerBottomRight,5)
        .L_AddView(headerView);
    }];
    
    NSInteger matchStatus = [_tableData[@"status"] integerValue];
    if(matchStatus == 0){
        statusLabel.L_Text(@"抱歉，比赛还未开始");
        statusLabel.L_TextColor(HEX_COLOR(@"#F5F5F5"));
        statusLabel.L_BgColor(HEX_COLOR(@"#E6CA79"));
    }else if(matchStatus == 1){
        statusLabel.L_Text([NSString stringWithFormat:@"比赛进行中，当前参与人数：[ %lu ] 人",(unsigned long)_userData.count]);
        statusLabel.L_TextColor([UIColor whiteColor]);
        statusLabel.L_BgColor(HEX_COLOR(@"#68D249"));
    }else{
        statusLabel.L_Text(@"抱歉，比赛已结束");
        statusLabel.L_TextColor(HEX_COLOR(@"#F5F5F5"));
        statusLabel.L_BgColor(HEX_COLOR(BG_GARY));
    }
    

    _tableview.tableHeaderView = headerView;
}


-(void)loadNewData {
    
    [self initData:@"reload"];
    
    
}



//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchDetailCell * cell = [[MatchDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell.idx      = indexPath.row;
    cell.dictData = _userData[indexPath.row];
    
    NSInteger matchStatus = [_tableData[@"status"] integerValue];
    cell.isVote = matchStatus;
    //cell.totalVoteCount   = [_tableData[@"totalVoteCount"] integerValue];
    
    cell.delegate = self;

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"行点击...");
    
    NSDictionary * dictData = _userData[indexPath.row];
    
    //只有进行中的可以投票
    MatchUserVideoViewController * matchUserVideoVC = [[MatchUserVideoViewController alloc] init];
    matchUserVideoVC.mpuId    = [dictData[@"mpu_id"] integerValue];
    matchUserVideoVC.videoUrl = dictData[@"mpu_video_url"];
    [self.navigationController pushViewController:matchUserVideoVC animated:YES];
    
    
    
}

-(void)voteBtnClick:(MatchDetailCell *)cell {
    NSLog(@"投票点击...");
    
    //获取相关参数信息
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    NSDictionary * dictData = _userData[indexPath.row];
    
    NSLog(@"%@",dictData);
    
    //获取比赛ID
    NSInteger matchId = [dictData[@"mpu_mid"] integerValue];
    
    //获取当前选择的用户ID
    NSInteger matchVoteUserId = [dictData[@"mpu_uid"] integerValue];
    
    //参与人记录ID
    NSInteger mpuId = [dictData[@"mpu_id"] integerValue];
    
    //投票参数
    NSDictionary * params = @{
                              @"mv_mid"      : @(matchId),
                              @"mv_votee_id" : @(matchVoteUserId),
                              @"mv_voter_id" : @([UserData getUserId]),
                              @"mpu_id"      : @(mpuId)
                              };
    
    [self startActionLoading:@"投票中..."];
    [NetWorkTools POST:API_MATCH_VOTE params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        SHOW_HINT(@"投票成功");
        
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
}

//点击获奖用户头像
-(void)prizaUserHeaderClick:(UITapGestureRecognizer *)tap{
    
    NSInteger tagValue = tap.view.tag;
    
    NSDictionary * dictData = _awardsArr[tagValue];
    
    if([dictData[@"uid"] integerValue] == 0){
        return;
    }
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dictData[@"uid"] integerValue];
    userDetailVC.username = dictData[@"username"];
    userDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDetailVC animated:YES];

}

//查看比赛曲谱
-(void)showMusicScoreClick:(UITapGestureRecognizer *)tap {

    //获取比赛曲谱信息
    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    musicScoreDetailVC.musicScoreName = _tableData[@"ms_name"];
    musicScoreDetailVC.imageCount     = [_tableData[@"mu_page"] integerValue];
    musicScoreDetailVC.musicScoreId   = [_tableData[@"m_msid"] integerValue];
    musicScoreDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];

}

//奖品点击时
-(void)awardsItemClick:(UITapGestureRecognizer *)tap {
    
    
    NSInteger tagValue = tap.view.tag;
 
    MatchPrizeDetailViewController * matchPrizeDetailVC = [[MatchPrizeDetailViewController alloc] init];
    matchPrizeDetailVC.prizeArr = _awardsArr;
    matchPrizeDetailVC.nowIdx   = tagValue;
    [self.navigationController pushViewController:matchPrizeDetailVC animated:YES];

}
@end
