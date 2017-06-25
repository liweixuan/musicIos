//
//  MyOrganizationView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyOrganizationView.h"
#import "MyOrganizationCell.h"
#import "LoadingView.h"
#import "OrganizationChatViewController.h"

@interface MyOrganizationView()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation MyOrganizationView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建表视图
        [self createTableView];
        
        _loadView = [LoadingView createDataLoadingView];
        [self addSubview:_loadView];
        
        
    }
    return self;
}

-(void)getData:(NSDictionary *)params Type:(NSString *)type {
    
    //获取当前用户的ID
    NSString * username = [UserData getUsername];
    
    //获取好友列表
    NSArray  * cParams = @[@{@"key":@"u_username",@"value":username}];
    NSString * url     = [G formatRestful:API_USER_ORGANIZATION_SEARCH Params:cParams];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        REMOVE_LOADVIEW
        
        _tableData = array;
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)initVar {
    _tableData = [NSArray array];
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
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrganizationCell * cell = [[MyOrganizationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    
    OrganizationChatViewController * organizationChatVC = [[OrganizationChatViewController alloc] init];
    organizationChatVC.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:organizationChatVC animated:YES];
    
    
}


- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
@end
