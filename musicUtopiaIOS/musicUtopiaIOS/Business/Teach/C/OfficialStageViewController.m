#import "OfficialStageViewController.h"
#import "OfficialStageCell.h"
#import "OfficialStageNodeViewController.h"
#import "MusicInstrumentBuyViewController.h"

@interface OfficialStageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation OfficialStageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cName;
    
    //创建右侧导航按钮
    [self createNavBtn];
    
    //创建列表视图
    [self createTableview];
}

//创建右侧导航按钮
-(void)createNavBtn {
    
    
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(buyClick))
        .L_ImageName(ICON_DEFAULT);
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

//创建列表视图
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfficialStageCell * cell = [[OfficialStageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = @{};
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PUSH_VC(OfficialStageNodeViewController, YES, @{@"iln_ilid":@1});
}

#pragma mark - 事件处理
-(void)buyClick {
    NSLog(@"购买...");
    PUSH_VC(MusicInstrumentBuyViewController, YES, @{});
}

@end
