//
//  CreatePartnerViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CreatePartnerViewController.h"
#import "CardCell.h"
#import "SelectAddressView.h"
#import "InputTextFieldViewController.h"
#import "CreateTagViewController.h"
#import "CreateAskViewController.h"

@interface CreatePartnerViewController ()<UITableViewDelegate,UITableViewDataSource,SelectAddressDelegate>
{
    Base_UITableView  * _tableview;
    NSArray           * _tableData;
    SelectAddressView * _selectAddressView;
    NSMutableArray    * _partnerArr;  //找朋友数据源
    NSDictionary      * _locationData;
    NSString          * _tagStr;            //当前的标签数据
}
@end

@implementation CreatePartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建找伙伴";
    
    [self initVar];
    
    //创建导航按钮
    [self createNavigationRightBtn];
    
    //创建表视图
    [self createTableview];
    
    //创建地址选择视图
    [self createSelectAddressView];
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputResult:) name:@"INPUT_RESULT_VALUE" object:nil];
    
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedTags:) name:@"CreatePartnerVC" object:nil];
}

-(void)initVar {
    
    _partnerArr = [NSMutableArray array];
    
    //初始化数据
    [_partnerArr addObject:@{@"icon":@"o_leixing",@"text":@"标题名称",@"content":@"点击设置",@"isMust":@YES}];
    [_partnerArr addObject:@{@"icon":@"o_mingcheng",@"text":@"添加标签",@"content":@"点击设置",@"isMust":@YES}];
    [_partnerArr addObject:@{@"icon":@"o_diqu",@"text":@"省市区",@"content":@"点击设置",@"isMust":@YES}];
    [_partnerArr addObject:@{@"icon":@"location_icon",@"text":@"详细位置",@"content":@"点击设置",@"isMust":@YES}];
    [_partnerArr addObject:@{@"icon":@"o_miaoshu",@"text":@"描述信息",@"content":@"点击设置",@"isMust":@YES}];
    [_partnerArr addObject:@{@"icon":@"o_logo",@"text":@"伙伴要求",@"content":@"点击设置",@"isMust":@YES}];
}

-(void)createNavigationRightBtn {
    R_NAV_TITLE_BTN(@"R",@"提交",createPartnerClick);
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(12,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _partnerArr.count;
}


//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.dictData = _partnerArr[indexPath.row];
        
       //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NORMAL_CELL_HIEGHT;
}


//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InputTextFieldViewController * inputTextFieldVC = [[InputTextFieldViewController alloc] init];
    
    if(indexPath.row == 0){
        
        inputTextFieldVC.VCTitle  = @"标题名称";
        inputTextFieldVC.inputTag = 0;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 1){
        
        PUSH_VC(CreateTagViewController, YES, @{@"TAG_NAME":@"CreatePartnerVC"});

        
    }else if(indexPath.row == 2){
        
        NSLog(@"选择省市区");
        _selectAddressView.hidden = NO;
        
    }else if(indexPath.row == 3){
        
        inputTextFieldVC.VCTitle  = @"详细地址";
        inputTextFieldVC.inputTag = 3;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
    
    }else if(indexPath.row == 4){
        
        inputTextFieldVC.VCTitle  = @"描述信息";
        inputTextFieldVC.inputTag = 4;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 5){
        
        CreateAskViewController * createAskVC = [[CreateAskViewController alloc] init];
        createAskVC.VCTitle  = @"伙伴要求";
        createAskVC.inputTag = 5;
        [self.navigationController pushViewController:createAskVC animated:YES];
        
    }
}


-(void)createSelectAddressView {
    _selectAddressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectAddressView.delegate = self;
    _selectAddressView.hidden = YES;
    [self.navigationController.view addSubview:_selectAddressView];
}

//省市区选择代理
-(void)selectLocation:(NSDictionary *)locationDict {
    
    _locationData = locationDict;
    
    NSString * locationStr = [NSString stringWithFormat:@"%@%@%@",locationDict[@"pName"],locationDict[@"cName"],locationDict[@"dName"]];
    
    //更改数据源
    NSMutableDictionary * newDict = [_partnerArr[2] mutableCopy];
    [newDict setValue:locationStr forKey:@"content"];
    [_partnerArr replaceObjectAtIndex:2 withObject:newDict];
    [_tableview reloadData];
    
    _selectAddressView.hidden = YES;
}

-(void)closeSelectLocation {
    _selectAddressView.hidden = YES;
}


//数据录入反回通知
-(void)inputResult:(NSNotification *)noti {
 
    NSDictionary * dictData = noti.userInfo;
    
    //获取当条CELL
    NSInteger indexPathRow  = [dictData[@"inputTag"] integerValue];
    
    //团体名称
    if(indexPathRow == 0){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
        
    }else if(indexPathRow == 1){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
        
     
    }else if(indexPathRow == 2){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
        
    }else if(indexPathRow == 3){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
    
    }else if(indexPathRow == 4){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
        
    }else if(indexPathRow == 5){
        
        NSMutableDictionary * newDict = [_partnerArr[indexPathRow] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_partnerArr replaceObjectAtIndex:(indexPathRow) withObject:newDict];
        
    }
    
    //更新数据源
    [_tableview reloadData];
    
    
}

-(void)createPartnerClick {
    
    
    NSLog(@"%@",_locationData);
    
    //新增找朋友信息
 
    NSDictionary * dictData = @{
                                @"fp_title"    : _partnerArr[0][@"content"],
                                @"fp_tag"      : _partnerArr[1][@"content"],
                                @"fp_uid"      : @([UserData getUserId]),
                                @"fp_province" : _locationData[@"pid"],
                                @"fp_city"     : _locationData[@"cid"],
                                @"fp_district" : _locationData[@"did"],
                                @"fp_address"  : _partnerArr[3][@"content"],
                                @"fp_desc"     : _partnerArr[4][@"content"],
                                @"fp_ask"      : _partnerArr[5][@"content"],

    };
    

   [self startActionLoading:@"正在发布找朋友..."];
   [NetWorkTools POST:API_PARTNER_ADD params:dictData successBlock:^(NSArray *array) {
       [self endActionLoading];
       
       SHOW_HINT(@"找朋友信息发布成功");
       
       [self.navigationController popViewControllerAnimated:YES];
       
   } errorBlock:^(NSString *error) {
       [self endActionLoading];
       SHOW_HINT(error);
   }];
    
    
}

#pragma mark - 通知相关,获取标签数据
-(void)selectedTags:(NSNotification *)notification{
    _tagStr = notification.userInfo[@"tagStr"];
    NSMutableDictionary * newDict = [_partnerArr[1] mutableCopy];
    [newDict setValue:_tagStr forKey:@"content"];
    [_partnerArr replaceObjectAtIndex:1 withObject:newDict];
    [_tableview reloadData];
}
@end
