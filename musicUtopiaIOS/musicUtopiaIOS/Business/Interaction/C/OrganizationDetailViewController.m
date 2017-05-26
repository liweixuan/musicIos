#import "OrganizationDetailViewController.h"
#import "CardCell.h"
#import "HorizontalScrollPhotoView.h"
#import "OrganizationUserViewController.h"

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
    
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(collectClick))
        .L_ImageName(ICON_DEFAULT);
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,INLINE_CELL_PADDING_TOP,50,50))
            .L_ImageUrlName(logoUrl,IMAGE_DEFAULT)
            .L_radius(25)
            .L_AddView(cell.contentView);
        }];
        
        //标题
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([logoImageView right] + INLINE_CELL_ICON_LEFT,[logoImageView top], [cell.contentView width], 50))
            .L_Text(_organizationDetail[@"o_name"])
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        NSString * coverUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_cover"]];
        
        //封面图
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT, [logoImageView bottom] + CONTENT_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2, 230))
            .L_ImageUrlName(coverUrl,RECTANGLE_IMAGE_DEFAULT)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
    //所在地点
    }else if(indexPath.row == 1){

        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-MIDDLE_ICON_SIZE/2,NORMAL_CELL_HIEGHT/2 - MIDDLE_ICON_SIZE /2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(cell.contentView);
        }];
    
    //团体类型
    }else if(indexPath.row == 3){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
            .L_ImageName(ICON_DEFAULT)
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
        UIView * imageBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,[icon bottom]+INLINE_CELL_PADDING_TOP, D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2, 120))
            .L_BgColor([UIColor orangeColor])
            .L_AddView(cell.contentView);
        }];
        
        UIView * photoView = (UIView *)[HorizontalScrollPhotoView createHorizontalScrollPhotoView:_organizationPhoto ViewSize:CGSizeMake([imageBoxView width], [imageBoxView height])];
        [imageBoxView addSubview:photoView];
        
     
    }
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return 325;
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
        
    }

    return NORMAL_CELL_HIEGHT;
}


//点击代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //查看成员
    if(indexPath.row == 2){
        PUSH_VC(OrganizationUserViewController, YES, @{@"organizationId":@(self.organizationId)});
    }
    
}

#pragma mark - 事件部分
-(void)collectClick {
    NSLog(@"收藏按钮点击...");
}

@end
