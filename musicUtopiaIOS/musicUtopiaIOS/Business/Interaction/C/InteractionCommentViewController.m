#import "InteractionCommentViewController.h"
#import "DynamicContentCell.h"
#import "DynamicCommentCell.h"
#import "DynamicCommentFrame.h"
#import "UserDetailViewController.h"

@interface InteractionCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,DynamicContentCellDelegate,DynamicCommentCellDelegate>
{
    Base_UITableView * _tableview;
    UIView           * _replyView;
    NSMutableArray   * _tableData;
    UITextView       * _inputTextView;
    UILabel          * _inputPlaceholderLabel;
    CGFloat            _inputTextViewHeight;
    CGFloat            _keyboardHeight;
    UIView           * _maskView;   //遮罩
    NSInteger          _replyMode;  //0-回复动态 1-回复动态评论
    NSInteger          _replyUid;   //被回复人ID
    
    NSInteger          _skip;
}
@end

@implementation InteractionCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态评论";
    NSLog(@"要查询的动态信息为：%@",self.dynamicFrame.dynamicModel.headerUrl);
    
    //初始化变量
    [self initVar];
    
    //创建表视图
    [self createTableview];

    //创建底部回复框
    [self createReplyView];
    
    //初始化数据
    [self initData:@"init"];
    
    //相关通知监听
    [self createNoti];
    
    //创建遮罩
    [self createMaskView];


    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_maskView removeFromSuperview];
    _maskView = nil;
}

-(void)initVar {
    _tableData = [NSMutableArray array];
    [_tableData addObject:@{}];
    _keyboardHeight      = 0.0;
    _inputTextViewHeight = 0.0;
    _replyMode           = 0;
    _replyUid            = 0;
    _skip                = 0;
}

-(void)initData:(NSString *)type {
    
    //开始加载
    if([type isEqualToString:@"init"]){
        [self startLoading];
    }
    
    
    //请求动态评论数据
    NSArray  * params = @[@{@"key":@"skip",@"value":@(_skip)},
                          @{@"key":@"limit",@"value":@(PAGE_LIMIT)},
                          @{@"key":@"dc_did",@"value":@(self.dynamicFrame.dynamicModel.dynamicId)}];
    NSString * apiUrl = [G formatRestful:API_DYNAMIC_COMMENT_SEARCH Params:params];
    [NetWorkTools GET:apiUrl params:nil successBlock:^(NSArray *array) {
        
        NSLog(@"%@",array);
        
        NSMutableArray *tempArr = [NSMutableArray array];
        

        //删除加载动画
        if([type isEqualToString:@"init"]){
            [self endLoading];
           
        }
        
        if([type isEqualToString:@"reload"]){
            [_tableData removeAllObjects];
            [_tableData addObject:@{}];
            [_tableview resetNoMoreData];
            _tableview.mj_footer.hidden = NO;
            [_tableview headerEndRefreshing];
        }
        
        if([type isEqualToString:@"more"] && array.count <= 0){
            [_tableview footerEndRefreshingNoData];
            _tableview.mj_footer.hidden = YES;
            SHOW_HINT(@"已无更多评论信息");
            return;
        }


        //将数据转化为数据模型
        for(NSDictionary * dict in array){
            
            DynamicCommentFrame * frame = [[DynamicCommentFrame alloc] initWithDynamicComment:dict];
            [tempArr addObject:frame];

        }
        
        if([type isEqualToString:@"more"]){
            
            //更新数据数据
            [_tableData addObjectsFromArray:tempArr];
            [_tableview footerEndRefreshing];
            
        }else{
            
            _tableData = tempArr;
            [_tableData insertObject:@{} atIndex:0];
        }
        


        //更新表视图
        [_tableview reloadData];
        
        
        
    } errorBlock:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
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

//创建底部回复框
-(void)createReplyView {
    
    _replyView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,D_HEIGHT - 64 - 50,D_WIDTH,50))
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

//创建表视图
-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = YES;
    _tableview.isCreateFooterRefresh = YES;
    
    _tableview.headerRefreshString = @"下拉刷新评论信息";
    _tableview.footerRefreshString = @"加载更多评论";

    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(0,0,50,0));
    }];
    
    _tableview.marginBottom = 10;
    
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
    
}

