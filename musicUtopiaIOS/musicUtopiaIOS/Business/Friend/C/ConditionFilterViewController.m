#import "ConditionFilterViewController.h"
#import "CardCell.h"
#import "SelectAddressView.h"
#import "SelectSexView.h"
#import "SelectInstrumentLevelView.h"
#import "ConditionFilterResultViewController.h"

@interface ConditionFilterViewController ()<UITableViewDelegate,UITableViewDataSource,SelectAddressDelegate,SelectSexDelegate,SelectInstrumentLevelDelegate>
{
    Base_UITableView  * _tableview;
    NSArray           * _tableData;
    SelectAddressView * _selectAddressView;
    SelectSexView     * _selectSexView;
    SelectInstrumentLevelView * _selectInstrumentLevelView;
    NSMutableArray    * _conditionFilterArr;  //查询条件数据源
    NSDictionary      * _locationData;
    NSDictionary      * _sexData;
    NSDictionary      * _instrumentLevelData;
}
@end

@implementation ConditionFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"条件筛选";
    
    [self initVar];
    
    //创建导航按钮
    [self createNavigationRightBtn];
    
    //创建列表视图
    [self createTableview];
    
    //创建地址选择视图
    [self createSelectAddressView];
    
    //创建性别选择视图
    [self createSelectSexView];
    
    //创建乐器+级别选择视图
    [self createSelectInstrumentLevelView];
    
}

-(void)initVar {
    _conditionFilterArr = [NSMutableArray array];
    
    [_conditionFilterArr addObject:@{@"icon":@"sex_baomi",@"text":@"性别",@"content":@"点击选择",@"isMust":@NO}];
    [_conditionFilterArr addObject:@{@"icon":@"yueqiyujibie",@"text":@"乐器与级别",@"content":@"点击选择",@"isMust":@NO}];
    [_conditionFilterArr addObject:@{@"icon":@"weizhi",@"text":@"位置",@"content":@"点击选择",@"isMust":@NO}];
    
    _locationData        = [NSDictionary dictionary];
    _sexData             = [NSDictionary dictionary];
    _instrumentLevelData = [NSDictionary dictionary];
}

-(void)createNavigationRightBtn {
    
    UIBarButtonItem * BarButtonItem_search = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleDone target:self action:@selector(searchFriendClick)];
    UIBarButtonItem * BarButtonItem_clear = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStyleDone target:self action:@selector(clearSearchClick)];
    BarButtonItem_search.tintColor = HEX_COLOR(APP_MAIN_COLOR);
    BarButtonItem_clear.tintColor = HEX_COLOR(APP_MAIN_COLOR);
    
    self.navigationItem.rightBarButtonItems = @[BarButtonItem_search,BarButtonItem_clear];
}

-(void)createSelectAddressView {
    _selectAddressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectAddressView.delegate = self;
    _selectAddressView.hidden = YES;
    [self.navigationController.view addSubview:_selectAddressView];
}

