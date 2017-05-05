//
//  OfficialNoteDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OfficialNoteDetailViewController.h"
#import "CommentCell.h"
#import "CommentFrame.h"

@interface OfficialNoteDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * _videoBox;
    UIScrollView * _scrollBoxView;
    UIView * _teacherInfoBox;
    UIView * _videoActionBox;
    UIView * _videoCommentBox;
    UIView * _courseTimeNodeBox;
    UIView * _commentLine;
    
    Base_UITableView * _commentTableview;
    
    NSMutableArray   * _tableData;
}
@end

@implementation OfficialNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第一节/认识吉他";
    
    [self initVar];
    
    //初始化数据
    [self initData];
    
    //创建视图
    [self createView];
}

-(void)initVar {
    _tableData = [NSMutableArray array];
}

-(void)initData {
    
    NSArray * tempArr = @[
                          @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"999",@"commentContent":@"庆历四年春， 滕子京谪守巴陵郡。 越明年， 政通人和， 百废具兴。 乃重修岳阳楼， 增其旧制， 刻唐贤今人诗赋于其上。 属予作文以记之。"},
                          @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"10",@"commentContent":@"予观夫巴陵胜状， 在洞庭一湖。"},
                          @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"9",@"commentContent":@"庆历四年的春天，滕子京被降职到巴陵郡做太守。到了第二年，政事顺利，百姓和乐，各种荒废的事业都兴办起来了。于是重新修建岳阳楼，扩大它原有的规模，把唐代名家和当代人的赋刻在它上面。嘱托我写一篇文章来记述这件事情。我观看那巴陵郡的美好景色，全在洞庭湖上。"},
                          @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"100",@"commentContent":@"庆历四年春"},
                          @{@"nickname":@"小雪",@"time":@"2012-12-12",@"zanCount":@"29",@"commentContent":@"庆历四年春， 滕子京谪守巴陵郡。 越明年， 政通人和， 百废具兴。"}
                          ];
    
    for(int i =0;i<tempArr.count;i++){
        CommentFrame * frame = [[CommentFrame alloc] initWithComment:tempArr[i]];
        [_tableData addObject:frame];
    }
    
    [_commentTableview reloadData];
    
    
}

//创建视图
-(void)createView {
    
    //创建视频显示
    [self createVideoView];
    
    //创建操作显示
    [self videoActionView];


    //创建滚动容器
    [self createScrollview];

    //创建教师信息显示
    [self createTeacherInfoView];
    
    //课程时间节点显示
    [self createCourseTimeNode];
    
    //其他操作项显示
    [self createOtherView];

    //视频评论容器视图
    [self createVideoCommentBox];
    
    //创建评论列表视图
    [self createCommentTableview];
    
    
    
}

//创建视频显示
-(void)createVideoView{
    
    _videoBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT *2,200))
        .L_BgColor(HEX_COLOR(@"#CCCCCC"))
        .L_raius_location(UIRectCornerTopLeft | UIRectCornerTopRight,5)
        .L_AddView(self.view);
    }];
    
    //视频图标
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([_videoBox width]/2 - 50/2,[_videoBox height]/2 - 50/2 , 50, 50))
        .L_ImageName(@"wh")
        .L_AddView(_videoBox);
    }];

}

//创建滚动容器
-(void)createScrollview {
    
    _scrollBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        
        view
        .L_Frame(CGRectMake(0,[_videoActionBox bottom]+CONTENT_PADDING_TOP, D_WIDTH, D_HEIGHT_NO_NAV - ([_videoActionBox bottom]+CONTENT_PADDING_TOP)))
        .L_contentSize(CGSizeMake(D_WIDTH,1000))
        .L_AddView(self.view);
        
    }];
}

