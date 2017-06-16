#import "AddUpgradeInstrumentViewController.h"
#import "AddUpgradeInstrumentCell.h"
#import "InstrumentEvaluationViewController.h"

@interface AddUpgradeInstrumentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    NSMutableArray   * _tableData;
}
@end

@implementation AddUpgradeInstrumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增评测乐器";
    
    [self initVar];
    
    //创建表视图
    [self createTableview];
    
    [self initData];
    
    NSLog(@"####%@",self.alreadyCategoryArr);
}


-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {
    
    NSMutableArray * tempArr     = [[LocalData getStandardMusicCategory] mutableCopy];
    NSMutableArray * resultArr   = [tempArr mutableCopy];

    //去除已经存在的类别
    for(int i = 0;i<tempArr.count;i++){
        
        NSInteger cid = [tempArr[i][@"c_id"] integerValue];

        for(int k = 0;k<self.alreadyCategoryArr.count;k++){
            
            NSInteger alreadyCid = [self.alreadyCategoryArr[k][@"ul_cid"] integerValue];

            if(cid == alreadyCid){
                [resultArr removeObject:tempArr[i]];
            }
        }
        
    }
    
    _tableData = resultArr;
    [_tableview reloadData];
    
}

-(void)createTableview {
    
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
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddUpgradeInstrumentCell  * cell = [[AddUpgradeInstrumentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;

    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    NSInteger cid           = [dictData[@"c_id"] integerValue];
    NSInteger level         = 0;
    
    InstrumentEvaluationViewController * instrumentEvalutaionVC = [[InstrumentEvaluationViewController alloc] init];
    instrumentEvalutaionVC.cid   = cid;
    instrumentEvalutaionVC.level = level;
    [self.navigationController pushViewController:instrumentEvalutaionVC animated:YES];
    
}
@end