-(void)createSelectSexView {
    _selectSexView = [[SelectSexView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectSexView.hidden = YES;
    _selectSexView.delegate = self;
    [self.navigationController.view addSubview:_selectSexView];
}

-(void)createSelectInstrumentLevelView {
    _selectInstrumentLevelView = [[SelectInstrumentLevelView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectInstrumentLevelView.hidden = YES;
    _selectInstrumentLevelView.delegate = self;
    [self.navigationController.view addSubview:_selectInstrumentLevelView];
}

//省市区选择代理
-(void)selectLocation:(NSDictionary *)locationDict {
    
    _locationData = locationDict;
    
    NSString * locationStr = [NSString stringWithFormat:@"%@%@%@",locationDict[@"pName"],locationDict[@"cName"],locationDict[@"dName"]];
    
    //更改数据源
    NSMutableDictionary * newDict = [_conditionFilterArr[2] mutableCopy];
    [newDict setValue:locationStr forKey:@"content"];
    [_conditionFilterArr replaceObjectAtIndex:2 withObject:newDict];
    

    
    [_tableview reloadData];
    
    _selectAddressView.hidden = YES;
}

//性别选择代理
-(void)selectSex:(NSDictionary *)sexDict {
    _sexData = sexDict;
    
    NSLog(@"%@",_sexData[@"sexStr"]);
    
    //更改数据源
    NSMutableDictionary * newDict = [_conditionFilterArr[0] mutableCopy];
    [newDict setValue:_sexData[@"sexStr"] forKey:@"content"];
    [_conditionFilterArr replaceObjectAtIndex:0 withObject:newDict];
    
    [_tableview reloadData];
    
    _selectSexView.hidden = YES;
    
}

//选择乐器级别
-(void)selectInstrumentLevel:(NSDictionary *)instrumentLevelDict {
    
    _instrumentLevelData = instrumentLevelDict;

    NSString * levelValue = @"";
    if([_instrumentLevelData[@"level"] integerValue] == 0){
        levelValue = @"全部级别";
    }else{
        levelValue = [NSString stringWithFormat:@"%@级",_instrumentLevelData[@"level"]];
    }
    NSString * levelStr = [NSString stringWithFormat:@"%@-%@",_instrumentLevelData[@"instrumentStr"],levelValue];
    
    //更改数据源
    NSMutableDictionary * newDict = [_conditionFilterArr[1] mutableCopy];
    [newDict setValue:levelStr forKey:@"content"];
    [_conditionFilterArr replaceObjectAtIndex:1 withObject:newDict];
    
    [_tableview reloadData];
    
    _selectInstrumentLevelView.hidden = YES;
    
    
}

-(void)closeSelectInstrumentLevel {
    _selectInstrumentLevelView.hidden = YES;
}

-(void)closeSelectSex {
    _selectSexView.hidden = YES;
}

-(void)closeSelectLocation {
    _selectAddressView.hidden = YES;
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    _tableview.marginBottom = 10;

    
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conditionFilterArr.count;
}


//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _conditionFilterArr[indexPath.row];
    
    cell.dictData = dictData;

    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        NSLog(@"性别选择");
        
        _selectSexView.hidden = NO;
    }else if(indexPath.row == 1){
        NSLog(@"乐器与级别");
        _selectInstrumentLevelView.hidden = NO;
    }else{
        
        NSLog(@"选择省市区");
        _selectAddressView.hidden = NO;
        NSLog(@"位置");
    }
    
    
}

-(void)clearSearchClick {
    [self initVar];
    
    [_tableview reloadData];
}

-(void)searchFriendClick {

    NSMutableArray * params = [NSMutableArray array];
    
    //判断是否有选择性别
    if([_sexData count]>0){
        NSLog(@"选了性别");
        NSInteger sexValue = [_sexData[@"sex"] integerValue];
        [params addObject:@{@"key":@"u_sex",@"value":@(sexValue)}];
    }
    
    //判断是否选择了乐器与级别
    if([_instrumentLevelData count]>0){
        NSLog(@"选了乐器与级别");
        NSInteger cid   = [_instrumentLevelData[@"instrument"] integerValue];
        NSInteger level = [_instrumentLevelData[@"level"] integerValue];
        [params addObject:@{@"key":@"ul_cid",@"value":@(cid)}];
        
        if(level > 0){
            [params addObject:@{@"key":@"ul_level",@"value":@(level)}];
        }
    }
    
    //是否选择了地区
    if([_locationData count]>0){
        
        if([_locationData[@"pid"] integerValue] > 0){
             [params addObject:@{@"key":@"u_province",@"value":_locationData[@"pid"]}];
        }
        
        if([_locationData[@"cid"] integerValue] > 0){
             [params addObject:@{@"key":@"u_city",@"value":_locationData[@"cid"]}];
        }
        
        if([_locationData[@"did"] integerValue] > 0){
            [params addObject:@{@"key":@"u_district",@"value":_locationData[@"did"]}];
        }
    }
    
    PUSH_VC(ConditionFilterResultViewController,YES, @{@"filterParams":params});
    

    
    
    
    

    
}
@end