//视频评论容器视图
-(void)createVideoCommentBox {
  
    _videoCommentBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,D_HEIGHT, D_WIDTH,D_HEIGHT_NO_NAV - [_videoBox bottom]))
        .L_BgColor(HEX_COLOR(VC_BG))
        .L_AddView(self.view);
    }];
    
    //全部评论标题
    UILabel * allTitle = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, 100,CONTENT_FONT_SIZE))
        .L_Text(@"全部评论")
        .L_Font(CONTENT_FONT_SIZE)
        .L_AddView(_videoCommentBox);
    }];
    
    //关闭
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([_videoCommentBox width] - 30, [allTitle top]-5, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_Event(YES)
        .L_Click(self,@selector(closeCommentBox))
        .L_AddView(_videoCommentBox);
    }];

    //评论输入框
    UITextField * commentInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[allTitle bottom]+10,[_videoCommentBox width] - CARD_MARGIN_LEFT * 2, 30))
        .L_Placeholder(@"为该视频发表点评论")
        .L_PaddingLeft(10)
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_videoCommentBox);
    }];
    
    //分割线
    _commentLine =  [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[commentInput bottom]+10, [_videoCommentBox width],1))
        .L_BgColor(HEX_COLOR(@"#E5E5E5"))
        .L_AddView(_videoCommentBox);
    }];
    
}

//创建操作显示
-(void)videoActionView {
    
    _videoActionBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_videoBox bottom],D_WIDTH-CARD_MARGIN_LEFT*2,40))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_raius_location(UIRectCornerBottomLeft | UIRectCornerBottomRight,5)
        //.L_radius_NO_masksToBounds(5)
        .L_AddView(self.view);
        
    }];

    
    //评论
    UIImageView * commentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[_videoActionBox height]/2-  MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Event(YES)
        .L_Click(self,@selector(showCommentDetail))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_videoActionBox);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([commentIcon right]+ICON_MARGIN_CONTENT,0,40, [_videoActionBox height]))
        .L_Font(ATTR_FONT_SIZE)
        .L_isEvent(YES)
        .L_Text(@"122")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Click(self,@selector(showCommentDetail))
        .L_AddView(_videoActionBox);
    }];
    
    //点赞图标
    UIImageView * zanIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([_videoActionBox width] - 90,[_videoActionBox height]/2-  MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_videoActionBox);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([zanIcon right]+ICON_MARGIN_CONTENT,0,80, [_videoActionBox height]))
        .L_Font(ATTR_FONT_SIZE)
        .L_Text(@"999")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_videoActionBox);
    }];
    
    //收藏图标
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_videoActionBox width] - 30,[_videoActionBox height]/2-  MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_videoActionBox);
    }];

    
}

//创建教师信息显示
-(void)createTeacherInfoView {
    
    _teacherInfoBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH -CARD_MARGIN_LEFT * 2,100))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
    }];
    
    //头像
    UIImageView * headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP, 40,40))
        .L_ImageName(HEADER_DEFAULT)
        .L_AddView(_teacherInfoBox);
    }];
    
    //性别图标
    UIImageView * sexIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([headerView right]+CONTENT_PADDING_LEFT,[headerView top] + 12, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_teacherInfoBox);
    }];
    
    //性别
    UILabel * sex = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([sexIcon right]+ICON_MARGIN_CONTENT,[sexIcon top] , 20,ATTR_FONT_SIZE))
        .L_Text(@"男")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_teacherInfoBox);
    }];
    
    //姓名
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([sex right]+5,[sexIcon top]-2,100,SUBTITLE_FONT_SIZE))
        .L_Text(@"李梵羽")
        .L_AddView(_teacherInfoBox);
    }];
    
    //地址图标
    UIImageView * locationIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([sexIcon left],[sexIcon bottom] + CONTENT_PADDING_TOP, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_teacherInfoBox);
    }];
    
    //地址
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([locationIcon right]+ICON_MARGIN_CONTENT,[locationIcon top] ,200,ATTR_FONT_SIZE))
        .L_Text(@"甘肃省-天水市-麦积区")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_teacherInfoBox);
    }];
    
    //擅长乐器
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([locationIcon left],[locationIcon bottom]+CONTENT_PADDING_TOP,200,ATTR_FONT_SIZE))
        .L_Text(@"主教乐器: 古典吉他")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(_teacherInfoBox);
    }];
    

    //线下约课图标
    UIImageView * yuekeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([_teacherInfoBox width] - MIDDLE_ICON_SIZE - CONTENT_PADDING_LEFT - 10,[_teacherInfoBox height]/2 - BIG_ICON_SIZE/2 , BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_teacherInfoBox);
    }];
    
    //分割线
    [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake([yuekeIcon left] - 20,10, 1, [_teacherInfoBox height] - 20))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(_teacherInfoBox);
    }];
    
    
    
}

