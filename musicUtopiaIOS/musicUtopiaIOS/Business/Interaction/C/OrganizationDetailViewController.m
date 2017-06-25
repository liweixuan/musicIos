#import "OrganizationDetailViewController.h"
#import "CardCell.h"
#import "HorizontalScrollPhotoView.h"
#import "OrganizationUserViewController.h"
#import "OrganizationPhotoImageViewController.h"
#import "VideoPlayerViewController.h"

@interface OrganizationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ViewEventDelegate>
{
    Base_UITableView * _tableview;
    NSDictionary     * _organizationDetail;
    NSArray          * _organizationPhoto;
}
@end

@implementation OrganizationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团体详细";

    //初始化变量
    [self initVar];

    //初始化表视图
    [self createTableView];
    
    //创建导航按钮
    [self createNavBtn];
    
    //初始化数据
    [self initData];
    
    
}

//初始化变量
-(void)initVar {
    
}

//初始化数据
-(void)initData {
    
    
    //初始化数据
    [self startLoading];
    
    NSLog(@"请求团体详情数据...");
    
    //构建restful参数
    NSArray  * params = @[@{@"key":@"o_id",@"value":@(self.organizationId)}];
    NSString * URL    = [G formatRestful:API_ORGANIZATION_INFO Params:params];
 
    //请求动态数据
    [NetWorkTools GET:URL params:nil successBlock:^(NSArray *array) {
  
        NSDictionary * dictData = (NSDictionary *)array;
        
        //保存数据
        _organizationDetail = [dictData objectForKey:@"detail"];
        _organizationPhoto  = [dictData objectForKey:@"photo"];

        //更新表视图
        [_tableview reloadData];
        
        //删除加载动画
        [self endLoading];
        
        
    } errorBlock:^(NSString *error) {
        
        //向控制器发送错误
        NSLog(@"网路请求错误...");
        
    }];
    
    
}

//创建导航按钮
-(void)createNavBtn {
    
    UIImageView * moreAction = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(moreActionClick))
        .L_ImageName(@"gengduocaozuo");
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:moreAction];
    self.navigationItem.rightBarButtonItem = rightBtn;
    

    
    //R_NAV_TITLE_BTN(@"R",@"申请加入", applyAddOrganization)
}

-(void)moreActionClick {
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"团体操作" message:@"对该团体的相关操作" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [videoAlertController addAction:cancelAction];
    

    UIAlertAction *replyFriendAction = [UIAlertAction actionWithTitle:@"申请加入" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"申请加入团体");
            [self applyAddOrganization];
            
    }];
        
    [videoAlertController addAction:replyFriendAction];
  
    [self presentViewController:videoAlertController animated:YES completion:nil];
}

