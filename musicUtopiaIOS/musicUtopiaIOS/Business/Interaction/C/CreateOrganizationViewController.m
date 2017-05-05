#import "CreateOrganizationViewController.h"
#import "CardCell.h"

@interface CreateOrganizationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation CreateOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建团体";
    
    //创建导航按钮
    [self createNavigationRightBtn];
    
    //创建表视图
    [self createTableview];

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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
}

-(void)createNavigationRightBtn {
    
    R_NAV_TITLE_BTN(@"R",@"提交",createOrganizationClick)
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //cell的宽度
    CGFloat cellW = D_WIDTH - CARD_MARGIN_LEFT * 2;
    
    //封面
    if(indexPath.row == 0){
        
        UIImageView *coverView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT * 2,238))
            .L_ImageName(RECTANGLE_IMAGE_DEFAULT)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        //更改按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake(D_WIDTH/2 - 80/2,[coverView height] - 80, 90,27))
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Title(@"更改封面",UIControlStateNormal)
            .L_Font(CONTENT_FONT_SIZE)
            .L_radius(5)
            .L_Alpha(0.5)
            .L_AddView(cell.contentView);
        } buttonType:UIButtonTypeCustom];
        
    //LOGO
    }else if(indexPath.row == 1){
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,80/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(cell.contentView);
        }];
        
        UILabel * mustHint =  [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right]+ICON_MARGIN_CONTENT,80/2 - 15/2 + 2,10,15))
            .L_TextColor([UIColor redColor])
            .L_Text(@"*")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([mustHint right] + ICON_MARGIN_CONTENT,0, [cell.contentView width], 80))
            .L_Text(@"团体LOGO")
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //预览lOGO
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - CONTENT_PADDING_LEFT - CARD_MARGIN_LEFT - CONTENT_PADDING_LEFT - 50, 15,50,50))
            .L_ImageName(IMAGE_DEFAULT)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - CONTENT_PADDING_LEFT - CARD_MARGIN_LEFT, 80/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(cell.contentView);
        }];

        
    }else if(indexPath.row == 2){
        
        cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"团体名称",@"content":@"内容测试"};

    }else if(indexPath.row == 3){
        
        cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"所在地区",@"content":@"甘肃省-天水市-麦积区"};
        
    }else if(indexPath.row == 4){
        
        cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"详细地址",@"content":@"明珠大厦21层2011"};
        
    }else if(indexPath.row == 5){
        
         cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"团体类型",@"content":@"点击设置"};
        
    }else if(indexPath.row == 6){
        
         cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"团体标语",@"content":@"点击设置"};
        
    }else if(indexPath.row == 7){
        
         cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"描述信息",@"content":@"点击设置"};
        
    }else if(indexPath.row == 8){
        
         cell.dictData = @{@"icon":ICON_DEFAULT,@"text":@"申请要求",@"content":@"点击设置"};
        
    }else{
        
        [UIView ViewInitWith:^(UIView *view) {
           view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT * 2,200))
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        UIImageView * addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,200/2 - 60/2 - 20, 60, 60))
            .L_ImageName(IMAGE_DEFAULT)
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(D_WIDTH/2 - 100/2,[addVideoIcon bottom]+CONTENT_PADDING_TOP,100,TITLE_FONT_SIZE))
            .L_Font(TITLE_FONT_SIZE)
            .L_Text(@"团体宣传视频")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
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
        return 240;
    }else if(indexPath.row == 1){
        return 80;
    }else if(indexPath.row == 9){
        return 200;
    }

    return NORMAL_CELL_HIEGHT;
}

#pragma mark - 创建团体操作
-(void)createOrganizationClick {
    
}

@end
