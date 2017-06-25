//
//  SearchFriendViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "FriendCell.h"
#import "AppDelegate.h"
#import "UserDetailViewController.h"

@interface SearchFriendViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
    UITextField      * _searchField;
}
@end

@implementation SearchFriendViewController

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
        .L_Placeholder(@"请输入好友的昵称")
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
    
    FriendCell * cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = _tableData[indexPath.row];
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dictData = _tableData[indexPath.row];
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dictData[@"u_id"] integerValue];
    userDetailVC.username = dictData[@"u_username"];
    userDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDetailVC animated:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    //获取要搜索的词
    NSString * searchStr = textField.text;
    
    if([searchStr isEqualToString:@""]){
        SHOW_HINT(@"搜索条件不能为空");
        return YES;
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"搜索词:%@",searchStr]);
    
    [self startActionLoading:@"正在查询好友..."];
    NSArray * array = @[@{@"key":@"f_username",@"value":[UserData getUsername]},@{@"key":@"u_nickname",@"value":searchStr}];
    NSString * url  = [G formatRestful:API_FRIENDS_SEARCH Params:array];
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        _tableData = array;
        
        if(_tableData.count<=0){
            SHOW_HINT(@"未查询到满足条件的好友");
        }
        
        [_tableview reloadData];
        
    }errorBlock:^(NSString *error) {
        [self endActionLoading];
        NSLog(@"%@", error);
    }];
    
    
    
    return YES;
}


@end
