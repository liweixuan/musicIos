//
//  MusicVideoDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicVideoDetailViewController.h"
#import "VideoCommentCell.h"
#import "VideoCommentFrame.h"
#import "JWPlayer.h"
#import "UserDetailViewController.h"

@interface MusicVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,VideoCommentCellDelegate>
{
    UIView           * _videoBox;
    Base_UITableView * _tableview;
    NSMutableArray   * _commentData;
    UITextView       * _inputTextView;
    UILabel          * _inputPlaceholderLabel;
    UIView           * _maskView;
    UIView           * _replyView;
    
    CGFloat            _inputTextViewHeight;
    CGFloat            _keyboardHeight;
    NSInteger          _replyMode;  //0-回复动态 1-回复动态评论
    NSInteger          _replyUid;   //被回复人ID
    NSInteger          _skip;
}
@end

@implementation MusicVideoDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频详细";
    
    //初始化变量
    [self initVar];
    
    //创建遮罩
    [self createMaskView];
    
    //创建列表视图
    [self createTableview];
    
    //创建底部回复框
    [self createReplyView];
    
    //相关通知监听
    [self createNoti];
    
    //初始化数据
    [self initData:@"init"];
    
    
    //创建视频容器
    [self createVideoBox];
    
    //创建后退按钮
    [self createBackBtn];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)initVar {
    _commentData              = [NSMutableArray array];
    self.view.backgroundColor = [UIColor blackColor];
    _skip                     = 0;
    _replyMode                = 0;
    _replyUid                 = 0;

}


-(void)initData:(NSString *)type {
    
    NSArray * params = @[@{@"key":@"vc_vid",@"value":@(self.videoId)},@{@"key":@"skip",@"value":@(_skip)},@{@"key":@"limit",@"value":@(PAGE_LIMIT)}];
    NSString * url = [G formatRestful:API_VIDEO_COMMENT_SEARCH Params:params];
    
    if([type isEqualToString:@"init"]){
        [self startActionLoading:@"正在获取视频评论..."];
    }
    
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        
        if([type isEqualToString:@"init"]){
            [self endActionLoading];
        }
        
        if([type isEqualToString:@"reload"]){
            [_commentData removeAllObjects];
            [_tableview headerEndRefreshing];
            _tableview.mj_footer.hidden = NO;
            [_tableview resetNoMoreData];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多动态信息");
            return;
        }
        
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            VideoCommentFrame * frame = [[VideoCommentFrame alloc] initWithVideoComment:dict];
            [tempArr addObject:frame];
            
        }
        
        
        if([type isEqualToString:@"more"]){
            [_commentData addObjectsFromArray:tempArr];
            [_tableview footerEndRefreshing];
        }else{
            
            //更新数据数据
            _commentData = tempArr;
            
        }
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
    }];
    
    
}

//后退按钮
-(void)createBackBtn {
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(10,30,20,20))
        .L_BtnImageName(@"back",UIControlStateNormal)
        .L_TargetAction(self,@selector(backBtnClick),UIControlEventTouchUpInside)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

//创建遮罩
-(void)createMaskView {
    
    _maskView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT - 50))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.navigationController.view);
    }];
    
}

-(void)createVideoBox {
    
    //http://musicalinstrumentutopia.oss-cn-qingdao.aliyuncs.com/userMatchVideo/video2147483647-97473.mp4
    
    //初始化视频
    NSString * playerUrl = @"";
    JWPlayer * player=[[JWPlayer alloc]initWithFrame:CGRectMake(0,20,[self.view width],260)];
    [player updatePlayerWith:[NSURL URLWithString:playerUrl]];
    [self.view addSubview:player];
    
}


-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(270,0,50,0));
    }];
    
    //列表视图事件部分
    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    _tableview.loadNewData = ^(){
        NSLog(@"loadNewData...");
        [weakSelf loadNewData];
        
    };
    
    //上拉加载更多
    _tableview.loadMoreData = ^(){
        NSLog(@"loadMoreData...");
        [weakSelf loadMoreData];
        
    };
    
    _tableview.marginBottom = 10;
    
    
}

