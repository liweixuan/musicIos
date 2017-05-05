#import "OfficialView.h"
#import "LoadingView.h"
#import "OfficialCell.h"

@interface OfficialView()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
    NSArray          * _officialDesc;
}
@end

@implementation OfficialView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        //创建加载中遮罩
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
        
        
    }
    return self;
}

-(void)initVar {
    _tableData    = [NSArray array];
    _officialDesc = @[
                        @"官方课程会统一使用官方大纲进行录制",
                        @"官方课程中所有一阶段课程免费",
                        @"一阶段以上需要进行购买观看",
                        @"官方课程会持续更新，购买一次即可"
                      
    ];
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
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    
    _tableview.marginBottom = 10;


    //创建表视图头视图
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
       
        view
        .L_Frame(CGRectMake(0,0,[_tableview width],170));
        
    }];
    
    //卡片容器
    UIView * headerBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN+10,D_WIDTH - CARD_MARGIN_LEFT * 2,[headerView height]  - INLINE_CARD_MARGIN*2 - 20))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //标题图标+标题
    UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(headerBox);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([icon right] + CONTENT_PADDING_LEFT,[icon top],100,ATTR_FONT_SIZE))
        .L_Text(@"说明")
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Font(ATTR_FONT_SIZE)
        .L_AddView(headerBox);
    }];
    
    //数据
   
        CGFloat askItemY = [icon bottom] + CONTENT_PADDING_TOP;
        
        //条件内容
        for(int i =0;i<_officialDesc.count;i++){
            
            UILabel * indexLabel = [UILabel LabelinitWith:^(UILabel *la) {
                la
                .L_Frame(CGRectMake([icon left] - 2,askItemY,16,16))
                .L_Text([NSString stringWithFormat:@"%d",(i+1)])
                .L_BgColor(HEX_COLOR(BG_GARY))
                .L_Font(12)
                .L_textAlignment(NSTextAlignmentCenter)
                .L_TextColor(HEX_COLOR(@"#FFFFFF"))
                .L_radius(8)
                .L_AddView(headerBox);
            }];
            
            
            UILabel * label = [UILabel LabelinitWith:^(UILabel *la) {
                
                la
                .L_Frame(CGRectMake([indexLabel right]+ICON_MARGIN_CONTENT, [indexLabel top]+1, [headerBox width],16))
                .L_Text(_officialDesc[i])
                .L_Font(CONTENT_FONT_SIZE)
                .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                .L_AddView(headerBox);
                
            }];
            
            askItemY = [label bottom] + 10;
            
        }

    
    _tableview.tableHeaderView = headerView;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfficialCell * cell = [[OfficialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    NSInteger cid           = [dictData[@"c_id"] integerValue];
    NSString * cname        = dictData[@"c_name"];
    
    //传递参数
    NSDictionary * paramsDict = @{@"cid":@(cid),@"cname":cname};
    
    [self.delegate officialCategoryClick:paramsDict];
    
    
}

-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    NSLog(@"请求官方课程乐器分类列表数据...");
    
    //构建restful参数
    NSArray  * getParams = @[@{@"key":@"c_is_courses",@"value":@(1)}];
    NSString * URL    = [G formatRestful:API_OFFICIAL_CATEGORY Params:getParams];
    
    //请求动态数据
    [NetWorkTools GET:URL params:nil successBlock:^(NSArray *array) {

        //更新数据数据
        _tableData = array;

        //更新表视图
        [_tableview reloadData];
        
        //删除加载动画
        REMOVE_LOADVIEW
        
        
    } errorBlock:^(NSString *error) {
        
        //向控制器发送错误
        
        
    }];
    
}


@end
