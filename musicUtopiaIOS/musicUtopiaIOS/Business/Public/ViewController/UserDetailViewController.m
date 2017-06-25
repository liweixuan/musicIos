//
//  UserDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserDetailViewController.h"
#import "CardCell.h"
#import "TagLabel.h"
#import "MyPlayVideoViewController.h"
#import "LookUserUpgradeVideoViewController.h"
#import "PrivateChatViewController.h"
#import "MyDynamicViewController.h"

@interface UserDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSDictionary     * _tableData;
    NSArray          * _levelArr;
    NSArray          * _rankArr;
    NSInteger          _isFriend;
}
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户详情";
    
    //初始化变量
    [self initVar];
    
    //初始化数据
    [self initData];
 
    //创建表视图
    [self createTableview];
    
    //创建右侧导航按钮
    [self createNav];

    
    [self startLoading];
}

-(void)initVar {
    _tableData = [NSDictionary dictionary];
}

-(void)initData {
    

    //获取用户详细信息
    NSArray * params = @[
                        @{@"key":@"u_id",@"value":@(self.userId)},
                        @{@"key":@"u_username",@"value":self.username},
                        @{@"key":@"f_username",@"value":[UserData getUsername]}
    ];
    NSString * url = [G formatRestful:API_USER_INFO_AND_IS_FRIEND Params:params];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endLoading];
        
        _tableData = (NSDictionary *)array;
        
        [_tableview reloadData];
        
        
        //判断是否显示添加好友
        if([_tableData[@"isFriend"] integerValue] == 0){
            
            //创建导航按钮
           // [self createNav];
            _isFriend = 0; //不是好友
            
            //创建打招呼按钮
            [self greetMessageBtn];

            
        }else if([_tableData[@"isFriend"] integerValue] == 1){
            
           // [self createDeleteNav];
            
            _isFriend = 1; //是好友
            
            //创建发消息按钮
            [self sendMessageBtn];
            
        }else {
            
            _isFriend = 2; //是自己
            
            //创建发消息按钮
            [self sendMessageBtn];
            
        }
        
        //更新本地存储的用户资料信息
        NSDictionary * userInfoDict = @{
                                        @"m_id"        : _tableData[@"u_id"],
                                        @"m_headerUrl" : _tableData[@"u_header_url"],
                                        @"m_userName"  : _tableData[@"u_username"],
                                        @"m_nickName"  : _tableData[@"u_nickname"],
                                    };
        
        //更新用户信息
        [MemberInfoData updateMemberInfo:userInfoDict];
   
      
        
    } errorBlock:^(NSString *error) {
        [self endLoading];
        NSLog(@"%@",error);
    }];
    
    
}

-(void)createNav {
    //R_NAV_TITLE_BTN(@"R",@"添加好友",addFriends);
    
    UIImageView * moreAction = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(moreActionClick))
        .L_ImageName(@"gengduocaozuo");
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:moreAction];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)moreActionClick {
    
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"用户操作" message:@"对该用户的相关操作" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [videoAlertController addAction:cancelAction];
    
    if(_isFriend == 0){
        
        UIAlertAction *replyFriendAction = [UIAlertAction actionWithTitle:@"申请好友" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"申请好友");
            [self addFriends];
            
        }];
        
        [videoAlertController addAction:replyFriendAction];
        
    }else if(_isFriend == 1){
        
        UIAlertAction *deleteFriendAction = [UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"删除好友");
            [self deleteFriends];
            
        }];
        
        [videoAlertController addAction:deleteFriendAction];
        
    }else{
        
        //自己，没有任何操作
        
    }
    
    if(self.isCacnelConcernAction){
        
        UIAlertAction *cancelConcernAction = [UIAlertAction actionWithTitle:@"取消关注" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"取消关注操作");
            
            
        }];
        
        [videoAlertController addAction:cancelConcernAction];

        
    }
 
    [self presentViewController:videoAlertController animated:YES completion:nil];
    
}

-(void)createDeleteNav {
    //R_NAV_TITLE_BTN(@"R",@"删除好友",deleteFriends);
}