//课程时间节点信息
-(void)createCourseTimeNode {
    
    _courseTimeNodeBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_teacherInfoBox bottom]+5,D_WIDTH -CARD_MARGIN_LEFT * 2,250))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
        
    }];
    
    //图标
    UIImageView * courseTimeNodeIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_courseTimeNodeBox);
    }];
    
    //标题
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([courseTimeNodeIcon right]+CONTENT_PADDING_LEFT,[courseTimeNodeIcon top], 100,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_Text(@"课程时间节点")
        .L_AddView(_courseTimeNodeBox);
    }];
    
}

//其他操作项显示
-(void)createOtherView {
    
    CGFloat itemY = [_courseTimeNodeBox bottom]+5;
    
    NSArray * textArr = @[@"遇到问题，向老师提问",@"查看本课所用曲谱",@"查看推荐演奏曲谱"];
    
    for(int i = 0;i<3;i++){

        UIView * itemView = [UIView ViewInitWith:^(UIView *view) {
           
            view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,itemY, D_WIDTH - CARD_MARGIN_LEFT * 2, NORMAL_CELL_HIEGHT))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(_scrollBoxView);
            
        }];
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(itemView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + CONTENT_PADDING_LEFT,0, [itemView width], NORMAL_CELL_HIEGHT))
            .L_Text(textArr[i])
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(itemView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake([itemView width] - CONTENT_PADDING_LEFT*2-MIDDLE_ICON_SIZE/2,NORMAL_CELL_HIEGHT/2 - MIDDLE_ICON_SIZE /2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(itemView);
        }];
        
        
        itemY = [itemView bottom] + 5;
        
    }
    
    //设置滚动容器高
    _scrollBoxView.contentSize = CGSizeMake(D_WIDTH,itemY+10);
    

    
}

//创建评论列表视图
-(void)createCommentTableview {
    
    //创建列表视图
    _commentTableview  = [[Base_UITableView alloc] initWithFrame:CGRectMake(0,[_commentLine bottom]+10,[_videoCommentBox width],[_videoCommentBox height] - ([_commentLine bottom]+10)) style:UITableViewStylePlain];
    _commentTableview.backgroundColor = HEX_COLOR(VC_BG);
    _commentTableview.delegate = self;
    _commentTableview.dataSource = self;
    
    //创建上下拉刷新
    _commentTableview.isCreateHeaderRefresh = NO;
    _commentTableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _commentTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_videoCommentBox addSubview:_commentTableview];

    
}

#pragma mark - 评论列表代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell * cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    CommentFrame * frame = _tableData[indexPath.row];

    cell.commentFrame = frame;
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentFrame * frame = _tableData[indexPath.row];
    return frame.cellHeight;
}

#pragma mark - 事件
-(void)showCommentDetail {
    NSLog(@"查看评论信息");
    
    [UIView animateWithDuration:0.3 animations:^{
        [_videoCommentBox setY:[_videoBox bottom]];
    }];
}

//关闭评论
-(void)closeCommentBox {
    [UIView animateWithDuration:0.3 animations:^{
        [_videoCommentBox setY:D_HEIGHT];
    }];
}

@end