//初始化表视图
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
    
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //LOGO+名称+封面
    if(indexPath.row == 0){
        
        NSString * logoUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_logo"]];
        
        //创建LOGO
        UIImageView * logoImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,20,60,60))
            .L_ImageUrlName(logoUrl,IMAGE_DEFAULT)
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * oNameLabel = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(0,[logoImageView bottom]+5,D_WIDTH,30))
            .L_Text(_organizationDetail[@"o_name"])
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentCenter)
            .L_Font(18)
            .L_AddView(cell.contentView);
        }];
        
        NSString * coverUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_cover"]];
        
        //封面图
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT, [oNameLabel bottom] + CONTENT_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2, 230))
            .L_ImageUrlName(coverUrl,RECTANGLE_IMAGE_DEFAULT)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
    //所在地点
    }else if(indexPath.row == 1){

        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"suozaididian")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"所在地点：%@ - %@ - %@",_organizationDetail[@"o_province_name"],_organizationDetail[@"o_city_name"],_organizationDetail[@"o_district_name"]])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
    //成员数量
    }else if(indexPath.row == 2){

        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"chengyuanshuliang")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"成员数量：%@",_organizationDetail[@"o_user_count"]])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
    
    //团体类型
    }else if(indexPath.row == 3){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"tuantileixing")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"团体类型：%@",_organizationDetail[@"o_type"]])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
    //创立时间
    }else if(indexPath.row == 4){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"chuanglishijian")
            .L_AddView(cell.contentView);
        }];
        
        //创立日期格式化
        NSString * date = [G formatData:[_organizationDetail[@"o_create_time"] integerValue] Format:@"YYYY年MM月dd日"];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"创建时间：%@",date])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
    //创始人
    }else if(indexPath.row == 5){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"chuangshiren")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"创始人：%@",_organizationDetail[@"o_create_time"]])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
     
    //座右铭
    }else if(indexPath.row == 6){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"zuoyouming")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,0, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text([NSString stringWithFormat:@"座右铭：%@",_organizationDetail[@"o_motto"]])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
       
    //申请条件
    }else if(indexPath.row == 7){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"shenqingtiaojian")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(@"申请条件")
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        NSArray *askArr = [_organizationDetail[@"o_ask"] componentsSeparatedByString:@"|"];
        if(askArr.count > 0){
            
            CGFloat askItemY = [icon bottom] + CONTENT_PADDING_TOP;
            
            //条件内容
            for(int i =0;i<askArr.count;i++){
                
                UILabel * indexLabel = [UILabel LabelinitWith:^(UILabel *la) {
                    la
                    .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT*2,askItemY,16,16))
                    .L_Text([NSString stringWithFormat:@"%d",(i+1)])
                    .L_BgColor(HEX_COLOR(BG_GARY))
                    .L_Font(12)
                    .L_textAlignment(NSTextAlignmentCenter)
                    .L_TextColor(HEX_COLOR(@"#FFFFFF"))
                    .L_radius(8)
                    .L_AddView(cell.contentView);
                }];
                
                
                UILabel * label = [UILabel LabelinitWith:^(UILabel *la) {
                    
                    la
                    .L_Frame(CGRectMake([indexLabel right]+ICON_MARGIN_CONTENT, [indexLabel top]+1, [cell.contentView width],16))
                    .L_Text(askArr[i])
                    .L_Font(CONTENT_FONT_SIZE)
                    .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                    .L_AddView(cell.contentView);
                    
                }];
                
                askItemY = [label bottom] + 10;
                
            }
            
        }

        
        
    //信息描述
    }else if(indexPath.row == 8){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"miaoshu")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(@"信息描述")
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //计算字符串长度
        CGSize size = [G labelAutoCalculateRectWith:_organizationDetail[@"o_desc"] FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2 - INLINE_CELL_PADDING_LEFT, 1000)];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon bottom]+CONTENT_PADDING_TOP,D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2-INLINE_CELL_PADDING_LEFT,size.height))
            .L_Text(_organizationDetail[@"o_desc"])
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_numberOfLines(0)
            .L_lineHeight(CONTENT_LINE_HEIGHT)
            .L_AddView(cell.contentView);
        }];
      
    //相册
    }else if(indexPath.row == 9){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"xiangce")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(@"团体相册")
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //相册容器
        UIScrollView * photoBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
            view
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,[icon bottom]+CONTENT_PADDING_TOP, D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2, 120))
            .L_showsHorizontalScrollIndicator(NO)
            .L_AddView(cell.contentView);
        }];
        
        
        CGFloat photoItemSize = [photoBoxView height];
        CGFloat photoBoxX     = 0.0;
        
        if(_organizationPhoto.count > 0){
            
            //创建相册
            for(int i =0;i<_organizationPhoto.count;i++){
                
                NSString * imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationPhoto[i][@"op_img_url"]];
                
                UIImageView * photoItemView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                    imgv
                    .L_Frame(CGRectMake(photoItemSize * i + i*10,0,photoItemSize,photoItemSize))
                    .L_BgColor([UIColor whiteColor])
                    .L_ImageMode(UIViewContentModeScaleAspectFill)
                    .L_ImageUrlName(imageUrl,IMAGE_DEFAULT)
                    .L_Event(YES)
                    .L_Tag(i)
                    .L_Click(self,@selector(photoItemViewClick:))
                    .L_radius(5)
                    .L_AddView(photoBoxView);
                }];
                
                //创建相册名称
                [UILabel LabelinitWith:^(UILabel *la) {
                    la
                    .L_Frame(CGRectMake(0,[photoBoxView height]-40,[photoItemView width],40))
                    .L_BgColor([UIColor blackColor])
                    .L_alpha(0.5)
                    .L_Font(12)
                    .L_Text(_organizationPhoto[i][@"op_name"])
                    .L_TextColor([UIColor whiteColor])
                    .L_textAlignment(NSTextAlignmentCenter)
                    .L_AddView(photoItemView);
                }];
                
                if(i == _organizationPhoto.count - 1){
                    photoBoxX = [photoItemView right];
                }
                
            }
            
            //设置相册容器宽度
            photoBoxView.contentSize = CGSizeMake(photoBoxX, photoItemSize);
            
        }else{
            
            NSLog(@"无照片");
            
            [UILabel LabelinitWith:^(UILabel *la) {
               la
                .L_Frame(CGRectMake([photoBoxView width]/2 - 100/2,[photoBoxView height]/2 - 30/2 - 5, 100,30))
                .L_Font(12)
                .L_Text(@"暂无相册")
                .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                .L_textAlignment(NSTextAlignmentCenter)
                .L_AddView(photoBoxView);
            }];
        }
    }else if(indexPath.row == 10){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"send_video_high")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(@"宣传视频")
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //相册容器
        UIView * videoBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,[icon bottom]+CONTENT_PADDING_TOP, D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2,220))
            .L_BgColor([UIColor orangeColor])
            .L_AddView(cell.contentView);
        }];
        
        if(_organizationDetail[@"o_video_url"] == nil || [_organizationDetail[@"o_video_url"] isEqualToString:@""]){
            
            [UILabel LabelinitWith:^(UILabel *la) {
                la
                .L_Frame(CGRectMake([videoBoxView width]/2 - 100/2,[videoBoxView height]/2 - 30/2 - 5, 100,30))
                .L_Font(12)
                .L_Text(@"未上传宣传视频")
                .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                .L_textAlignment(NSTextAlignmentCenter)
                .L_AddView(videoBoxView);
            }];
            
            
        }else{
            
            NSString * videourl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_video_image"]];
            
            UIImageView * videoImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                imgv
                .L_Frame(CGRectMake(0,0,[videoBoxView width],[videoBoxView height]))
                .L_ImageMode(UIViewContentModeScaleAspectFill)
                .L_Event(YES)
                .L_ImageUrlName(videourl,IMAGE_DEFAULT)
                .L_radius(5)
                .L_AddView(videoBoxView);
            }];
            
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                imgv
                .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,[videoImage height]/2 - 60/2, 60, 60))
                .L_Event(YES)
                .L_Click(self,@selector(playerVideoClick))
                .L_ImageName(@"bofang")
                .L_radius(30)
                .L_AddView(videoImage);
            }];
            
        }
        
            
    }
       