-(void)createNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 代理
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        DynamicContentCell * cell  = [[DynamicContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.dynamicFrame   = self.dynamicFrame;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate       = self;
        cell.isDeleteBtn    = self.isDeleteBtn;
        
        
        return cell;
    }else{
        DynamicCommentCell * cell = [[DynamicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle    = UITableViewCellSelectionStyleNone;
        
        //数据
        DynamicCommentFrame * frame = _tableData[indexPath.row];
        cell.dynamicCommentFrame = frame;
        cell.delegate = self;
        return cell;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return self.dynamicFrame.cellHeight;
    }

    DynamicCommentFrame * frame = _tableData[indexPath.row];
    return frame.cellHeight;
}


-(void)loadNewData {
    
    _skip = 0;
    [self initData:@"reload"];
}

-(void)loadMoreData {
    
    _skip += PAGE_LIMIT;
    
    [self initData:@"more"];
    
    
    [_tableview footerEndRefreshing];
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
        [_replyView setY:D_HEIGHT_NO_NAV - [_replyView height] - _keyboardHeight];
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


-(void)messageSend:(NSString *)msg {
    
    //判断回复的类型
    NSDictionary * params = [NSDictionary dictionary];
    NSString     * apiUrl = @"";
    
    if(_replyMode == 0){
        
        apiUrl = API_DYNAMIC_REPLY;
        
        //发布动态评论信息
        params = @{
                   @"dc_uid"     : @([UserData getUserId]),
                   @"dc_did"     : @(self.dynamicFrame.dynamicModel.dynamicId),
                   @"dc_content" : msg
                   };
        
        
    }else{
        
        apiUrl = API_DYNAMIC_COMMENT_REPLY;
        
        //发布动态回复评论信息
        params = @{
                   
                   @"dc_uid"       : @([UserData getUserId]),
                   @"dc_did"       : @(self.dynamicFrame.dynamicModel.dynamicId),
                   @"dc_content"   : msg,
                   @"dc_reply_uid" : @(_replyUid)
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

//用户头像点击
-(void)userHeaderClick:(DynamicContentCell *)cell {

     UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
     userDetailVC.userId   = self.dynamicFrame.dynamicModel.userId;
     userDetailVC.username = self.dynamicFrame.dynamicModel.username;
     userDetailVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:userDetailVC animated:YES];

}

-(void)commentUserHeaderClick:(DynamicCommentCell *)cell {
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    DynamicCommentFrame * dcFrame = _tableData[indexPath.row];

    UserDetailViewController * userDetailVC = [[UserDetailViewController alloc] init];
    userDetailVC.userId   = [dcFrame.dynamicCommentDict[@"dc_uid"] integerValue];
    userDetailVC.username = dcFrame.dynamicCommentDict[@"u1_username"];
    userDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDetailVC animated:YES];

    
    
}

-(void)commentZanClick:(DynamicCommentCell *)cell {
    
    //API_DYNAMIC_COMMENT_ZAN
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    DynamicCommentFrame * dcFrame = _tableData[indexPath.row];
    
    NSDictionary * params = @{@"dc_id":dcFrame.dynamicCommentDict[@"dc_id"]};
    
    [self startActionLoading:@"点赞处理中..."];
    [NetWorkTools POST:API_DYNAMIC_COMMENT_ZAN params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        SHOW_HINT(@"点赞成功");
        
        dcFrame.isCommentZan = YES;
        dcFrame.commentZanCount = dcFrame.commentZanCount + 1;
        
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        SHOW_HINT(error);
    }];
    
    
}

-(void)commentReplyClick:(DynamicCommentCell *)cell {
    
    //回复评论模式
    _replyMode = 1;
    
    NSIndexPath * indexPath = [_tableview indexPathForCell:cell];
    DynamicCommentFrame * dcFrame = _tableData[indexPath.row];
    
    //当前被回复的用户ID
    _replyUid = [dcFrame.dynamicCommentDict[@"dc_uid"] integerValue];
    
    [_inputTextView becomeFirstResponder];
    
    
}

-(void)deleteBtnClick:(DynamicContentCell *)cell {
    

    //确定删除
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认操作" message:@"确定要删除该条动态吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary * parmas = @{@"d_id":@(self.dynamicFrame.dynamicModel.dynamicId)};
        [self startActionLoading:@"正在删除动态..."];
        [NetWorkTools POST:API_DYNAMIC_DELETE params:parmas successBlock:^(NSArray *array) {
            [self endActionLoading];
            SHOW_HINT(@"动态删除成功");
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(error);
        }];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark - 通知相关事件
//键盘将要打开
-(void)keyboardWillShow:(NSNotification *)notification {
    
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = frame.size.height;
    [_replyView setY:D_HEIGHT_NO_NAV - frame.size.height - [_replyView height]];
    
    [self showMaskView];
  
}

//键盘将要隐藏
-(void)keyboardWillHidden:(NSNotification *)notification {
    [_inputTextView setHeight:40];
    [_replyView setHeight:50];
    [_replyView setY:D_HEIGHT_NO_NAV - [_replyView height]];
}

//显示遮罩
-(void)showMaskView {
    [_maskView setHeight:D_HEIGHT - _keyboardHeight - 50];
    [UIView animateWithDuration:0.4 animations:^{
        _maskView.alpha = 0.3;
    }];
}

//遮罩视图点击时
-(void)maskBoxClick {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.4 animations:^{
        _maskView.alpha = 0.0;
    }];
    
    _inputTextView.text = @"";
    _inputPlaceholderLabel.hidden = NO;
}


//点赞
-(void)zanClick:(DynamicContentCell *)cell NowView:(UILabel *)label {
    
    [self startActionLoading:@"处理中..."];
    
    NSDictionary * params = @{@"d_id":@(self.dynamicFrame.dynamicModel.dynamicId)};
    [NetWorkTools POST:API_DYNAMIC_ZAN params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        SHOW_HINT(@"点赞成功");
        
        //获取当前动态ID
        self.dynamicFrame.dynamicModel.zanCount = self.dynamicFrame.dynamicModel.zanCount + 1;
        self.dynamicFrame.dynamicModel.isZan = YES;
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
         [self endActionLoading];
        SHOW_HINT(@"点赞失败");
        NSLog(@"%@",error);
    }];

    
}

//关注
-(void)concernClick:(DynamicContentCell *)cell {
    
    [self startActionLoading:@"处理中..."];
    
    NSDictionary * params = @{@"uc_uid":@([UserData getUserId]),@"uc_concern_id":@(self.dynamicFrame.dynamicModel.userId)};
    [NetWorkTools POST:API_USER_CONCERN params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        SHOW_HINT(@"关注成功");
        
        self.dynamicFrame.dynamicModel.isGuanZhu = YES;
        [_tableview reloadData];
        
    } errorBlock:^(NSString *error) {
        
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
    
}
@end
