//
//  FindFriendViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FindFriendViewController.h"
#import "CardCell.h"
#import "ConditionFilterViewController.h"
#import "LookAroundViewController.h"
#import "MapFindViewController.h"
#import "RandomViewController.h"
#import "ListenFriendViewController.h"

@interface FindFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    Base_UITableView * _tableview;
    NSArray          * _tableData;
}
@end

@implementation FindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现朋友";
    
    //创建变量
    [self initVar];
    
    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderView];
}

//创建变量
-(void)initVar {
    
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
-(void)createHeaderView {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,110));
    }];
    
    //创建卡片容器
    UIView * headerBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,D_WIDTH - CARD_MARGIN_LEFT * 2,[headerView height]  - INLINE_CARD_MARGIN*2))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(headerView);
    }];
    
    //创建提示图片
    UIImageView * hintImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,10,120,[headerBox height] - 20))
        .L_ImageName(@"test_faxian.jpeg")
        .L_radius(5)
        .L_AddView(headerBox);
    }];
    
    //提示标题
    UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([hintImageView right]+CONTENT_PADDING_LEFT,[hintImageView top]+10,100,SUBTITLE_FONT_SIZE))
        .L_Text(@"快来！")
        .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_AddView(headerBox);
    }];
    
    //提示内容
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([hintImageView right]+CONTENT_PADDING_LEFT,[hintTitle top]+20,[headerBox width] - [hintImageView right] - CONTENT_PADDING_LEFT,CONTENT_FONT_SIZE))
        .L_Text(@"发现与您志同道合的好友...")
        .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
        .L_Font(CONTENT_FONT_SIZE)
        .L_AddView(headerBox);
    }];
    
    
    _tableview.tableHeaderView = headerView;
    
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if(indexPath.row == 0){
        
        UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT+2,70/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(@"tiaojianshaixuan")
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[leftIcon top]-5,100,SUBTITLE_FONT_SIZE))
            .L_Text(@"条件筛选")
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //描述
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[hintTitle bottom]+5,[cell.contentView width] - [leftIcon right] - CONTENT_PADDING_LEFT,ATTR_FONT_SIZE))
            .L_Text(@"根据不同条件筛选更精确哟")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,70/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
        
    }else if(indexPath.row == 1){
        
        UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT+2,70/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(@"fujinderen")
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[leftIcon top]-5,100,SUBTITLE_FONT_SIZE))
            .L_Text(@"附近的人")
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //描述
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[hintTitle bottom]+5,[cell.contentView width] - [leftIcon right] - CONTENT_PADDING_LEFT,ATTR_FONT_SIZE))
            .L_Text(@"看看附近有谁")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,70/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

        
    }else if(indexPath.row == 2){
        
        UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT+2,70/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(@"ditufaxian")
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[leftIcon top]-5,100,SUBTITLE_FONT_SIZE))
            .L_Text(@"地图发现")
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //描述
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[hintTitle bottom]+5,[cell.contentView width] - [leftIcon right] - CONTENT_PADDING_LEFT,ATTR_FONT_SIZE))
            .L_Text(@"用地图发现您身边的人")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,70/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

        
    }else if(indexPath.row == 3){
        
        UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT+2,70/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(@"suijifaxian")
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[leftIcon top]-5,100,SUBTITLE_FONT_SIZE))
            .L_Text(@"随机抽选")
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //描述
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[hintTitle bottom]+5,[cell.contentView width] - [leftIcon right] - CONTENT_PADDING_LEFT,ATTR_FONT_SIZE))
            .L_Text(@"来一场随机交友之旅")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,70/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

        
    }else if(indexPath.row == 4){
        
        UIImageView * leftIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT+2,70/2 - MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
            .L_ImageName(@"tingpengyou")
            .L_AddView(cell.contentView);
        }];
        
        //标题
        UILabel * hintTitle = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[leftIcon top]-5,100,SUBTITLE_FONT_SIZE))
            .L_Text(@"视频交友")
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //描述
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([leftIcon right]+CONTENT_PADDING_LEFT,[hintTitle bottom]+5,[cell.contentView width] - [leftIcon right] - CONTENT_PADDING_LEFT,ATTR_FONT_SIZE))
            .L_Text(@"看看他/她提供的交友视频")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,70/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

        
    }
    
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        
        PUSH_VC(ConditionFilterViewController,YES,@{});
        
        
    }else if(indexPath.row == 1){
        
        PUSH_VC(LookAroundViewController,YES,@{});
        
    }else if(indexPath.row == 2){
        
        PUSH_VC(MapFindViewController,YES,@{});
        
    }else if(indexPath.row == 3){
        
        PUSH_VC(RandomViewController,YES,@{});
    
    }else{
        
        PUSH_VC(ListenFriendViewController,YES,@{});
        
    }
    
    
    
}

@end