//        UIView * photoView = (UIView *)[HorizontalScrollPhotoView createHorizontalScrollPhotoView:_organizationPhoto ViewSize:CGSizeMake([imageBoxView width], [imageBoxView height])];
//        [imageBoxView addSubview:photoView];
   
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return 370;
    }else if(indexPath.row == 7){
        
        NSArray *askArr = [_organizationDetail[@"o_ask"] componentsSeparatedByString:@"|"];
        CGFloat rowH = askArr.count * 16 + askArr.count * 10 + CONTENT_PADDING_TOP*3 + ATTR_FONT_SIZE;
        
        return rowH;
    }else if(indexPath.row == 8){
        
        //计算字符串长度
        CGSize size = [G labelAutoCalculateRectWith:_organizationDetail[@"o_desc"] FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2-INLINE_CELL_PADDING_LEFT, 1000)];
       return size.height + CONTENT_PADDING_TOP * 2 + ATTR_FONT_SIZE + 15;
        
    }else if(indexPath.row == 9){
        
        return 170;
        
    }else if(indexPath.row == 10){
        return 270;
    }

    return NORMAL_CELL_HIEGHT;
}

//视频播放按钮
-(void)playerVideoClick {
    NSLog(@"视频播放...");
    
    NSString *videoUrl= [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_video_url"]];
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc] init];
    videoPlayerVC.videoUrl = videoUrl;
    
    videoPlayerVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoPlayerVC animated:YES completion:nil];
}


//点击代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //查看成员
    if(indexPath.row == 2){
        PUSH_VC(OrganizationUserViewController, YES, @{@"organizationId":@(self.organizationId)});
    }
    
}

#pragma mark - 事件部分
-(void)applyAddOrganization {
    NSLog(@"123213123");
}

-(void)photoItemViewClick:(UITapGestureRecognizer *)tap {
    NSInteger tagValue = tap.view.tag;
    
    NSDictionary * dictData = _organizationPhoto[tagValue];
    
    //获取相册中的图片数据
    NSArray * params = @[@{@"key":@"op_oid",@"value":dictData[@"op_oid"]},@{@"key":@"op_fid",@"value":dictData[@"op_id"]}];
    NSString * url   = [G formatRestful:API_ORGANIZATION_PHOTOS Params:params];
    
    [self startActionLoading:@"正在打开相册..."];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        
        if(array.count > 0){
            
            OrganizationPhotoImageViewController *photoVC = [[OrganizationPhotoImageViewController alloc] init];
            photoVC.imageType = 1;
            photoVC.imageArr  = array;
            photoVC.imageIdx  = 0;
            
            photoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:photoVC animated:YES completion:nil];
            
        }else{
            
            SHOW_HINT(@"该相册中暂无图片");
            
        }
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
}
@end
