//
//  SettingViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "LoginViewController.h"
#import "CustomNavigationController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 5;
    }
    return 0;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell * cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //判断相应列给予相应数据
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            NSDictionary * dict = @{@"icon":@"",@"text":@"修改密码",@"content":@"",@"isMust":@NO};
            cell.dictData       = dict;
            return cell;
            
        }else if(indexPath.row == 1){
            
            NSDictionary * dict = @{@"icon":@"",@"text":@"消息通知",@"content":@"静音",@"isMust":@NO};
            cell.dictData       = dict;
            return cell;
            
        }else if(indexPath.row == 2){
            
            NSDictionary * dict = @{@"icon":@"",@"text":@"清除缓存空间",@"content":@"",@"isMust":@NO};
            cell.dictData       = dict;
            return cell;
            
            
            
        }else if(indexPath.row == 3){
            
            NSDictionary * dict = @{@"icon":@"",@"text":@"帮助",@"content":@"",@"isMust":@NO};
            cell.dictData       = dict;
            return cell;
            
            
            
        }else if(indexPath.row == 4){
            
            NSDictionary * dict = @{@"icon":@"",@"text":@"退出当前帐号",@"content":@"",@"isMust":@NO};
            cell.dictData       = dict;
            return cell;
            
            
            
        }
        
    }
    return nil;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        
        if(indexPath.row == 1){
            
   
            //确认退出框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出提示" message:@"退出后您将无法收取到好友给您发送的消息，确定要这么做吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //退出当前账户
                [UserData removeUserInfo];
                
                //清除融云TOKEN
                [UserData removeRongCloudToken];
                
                //断开融云连接，并不在接收消息
                [[RCIMClient sharedRCIMClient] logout];
                
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                CustomNavigationController * customNav = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:customNav animated:YES completion:nil];
                
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    
}

@end