//创建底部回复框
-(void)createReplyView {
    
    _replyView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT - 50,D_WIDTH,50))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.8)
        .L_AddView(self.view);
    }];
    
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(CARD_MARGIN_LEFT,5,[_replyView width] - CARD_MARGIN_LEFT*2,40)];
    _inputTextView.font = [UIFont systemFontOfSize:TEXTFIELD_FONT_SIZE];
    _inputTextView.backgroundColor = HEX_COLOR(@"#EEEEEE");
    _inputTextView.delegate = self;
    _inputTextView.scrollEnabled = NO;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.cornerRadius = 5;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _inputTextView.layer.shadowOpacity = 0.2;
    _inputTextView.layer.shadowOffset = CGSizeMake(3,3);
    _inputTextView.textContainerInset = UIEdgeInsetsMake(10,10,10,10);
    [_replyView addSubview:_inputTextView];
    
    //输入框的占位字
    _inputPlaceholderLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(15,40/2 - ATTR_FONT_SIZE/2 - 2,200, ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"说点什么吧")
        .L_AddView(_inputTextView);
        
    }];
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VideoCommentCell * cell   = [[VideoCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    VideoCommentFrame * frame = _commentData[indexPath.row];
    cell.videoCommentFrame    = frame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCommentFrame * frame = _commentData[indexPath.row];
    return frame.cellHeight;
}

-(void)loadNewData {
    _skip = 0;
    [self initData:@"reload"];
}

-(void)loadMoreData {
    _skip += PAGE_LIMIT;
    [self initData:@"more"];
    
}


-(void)messageSend:(NSString *)msg {
    
    //判断回复的类型
    NSDictionary * params = [NSDictionary dictionary];
    NSString     * apiUrl = @"";
    
    if(_replyMode == 0){
        
        apiUrl = API_VIDEO_REPLY;
        
        //发布动态评论信息
        params = @{
                   @"vc_content":_inputTextView.text,
                   @"vc_vid":@(self.videoId),
                   @"vc_uid":@([UserData getUserId])
                   };
        
        
    }else{
        
        apiUrl = API_VIDEO_REPLY_COMMENT;
        
        //发布动态回复评论信息
        params = @{
                   
                   @"vc_uid"       : @([UserData getUserId]),
                   @"vc_vid"       : @(self.videoId),
                   @"vc_content"   : msg,
                   @"vc_reply_uid" : @(_replyUid)
                   };
        
    }
    
    [self startActionLoading:@"评论发布中..."];
    
    [NetWorkTools POST:apiUrl params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        SHOW_HINT(@"评论发布成功");
        [self maskBoxClick];
        
        [_tableview beginHeaderRefresh];
        
        
    } errorBlock:^(NSString *error) {
        SHOW_HINT(error);
    }];

}


//textview内容改变时
-(void)textViewDidChange:(UITextView *)textView {
    
    //获得textView的初始尺寸
    CGFloat width   = CGRectGetWidth(textView.frame);
    CGFloat height  = CGRectGetHeight(textView.frame);
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size   = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame  = newFrame;
    
    CGFloat tempH = 0.0;
    if(newSize.height < 40){
        tempH = 40;
    }else{
        tempH = newSize.height;
    }
    _inputTextViewHeight = tempH;
    [_replyView setHeight:_inputTextViewHeight+10];
    [UIView animateWithDuration:0.2 animations:^{
        [_maskView setHeight:D_HEIGHT - _keyboardHeight - [_replyView height]];
        [_replyView setY:D_HEIGHT - [_replyView height] - _keyboardHeight];
        [_inputTextView setHeight:_inputTextViewHeight];
    }];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _inputPlaceholderLabel.hidden = YES;
    
    if ([text isEqualToString:@"\n"]){ //获取键盘中发送事件（回车事件）
        
        
        if([_inputTextView.text isEqualToString:@""] && _inputTextView.text.length<=0){
            _inputTextView.text = @"";
        }else{
            
            [self messageSend:_inputTextView.text];  //处理键盘的发送事件
            
            //清除输入框
            _inputTextView.text = @"";
            
            //恢复输入框
            _inputTextViewHeight = 40;
            
            //隐藏
            _inputPlaceholderLabel.hidden = NO;
            
            
        }
        
        return NO;
        
        
    }
    return YES;
    
}

-(void)commentUserHeaderClick:(VideoCommentCell *)cell {
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    VideoCommentFrame * dcFrame = _commentData[indexPath.row];
    
    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dcFrame.videoCommentDict[@"vc_uid"] integerValue];
    userDetailVC.username = dcFrame.videoCommentDict[@"u1_username"];
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
    
    
}

-(void)commentZanClick:(VideoCommentCell *)cell {
    
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    VideoCommentFrame * dcFrame = _commentData[indexPath.row];
    
    NSDictionary * params = @{@"vc_id":dcFrame.videoCommentDict[@"vc_id"]};
    
    [self startActionLoading:@"点赞处理中..."];
    [NetWorkTools POST:API_VIDEO_COMMENT_ZAN params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        SHOW_HINT(@"点赞成功");
    } errorBlock:^(NSString *error) {
        SHOW_HINT(error);
    }];
    
    
}

-(void)commentReplyClick:(VideoCommentCell *)cell {
    
    //回复评论模式
    _replyMode = 1;
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    VideoCommentFrame * dcFrame = _commentData[indexPath.row];
    
    //当前被回复的用户ID
    _replyUid = [dcFrame.videoCommentDict[@"vc_uid"] integerValue];
    
    [_inputTextView becomeFirstResponder];
    
    
}


#pragma mark - 通知相关事件
//键盘将要打开
-(void)keyboardWillShow:(NSNotification *)notification {
    
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = frame.size.height;
    [_replyView setY:D_HEIGHT - frame.size.height - [_replyView height]];
    
    [self showMaskView];
    
}

//键盘将要隐藏
-(void)keyboardWillHidden:(NSNotification *)notification {
    [_inputTextView setHeight:40];
    [_replyView setHeight:50];
    [_replyView setY:D_HEIGHT - [_replyView height]];
}

//显示遮罩
-(void)showMaskView {
    [_maskView setHeight:D_HEIGHT - _keyboardHeight - 50];
    [UIView animateWithDuration:0.2 animations:^{
        _maskView.alpha = 0.3;
    }];
}

//遮罩视图点击时
-(void)maskBoxClick {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _maskView.alpha = 0.0;
    }];
}
@end
