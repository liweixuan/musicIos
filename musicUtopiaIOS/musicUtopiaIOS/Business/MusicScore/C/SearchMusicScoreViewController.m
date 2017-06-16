//
//  SearchMusicScoreViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SearchMusicScoreViewController.h"
#import "MusicScoreItemCell.h"
#import "MusicScoreDetailViewController.h"
#import "AppDelegate.h"

@interface SearchMusicScoreViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
    UITextField      * _searchField;
}
@end

@implementation SearchMusicScoreViewController

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"######%ld",(long)self.musicScoreCategoryID);
    
    //初始化变量
    [self initVar];
    
    //创建搜索视图
    [self createSearchView];
    
    //创建列表视图
    [self createTableview];
    
    [_searchField becomeFirstResponder];
    
    
    
}


//初始化变量
-(void)initVar {
    _tableData = [NSArray array];
}


//创建搜索视图
-(void)createSearchView {
    
    //创建顶部菜单容器
    UIView * topView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,64))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_AddView(self.view);
    }];
    
    //搜索框
    _searchField = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(5,20 + (44/2 - 32/2),D_WIDTH-5*2 - 40,32))
        .L_PaddingLeft(10)
        .L_Placeholder(@"请输入曲谱名称")
        .L_ReturnKey(UIReturnKeySearch)
        .L_BgColor([UIColor whiteColor])
        .L_ClearButtonMode(UITextFieldViewModeWhileEditing)
        .L_Font(12)
        .L_radius_NO_masksToBounds(5)
        .L_borderWidth(1)
        .L_borderColor(HEX_COLOR(@"#eeeeee"))
        .L_AddView(topView);
    }];
    _searchField.delegate = self;
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(D_WIDTH - 40,[_searchField top],40,[_searchField height]))
        .L_Title(@"取消",UIControlStateNormal)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_TargetAction(self,@selector(cancelBtnClick),UIControlEventTouchUpInside)
        .L_AddView(topView);
    } buttonType:UIButtonTypeCustom];
    
}

//创建列表视图
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(74,0,0,0));
    }];
    
    
    _tableview.marginBottom = 10;
    
    
    
}

#pragma mark - 事件
-(void)cancelBtnClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicScoreItemCell * cell = [[MusicScoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    //更新热度
    [NetWorkTools POST:API_ADD_MUSIC_SCORE_HOT params:@{@"ms_id":dictData[@"ms_id"]} successBlock:^(NSArray *array) {
        NSLog(@"热度更新成功");
    } errorBlock:^(NSString *error) {
        NSLog(@"热度更新失败");
    }];
    
    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    musicScoreDetailVC.musicScoreName = dictData[@"ms_name"];
    musicScoreDetailVC.imageCount     = [dictData[@"mu_page"] integerValue];
    musicScoreDetailVC.musicScoreId   = [dictData[@"ms_id"] integerValue];
    musicScoreDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];

    //获取要搜索的词
    NSString * searchStr = textField.text;
    
    if([searchStr isEqualToString:@""]){
        SHOW_HINT(@"搜索条件不能为空");
        return YES;
    }
    
    NSArray * params = @[
          @{@"key":@"ms_mscid",@"value":@(self.musicScoreCategoryID)},
          @{@"key":@"ms_name",@"value":searchStr}
    ];
    NSString * url = [G formatRestful:API_MUSIC_SCORE_SEARCH Params:params];
    
    [self startActionLoading:@"正在搜索..."];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        _tableData = array;
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
    
    
    return YES;
}

@end