//删除好友
-(void)deleteFriends {
    
    //判断是否强制更新
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除确认" message:@"您确定要将该用户从您的好友列表中删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"删除好友操作");
        
        [self startActionLoading:@"正在删除该好友..."];
        NSDictionary * params = @{
                                @"f_username"  : [UserData getUsername],
                                @"f_fusername" : self.username
                                };
        [NetWorkTools POST:API_DELETE_FRIEND params:params successBlock:^(NSArray *array) {
            [self endActionLoading];
            
            SHOW_HINT(@"已删除该好友");
            
            [self createNav];
            
            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(error);
        }];
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(10,0,60,0));
    }];
    
    _tableview.marginBottom = 10;

}

-(void)greetMessageBtn {
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,D_HEIGHT_NO_NAV - BOTTOM_BUTTON_HEIGHT-8 ,D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor(HEX_COLOR(@"#3CB371"))
        .L_Title(@"打招呼",UIControlStateNormal)
        .L_TargetAction(self,@selector(greetMessage),UIControlEventTouchUpInside)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_ShadowColor([UIColor grayColor])
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
}

-(void)greetMessage {
    NSLog(@"打招呼");
}

-(void)sendMessageBtn {
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,D_HEIGHT_NO_NAV - BOTTOM_BUTTON_HEIGHT-8 ,D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor(HEX_COLOR(@"#3CB371"))
        .L_Title(@"发消息",UIControlStateNormal)
        .L_TargetAction(self,@selector(sendMessage),UIControlEventTouchUpInside)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_ShadowColor([UIColor grayColor])
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
    
    
}

