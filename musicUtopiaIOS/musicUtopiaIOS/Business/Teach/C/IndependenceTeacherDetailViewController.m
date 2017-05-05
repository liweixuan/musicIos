//
//  IndependenceTeacherDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IndependenceTeacherDetailViewController.h"
#import "IndependenceTeacherDetailCell.h"
#import "IndependenceTeacherStageViewController.h"

@interface IndependenceTeacherDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
}
@end

@implementation IndependenceTeacherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教师课程";
    
    //创建导航右侧按钮
    [self createNav];
    
    //创建列表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];

}

//创建导航右侧按钮
-(void)createNav {
    
    R_NAV_TITLE_BTN(@"R",@"线下约课",OfflineClick);
    
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
}

-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,140));
    }];
    
    //卡片容器
    UIView * cardView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,D_WIDTH - CARD_MARGIN_LEFT * 2,85))
        .L_BgColor([UIColor whiteColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //教师头像
    UIImageView * headerImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,60,60))
        .L_ImageName(HEADER_DEFAULT)
        .L_AddView(cardView);
    }];
    
    //老师名
    UILabel * teacherLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([headerImage right]+CONTENT_PADDING_LEFT, [headerImage top],200,TITLE_FONT_SIZE))
        .L_Text(@"李梵羽")
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_Font(TITLE_FONT_SIZE)
        .L_AddView(cardView);
    }];
    
    //性别图标
    UIImageView * sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([teacherLabel left],[teacherLabel bottom]+8,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(cardView);
    }];
    
    //性别名
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([sexIcon right]+ICON_MARGIN_CONTENT, [sexIcon top],50,ATTR_FONT_SIZE))
        .L_Text(@"李梵羽")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Font(ATTR_FONT_SIZE)
        .L_AddView(cardView);
    }];
    
    //所在省市区
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([sexIcon left], [sexIcon bottom]+8,200,ATTR_FONT_SIZE))
        .L_Text(@"甘肃省-天水市-麦积区")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Font(ATTR_FONT_SIZE)
        .L_AddView(cardView);
    }];
    
    //课程图标
    UIImageView * classIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([cardView left],[cardView bottom]+30,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(headerView);
    }];
    
    //课程标题
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([classIcon right]+ICON_MARGIN_CONTENT,[classIcon top],200,CONTENT_FONT_SIZE))
        .L_Text(@"课程列表")
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_AddView(headerView);
    }];
    
    _tableview.tableHeaderView = headerView;
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IndependenceTeacherDetailCell * cell = [[IndependenceTeacherDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    NSDictionary * dictData = @{};
    
    cell.dictData = dictData;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 320;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PUSH_VC(IndependenceTeacherStageViewController,YES,@{});
}

#pragma mark - 事件

//线下约课
-(void)OfflineClick {
    NSLog(@"线下约课...");
}

@end
