//
//  MyDynamicViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyDynamicViewController.h"
#import "DynamicView.h"
#import "InteractionCommentViewController.h"

@interface MyDynamicViewController ()<DynamicViewDelegate>
{
    DynamicView  * _dynamicView;
}
@end

@implementation MyDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的动态";

    
    //创建视图
    [self createView];
 
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self createView];
}


-(void)createView {
    
    //创建互动视图
    _dynamicView = [[DynamicView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT_NO_NAV)];
    _dynamicView.isDeleteBtn = YES;
    _dynamicView.delegate    = self;
    [self.view addSubview:_dynamicView];
    
    //获取动态数据
    
    NSInteger userid = 0;
    if(self.userid == 0){
        userid = [UserData getUserId];
    }else{
        userid = self.userid;
    }
    
    _dynamicView.paramsDict = @{@"key":@"d_uid",@"value":@(userid)};
    [_dynamicView getData:nil Type:@"init"];
   
}



#pragma mark - 相关代理

//动态评论按钮点击时
-(void)dynamicCommentClick:(DynamicFrame *)dynamicFrame {
    
    InteractionCommentViewController * interactionCommentVC = [[InteractionCommentViewController alloc] init];
    interactionCommentVC.dynamicFrame = dynamicFrame;
    interactionCommentVC.isDeleteBtn  = YES;
    interactionCommentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:interactionCommentVC animated:YES];
}

//动态点赞按钮点击时
-(void)dynamicZanClick:(NSInteger)dynamicId NowView:(UILabel *)label NowZanCount:(NSInteger)zanCount{
 
    
}

//动态头像点击时
-(void)publicUserHeaderClick:(NSInteger)userId UserName:(NSString *)username {
    
    
}

//动态关注点击时
-(void)dynamicConcernClick:(NSInteger)userId {
    
    
    
}

//删除动态
-(void)deleteDynamic:(NSInteger)dynamicId{

    //确定删除
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认操作" message:@"确定要删除该条动态吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary * parmas = @{@"d_id":@(dynamicId)};
        [self startActionLoading:@"正在删除动态..."];
        [NetWorkTools POST:API_DYNAMIC_DELETE params:parmas successBlock:^(NSArray *array) {
            [self endActionLoading];
            SHOW_HINT(@"动态删除成功");
            
            [_dynamicView reloadData];
            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(error);
        }];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
 
}
@end
