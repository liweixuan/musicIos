//
//  MusicScoreCategoryViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicScoreCategoryViewController.h"
#import "MusicScoreItemCell.h"
#import "MusicScoreDetailViewController.h"
#import "SearchMusicScoreViewController.h"
#import "MusicScoreFilterView.h"

@interface MusicScoreCategoryViewController()<UITableViewDelegate,UITableViewDataSource>
{
    Base_UITableView * _tableview;
    UIView           * _loadView;
    NSArray          * _tableData;
    UIView           * _fieldLeftView;
    UIView           * _popView;
    UIView           * _maskView;
    UIView           * _maskBoxView;             //遮罩总视图
    
    MusicScoreFilterView * _musicScoreFilterView;
}
@end

@interface MusicScoreCategoryViewController ()

@end

@implementation MusicScoreCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"民谣吉他";
    
    //初始化变量
    [self initVar];
    
    //初始化数据
    [self initData];
    
    //创建导航右侧图标
    [self createNav];
    
    //创建表视图
    [self createTableview];
    
    //创建头部视图
    [self createHeaderTableview];

    //创建遮罩视图
    [self createMaskView];
    
    //创建各个菜单筛选项视图
    [self createFilterView];

}

-(void)initVar {
    
}

-(void)initData {
    
    _tableData =  @[
                    @{@"hotCount":@"88",@"page":@"8",@"titleType":@"歌曲",@"name":@"当（还珠格格主题曲）"},
                    @{@"hotCount":@"44",@"page":@"1",@"titleType":@"歌曲",@"name":@"暧昧"},
                    @{@"hotCount":@"18",@"page":@"8",@"titleType":@"歌曲",@"name":@"老男孩"},
                    @{@"hotCount":@"2",@"page":@"12",@"titleType":@"指弹",@"name":@"天空之城"},
                    @{@"hotCount":@"1",@"page":@"60",@"titleType":@"歌曲",@"name":@"新白娘子传奇"},
                    @{@"hotCount":@"0",@"page":@"12",@"titleType":@"指弹",@"name":@"千与千寻主题曲"},
                    @{@"hotCount":@"120",@"page":@"15",@"titleType":@"歌曲",@"name":@"好汉歌"},
                    @{@"hotCount":@"20",@"page":@"8",@"titleType":@"歌曲",@"name":@"成都"}
                    
        ];
    
}

//创建各个菜单筛选项视图
-(void)createFilterView {
    
    _musicScoreFilterView = [[MusicScoreFilterView alloc] initWithFrame:CGRectMake(D_WIDTH,0,D_WIDTH-80,D_HEIGHT)];
    _musicScoreFilterView.backgroundColor = HEX_COLOR(VC_BG);
    [self.navigationController.view addSubview:_musicScoreFilterView];
    
    
}


//创建导航右侧图标
-(void)createNav {
    
    //展开按钮
    UIImageView * rightImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(filterClick))
        .L_ImageName(@"shaixuan");
    }];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
    
}

//创建全局遮罩视图
-(void)createMaskView {
    _maskBoxView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.navigationController.view);
    }];

    
}

//创建头部视图
-(void)createHeaderTableview {
    
    UIView * headerView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT*2,70));
    }];
    
    [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,15,[headerView width],TEXTFIELD_HEIGHT))
        .L_BgColor([UIColor whiteColor])
        .L_radius_NO_masksToBounds(20)
        .L_Click(self,@selector(searchMusciScore))
        .L_shadowOpacity(0.2)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_AddView(headerView);
    }];
    
    //默认占位视图
    _fieldLeftView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(D_WIDTH/2 - 150/2,15,150,TEXTFIELD_HEIGHT))
        .L_AddView(headerView);
    }];
    
    //占位标签
    UIImageView * searchIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(10,[_fieldLeftView height]/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(@"sousuo")
        .L_AddView(_fieldLeftView);
    }];
    
    //占位标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([searchIcon right]+CONTENT_PADDING_LEFT,0,150,[_fieldLeftView height]))
        .L_Text(@"根据曲谱名称搜索")
        .L_isEvent(YES)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Click(self,@selector(searchMusciScore))
        .L_AddView(_fieldLeftView);
    }];
    
    
    _tableview.tableHeaderView = headerView;
    
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicScoreItemCell * cell = [[MusicScoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.dictData = _tableData[indexPath.row];
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicScoreDetailViewController * musicScoreDetailVC =  [[MusicScoreDetailViewController alloc] init];
    musicScoreDetailVC.musicScoreName = @"爱的罗曼斯";
    musicScoreDetailVC.imageCount     = 3;
    [self.navigationController pushViewController:musicScoreDetailVC animated:YES];
}

#pragma mark - 事件
-(void)searchMusciScore {
    SearchMusicScoreViewController * searchMusicScoreVC = [[SearchMusicScoreViewController alloc] init];
    searchMusicScoreVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchMusicScoreVC animated:YES completion:nil];
}


//筛选按钮点击时
-(void)filterClick {
    NSLog(@"筛选...");
    
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.3;
        [_musicScoreFilterView setX:80];
    }];
}

//遮罩视图点击时
-(void)maskBoxClick {
    [UIView animateWithDuration:0.4 animations:^{
        _maskBoxView.alpha = 0.0;
        [_musicScoreFilterView setX:D_WIDTH];
    }];
}




@end