//发送消息
-(void)sendMessage {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    PUSH_VC(PrivateChatViewController,YES,@{@"target":self.username});
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if(indexPath.row == 0){
        
        NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_tableData[@"u_header_url"]];
        
        //头像
        UIImageView * headerImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,50,50))
            .L_ImageUrlName(headerUrl,HEADER_DEFAULT)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        //年龄
        TagLabel * _ageLabel = [[TagLabel alloc] init];
        _ageLabel.frame = CGRectMake([headerImage right]+CONTENT_MARGIN_LEFT, [headerImage top]+8, 30, 15);
        _ageLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        _ageLabel.layer.masksToBounds = YES;
        _ageLabel.layer.cornerRadius  = 5;
        _ageLabel.insets = UIEdgeInsetsMake(2,5,2,5);
        _ageLabel.text = [NSString stringWithFormat:@"%@",_tableData[@"u_age"]];
        [cell.contentView addSubview:_ageLabel];
        
        //昵称
        UILabel * nickname = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake([_ageLabel right]+5,[headerImage top]+8,100,TITLE_FONT_SIZE))
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_Text(_tableData[@"u_nickname"])
            .L_AddView(cell.contentView);
            
        }];
        
        NSString * sexIconValue = @"";
        NSString * sexValue     = @"";
        if([_tableData[@"u_sex"] integerValue] == 0){
            sexIconValue = @"sex_nan";
            sexValue     = @"男";
        }else{
            sexIconValue = @"sex_nv";
            sexValue     = @"女";
        }
        
        //性别图标
        UIImageView * sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake([_ageLabel left],[nickname bottom]+8,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(sexIconValue)
            .L_AddView(cell.contentView);
        }];
        
        //性别
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([sexIcon right]+ICON_MARGIN_CONTENT,[sexIcon top],20,ATTR_FONT_SIZE))
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_Text(sexValue)
            .L_AddView(cell.contentView);
            
        }];
        
        //现有乐器等级容器
        UIView * levelBox = [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake([headerImage left],[headerImage bottom]+10,D_WIDTH - CARD_MARGIN_LEFT *2 - 15*2,0))
            .L_AddView(cell.contentView);
        }];
        
        _levelArr = _tableData[@"instrumentLevels"];
        for(int i = 0;i<_levelArr.count;i++){
            
            NSDictionary * dictData = _levelArr[i];
            
            NSLog(@"&&&&&%@",dictData);
            
            //创建UILabel
            TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(0,i*30 + i*5,130,30)];
            tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
            tagLabel.text = [NSString stringWithFormat:@"%@ %@ 级",dictData[@"c_name"],dictData[@"ul_level"]];
            tagLabel.textColor = [UIColor whiteColor];
            tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
            tagLabel.layer.masksToBounds = YES;
            tagLabel.layer.cornerRadius = 15;
            tagLabel.insets = UIEdgeInsetsMake(0,15, 0,30);
            [levelBox addSubview:tagLabel];
            
            
            //查看过级视频
            UILabel * lookVideo = [UILabel LabelinitWith:^(UILabel *la) {
               la
                .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 15 - 100 - 30,[tagLabel top],100,30))
                .L_Font(CONTENT_FONT_SIZE)
                .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
                .L_Tag(i)
                .L_Text(@"去看看过级视频")
                .L_isEvent(YES)
                .L_Click(self,@selector(lookVideoClick:))
                .L_AddView(levelBox);
            }];
            
            //右侧箭头
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
               imgv
                .L_Frame(CGRectMake([lookVideo right],[lookVideo top]+9,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
                .L_ImageName(@"fanhui")
                .L_AddView(levelBox);
            }];
            
        }
        
        [levelBox setHeight:30 * _levelArr.count + (_levelArr.count - 1) * 5];
    
    //个人信息
    }else if(indexPath.row == 1){
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"gerenxinxi")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"个人信息")
            .L_AddView(cell.contentView);
        }];
        
        //地址
        NSString * addressStr = [NSString stringWithFormat:@"所在地区：%@%@%@",_tableData[@"u_province_name"],_tableData[@"u_city_name"],_tableData[@"u_district_name"]];
        UILabel * addressLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+12,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(addressStr)
            .L_AddView(cell.contentView);
        }];
        
        //擅长乐器
        NSArray  * goodsArr   = [_tableData[@"u_good_instrument"] componentsSeparatedByString:@"|"];
        NSString * goodsStr   = [NSString stringWithFormat:@"擅长乐器：%@",goodsArr[1]];
        UILabel  * goodsLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[addressLabel bottom]+8,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(goodsStr)
            .L_AddView(cell.contentView);
        }];
        
        //琴龄
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[goodsLabel bottom]+8,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text([NSString stringWithFormat:@"乐器琴龄：%@ 年",_tableData[@"u_qin_age"]])
            .L_AddView(cell.contentView);
        }];
        
        
    //个人头衔
    }else if(indexPath.row == 2){
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"gerentouxian")
            .L_AddView(cell.contentView);
        }];
        
       UILabel * userRank = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"个人头衔")
            .L_AddView(cell.contentView);
        }];
        
        
        //现有头衔
        UIView * rankBox = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+10,D_WIDTH - CARD_MARGIN_LEFT *2 - 15*2,0))
            .L_AddView(cell.contentView);
        }];
        
        
        NSArray * ranksArr = _tableData[@"ranks"];
        if(ranksArr.count > 0){
            
            _rankArr = ranksArr;
            
            for(int i = 0;i<_rankArr.count;i++){
                
                NSDictionary * rankDict = _rankArr[i];
                
                //创建UILabel
                TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(0,i*30 + i*5,120,30)];
                tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
                tagLabel.text = rankDict[@"ur_name"];
                tagLabel.textColor = [UIColor whiteColor];
                tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
                tagLabel.layer.masksToBounds = YES;
                tagLabel.layer.cornerRadius = 15;
                tagLabel.insets = UIEdgeInsetsMake(0,15, 0,20);
                [rankBox addSubview:tagLabel];
                
                
            }
            
            [rankBox setHeight:30 * _rankArr.count + (_rankArr.count - 1) * 5];
            
        }else{
            
            _rankArr = @[@""];
            
            [UILabel LabelinitWith:^(UILabel *la) {
               la
                .L_Frame(CGRectMake([titleIcon left],[userRank bottom]+15,100,20))
                .L_Font(CONTENT_FONT_SIZE)
                .L_Text(@"暂无头衔")
                .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                .L_AddView(cell.contentView);
            }];
            
            
        }
        
        
        
    }else if(indexPath.row == 3){
        
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"gexingqianming")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"个性签名")
            .L_AddView(cell.contentView);
        }];
        
        NSString * sign = [BusinessEnum getEmptyString:_tableData[@"u_sign"]];
        if([sign isEqualToString:@""]){
            sign = @"他/她很懒，什么都没有留下";
        }
        
        UILabel * singLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+8,300,50))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(sign)
            .L_AddView(cell.contentView);
        }];
        
        [singLabel sizeToFit];
        
    }else if(indexPath.row == 4){
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"yanzouji")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"演奏集合")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+10,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(@"他/她的演奏集")
            .L_AddView(cell.contentView);
        }];
        
        //右侧箭头
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 30,70/2-SMALL_ICON_SIZE/2,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

    }else if(indexPath.row == 5){
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"dongtai")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"用户动态")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+10,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text(@"该用户发布的动态信息")
            .L_AddView(cell.contentView);
        }];
        
        //右侧箭头
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT - 30,70/2-SMALL_ICON_SIZE/2,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
        
    }else if(indexPath.row == 6){
        
        UIImageView * titleIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + 15,15,SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"qitaxinxi")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon right]+ICON_MARGIN_CONTENT,[titleIcon top],100,ATTR_FONT_SIZE))
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Text(@"其它信息")
            .L_AddView(cell.contentView);
        }];
        
        
        NSString * createtime = [G formatData:[_tableData[@"u_create_time"] integerValue] Format:@"YYYY-mm-dd"];
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([titleIcon left],[titleIcon bottom]+10,300,CONTENT_FONT_SIZE))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Text([NSString stringWithFormat:@"注册时间：%@",createtime])
            .L_AddView(cell.contentView);
        }];
    }
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        NSInteger instrumentLevelsCount = [_tableData[@"instrumentLevels"] count];
        return 90 + (instrumentLevelsCount * 30) + ((instrumentLevelsCount - 1) * 5) ;
    }else if(indexPath.row == 1){
        return 110;
    }else if(indexPath.row == 2){
        return 45 + (_rankArr.count *30) + ((_rankArr.count+1) * 5) ;
    }else if(indexPath.row == 3){
        return 80;
    }else if(indexPath.row == 4){
        return 70;
    }else if(indexPath.row == 5){
        return 70;
    }else if(indexPath.row == 6){
        return 70;
    }
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 4){

        PUSH_VC(MyPlayVideoViewController, YES, @{@"userid":@(self.userId)});
    
    }else if(indexPath.row == 5){
        

        PUSH_VC(MyDynamicViewController, YES, @{@"userid":@(self.userId)});
        
    }
    
    
}



-(void)addFriends {
    NSLog(@"添加好友");
    
    //获取当前用户的帐号
    NSString * nowUsername = [UserData getUsername];
    
    NSDictionary * params = @{@"sponsorUsername":nowUsername,@"receiveUsername":self.username};

    [self startActionLoading:@"正在处理..."];
    [NetWorkTools POST:API_APPLY_FRIENDS params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        SHOW_HINT(@"已成功发送添加申请");
        
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
    
}

-(void)lookVideoClick:(UITapGestureRecognizer *)tap {
    
    NSInteger tagValue = tap.view.tag;
    
    NSDictionary * dictData = _levelArr[tagValue];
    
    //查看过级视频
    LookUserUpgradeVideoViewController * lookUserUpgradeVideoVC = [[LookUserUpgradeVideoViewController alloc] init];
    lookUserUpgradeVideoVC.hidesBottomBarWhenPushed = YES;
    lookUserUpgradeVideoVC.userid = self.userId;
    lookUserUpgradeVideoVC.cid    = [dictData[@"c_id"] integerValue];
    [self.navigationController pushViewController:lookUserUpgradeVideoVC animated:YES];
    
    
}
@end
