//
//  OfficialStageNodeViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OfficialStageNodeViewController.h"
#import "OfficialStageNodeCell.h"
#import "OfficialNoteDetailViewController.h"
#import "UpgradeTestViewController.h"

@interface OfficialStageNodeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation OfficialStageNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"古典吉他/一阶段";
    
    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];
    
    //创建底部视图
    [self createFooterTableview];
    
}

//创建表视图
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

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,50));
    }];
    
    //创建左侧图标
    UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT+3,0,25,50))
        .L_BgColor([UIColor lightGrayColor])
        .L_AddView(headerView);
    }];
    
    //文字
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([leftIcon right]+ICON_MARGIN_CONTENT,0,200,CONTENT_FONT_SIZE))
        .L_Text(@"Let's Go 开启你的学习之旅")
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(headerView);
    }];
    
    
    
    _tableview.tableHeaderView = headerView;
    
    
    
}

//创建底部视图
-(void)createFooterTableview {
    
    UIView * footerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH - CARD_MARGIN_LEFT*2,180));
    }];
    
    //乐器图标
    UIImageView * musicImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,20,70,70))
        .L_ImageName(@"jita")
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(footerView);
    }];
    
    //描述
    UILabel * descLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0, [musicImage bottom]+CONTENT_PADDING_TOP, D_WIDTH,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"评测古典吉他一阶段称号")
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(footerView);
    }];
    
    //升阶考试按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT, [descLabel bottom]+CONTENT_PADDING_TOP, D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Title(@"升阶考试",UIControlStateNormal)
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_TargetAction(self,@selector(upgradeTestClick),UIControlEventTouchUpInside)
        .L_radius_NO_masksToBounds(20)
        .L_shadowOpacity(0.2)
        .L_shadowOffset(CGSizeMake(5,5))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowRadius(5)
        .L_AddView(footerView);
        
    } buttonType:UIButtonTypeCustom];
    
    
    _tableview.tableFooterView = footerView;
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfficialStageNodeCell * cell = [[OfficialStageNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    PUSH_VC(OfficialNoteDetailViewController,YES, @{});
}

//升阶考试按钮
-(void)upgradeTestClick {
    PUSH_VC(UpgradeTestViewController,YES,@{});
}

@end
