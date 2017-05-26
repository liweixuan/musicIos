#import "ChatView.h"
#import "PhotoBoxView.h"
#import "RadioBoxView.h"

#define INPUT_BOX_HEIGHT 80   //底部输入容器高度

@interface ChatView()
    <
        UITableViewDelegate,
        UITableViewDataSource,
        UITextViewDelegate,
        PhotoBoxViewDelegate,
        UIGestureRecognizerDelegate
    >
{
    Base_UITableView * _tableview;              //聊天列表视图
    UIView           * _bottomToolBox;          //底部输入区域容器视图
    UITextView       * _inputTextView;          //输入框容器
    UIView           * _bottomToolMenu;         //菜单容器
    UILabel          * _inputPlaceholderLabel;  //输入框的占位字
    
    UIView           * _expressionBox;        //表情容器
    RadioBoxView     * _radioBox;             //语音容器
    PhotoBoxView     * _photoBox;             //图片容器
    UIView           * _moreBox;              //更多容器
    
    CGFloat            _keyboardHeight;       //键盘高度
    CGFloat            _inputTextViewHeight;  //输入框高度
    
    //当前所处的模式 0-无状态模式（初始）1-普通键盘弹出模式 2-表情输入表示 3-语音模式 4-照相相册模式 5-视频模式 6-地理位置模式 7-更多模式
    NSInteger          _nowMode;
    
    NSMutableArray    * _tableData; //数据源
}
@end

@implementation ChatView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建聊天列表视图
        [self createTableview];
        
        //创建底部输入框
        [self createBottonInput];
        
        //创建底部各个菜单项操作容器
        [self createBottomMenuItemBox];
        
        //相关通知监听
        [self createNoti];
        
    }
    return self;
}

//初始化变量
-(void)initVar {
    _nowMode             = 0;
    _keyboardHeight      = 0.0;
    _inputTextViewHeight = 0.0;
    _tableData = [NSMutableArray array];
}

//创建聊天列表视图
-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableClick)];
    tap.delegate = self;
    [_tableview addGestureRecognizer:tap];
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tableview];
    
    //列表视图事件部分
    __weak typeof(self) weakSelf = self;
    
    //下拉加载历史信息
    _tableview.loadNewData = ^(){
        NSLog(@"loadNewData...");
        [weakSelf loadNewData];
        
    };
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0,0,INPUT_BOX_HEIGHT,0));
    }];
    
}

-(void)loadNewData {
    [self.delegate getHistoryMessage];
}

//创建底部输入框
-(void)createBottonInput {
    
    _bottomToolBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT_NO_NAV - INPUT_BOX_HEIGHT,D_WIDTH,INPUT_BOX_HEIGHT))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_AddView(self);
    }];
    
    //聊天输入框容器
    UIView * inputBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0, [_bottomToolBox width], 40))
        .L_BgColor(HEX_COLOR(@"#F5F5F5"))
        .L_AddView(_bottomToolBox);
    }];
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,0, D_WIDTH,40)];
    _inputTextView.font = [UIFont systemFontOfSize:TEXTFIELD_FONT_SIZE];
    _inputTextView.delegate = self;
    _inputTextView.scrollEnabled = NO;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _inputTextView.layer.shadowOpacity = 0.2;
    _inputTextView.layer.shadowOffset = CGSizeMake(3,3);
    _inputTextView.textContainerInset = UIEdgeInsetsMake(10,10,10,10);
    [inputBox addSubview:_inputTextView];
    
    //设置输入框默认高度
    _inputTextViewHeight = [_inputTextView height];
    
    //输入框的占位字
    _inputPlaceholderLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(15,[_inputTextView height]/2 - ATTR_FONT_SIZE/2,200, ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"说点什么吧")
        .L_AddView(_inputTextView);
        
    }];
    
    //菜单容器
    _bottomToolMenu = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[inputBox bottom],D_WIDTH,40))
        .L_BgColor(HEX_COLOR(@"#F5F5F5"))
        .L_AddView(_bottomToolBox);
    }];
    
    //创建菜单
    NSArray * menuArr = @[@"video_message",@"radio_message",@"photo_message",@"video_message",@"location_message",@"more_message"];
    
    //宽度
    CGFloat menuItemViewW = D_WIDTH / menuArr.count;
    
    for(int i=0;i<menuArr.count;i++){
        
        UIView * menuItemView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(i*menuItemViewW,0, menuItemViewW,[_bottomToolMenu height]))
            .L_tag(i)
            .L_Click(self,@selector(bottomToolMenuClick:))
            .L_AddView(_bottomToolMenu);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(menuItemViewW/2 - ([menuItemView width]*0.7)/2,[_bottomToolMenu height]/2 - (40*0.7) / 2, [menuItemView width]*0.7,40*0.7))
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_ImageName(menuArr[i])
            .L_AddView(menuItemView);
        }];
    }
    
}

//创建底部各个菜单项操作容器
-(void)createBottomMenuItemBox {
    
    
    
    //表情容器框
    _expressionBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[_bottomToolBox bottom],D_WIDTH,200))
        .L_BgColor([UIColor redColor])
        .L_AddView(self);
    }];
    
    //语音容器
    _radioBox = [[RadioBoxView alloc] initWithFrame:CGRectMake(0,[_bottomToolBox bottom],D_WIDTH,200)];
    _radioBox.backgroundColor = [UIColor whiteColor];
    [self addSubview:_radioBox];

    //图片容器
    _photoBox = [[PhotoBoxView alloc] initWithFrame:CGRectMake(0,[_bottomToolBox bottom],D_WIDTH,200)];
    _photoBox.delegate = self;
    [self addSubview:_photoBox];
    
    //更多容器
    _moreBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,[_bottomToolBox bottom],D_WIDTH,200))
        .L_BgColor([UIColor blueColor])
        .L_AddView(self);
    }];

    
}

//相关通知监听
-(void)createNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 代理部分
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断是什么类型的消息创建相应的CELL项
    id messageObj = _tableData[indexPath.row];
    
    //普通文本消息
    if([messageObj isKindOfClass:[TextMessageFrame class]]){
        
        TextMessageCell  * cell  = [[TextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        TextMessageFrame * frame = _tableData[indexPath.row];
        cell.frameData           = frame;
        
        //禁止点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
 
    }else if([messageObj isKindOfClass:[ImageMessageFrame class]]){
        
        ImageMessageCell  * cell  = [[ImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        ImageMessageFrame * frame = _tableData[indexPath.row];
        cell.frameData           = frame;
        
        //禁止点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        RadioMessageCell  * cell  = [[RadioMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        RadioMessageFrame * frame = _tableData[indexPath.row];
        cell.frameData           = frame;
        
        //禁止点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }
    
    
    
    return nil;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断是什么类型的消息创建相应的CELL项
    id messageObj = _tableData[indexPath.row];
    
    //普通文本消息
    if([messageObj isKindOfClass:[TextMessageFrame class]]){
        TextMessageFrame * frame = _tableData[indexPath.row];
        return frame.cellHeight;
    }else if([messageObj isKindOfClass:[ImageMessageFrame class]]){
        ImageMessageFrame * frame = _tableData[indexPath.row];
        return frame.cellHeight;
    }else if([messageObj isKindOfClass:[RadioMessageFrame class]]){
        RadioMessageFrame * frame = _tableData[indexPath.row];
        return frame.cellHeight;
    }
    
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"rowClick...");
    [self CloseActionViewOrKeyBoard:_nowMode];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"********");
   // [self CloseActionViewOrKeyBoard:_nowMode];
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
    [_bottomToolBox setHeight:_inputTextViewHeight + 40];
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_bottomToolBox height] - _keyboardHeight];
        [_inputTextView setHeight:_inputTextViewHeight];
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - _keyboardHeight];
        [_bottomToolMenu setY:[_inputTextView bottom]];
        //判断内容是否超过了一屏
        //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
            [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
        //}
    }];
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length <= 0){
        _inputPlaceholderLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    _inputPlaceholderLabel.hidden = YES;

    if ([text isEqualToString:@"\n"]){ //获取键盘中发送事件（回车事件）
        

        if([_inputTextView.text isEqualToString:@""] && _inputTextView.text.length<=0){
            _inputTextView.text = @"";
        }else{

            [self messageSend];  //处理键盘的发送事件
            
            //清除输入框
            _inputTextView.text = @"";
            
            //恢复输入框
            _inputTextViewHeight = 40;
            
            
        }
 
        return NO;

        
    }
    return YES;
    
}

//恢复底部工具栏位置
-(void)resetBottomTool {
    [self resumeBottomTool];
}


#pragma mark - 点击事件

//底部操作菜单点击
-(void)bottomToolMenuClick:(UITapGestureRecognizer *)tap {
    NSInteger tagV = tap.view.tag;
    
    NSLog(@"%ld",(long)tagV);
    NSLog(@"%ld",(long)_nowMode);
    
    if(tagV == 0){
        
        NSLog(@"表情");
        
        [self toPrepareOpenMenuBox];
        
        if(_nowMode == 0){
            [UIView animateWithDuration:0.2 animations:^{
                [_expressionBox setY:D_HEIGHT_NO_NAV - [_expressionBox height]];
            }];
        }else{
            [_expressionBox setY:D_HEIGHT_NO_NAV - [_expressionBox height]];
        }
        
        _nowMode = 2;
        [self endEditing:YES];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_expressionBox height] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_expressionBox height]];
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        }];
        
    }else if(tagV == 1){
        
        NSLog(@"语音");
        
        [self toPrepareOpenMenuBox];
        
        if(_nowMode == 0){
            [UIView animateWithDuration:0.2 animations:^{
                [_radioBox setY:D_HEIGHT_NO_NAV - [_radioBox height]];
            }];
        }else{
            [_radioBox setY:D_HEIGHT_NO_NAV - [_radioBox height]];
        }
        
        _nowMode = 3;
        [self endEditing:YES];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_radioBox height] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_radioBox height]];
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        }];
    }else if(tagV == 2){
        
        NSLog(@"相册");
        
        [self toPrepareOpenMenuBox];
        
        if(_nowMode == 0){
            [UIView animateWithDuration:0.2 animations:^{
                [_photoBox setY:D_HEIGHT_NO_NAV - [_photoBox height]];
            }];
        }else{
            [_photoBox setY:D_HEIGHT_NO_NAV - [_photoBox height]];
        }
        
        _nowMode = 4;
        [self endEditing:YES];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_photoBox height] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_photoBox height]];
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
           // }
        }];
        
    }else if(tagV == 3){
        
        [self toPrepareOpenMenuBox];
        NSLog(@"视频");
        _nowMode = 0;

        [self endEditing:YES];
        
    
        [UIView animateWithDuration:0.2 animations:^{
            
      
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        } completion:^(BOOL finished) {
            
            //跳转到视频录制界面
            [self.delegate goVideoRecord];
            
            
        }];
        
        
        
        
    }else if(tagV == 4){
        [self toPrepareOpenMenuBox];
        NSLog(@"地理位置");
        
        _nowMode = 0;
        
        [self endEditing:YES];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
           // }
        }];
        
    }else if(tagV == 5){
        
        NSLog(@"更多..");
        
        [self toPrepareOpenMenuBox];
        
        if(_nowMode == 0){
            [UIView animateWithDuration:0.2 animations:^{
                [_moreBox setY:D_HEIGHT_NO_NAV - [_moreBox height]];
            }];
        }else{
            [_moreBox setY:D_HEIGHT_NO_NAV - [_moreBox height]];
        }
        
        _nowMode = 7;
        [self endEditing:YES];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_moreBox height] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_moreBox height]];
           // if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
           // }
        }];
        
    }
    
}

#pragma mark - 通知相关事件
//键盘将要打开
-(void)keyboardWillShow:(NSNotification *)notification {
    
    _nowMode = 1;
    
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardHeight = frame.size.height;
    [_tableview setHeight:D_HEIGHT_NO_NAV - INPUT_BOX_HEIGHT - _keyboardHeight];
    [_bottomToolBox setY:[_tableview bottom]];
    
    //判断内容是否超过了一屏
    //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
        [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:YES];
   // }
    
    
}

//键盘将要隐藏
-(void)keyboardWillHidden:(NSNotification *)notification {
    
    NSLog(@"关闭键盘事件...");
    
    
    if(_nowMode == 1){
        
        _keyboardHeight = 0;
        [_inputTextView setHeight:_inputTextViewHeight];
        [_bottomToolBox setHeight:_inputTextViewHeight + 40];
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - _keyboardHeight];
        [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
        [_bottomToolMenu setY:[_inputTextView bottom]];
        [_expressionBox setY:D_HEIGHT_NO_NAV];
        [_radioBox setY:D_HEIGHT_NO_NAV];
        [_photoBox setY:D_HEIGHT_NO_NAV];
        [_moreBox setY:D_HEIGHT_NO_NAV];
        
        _nowMode = 0;
        
        
    }else if(_nowMode == 2){
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_expressionBox height]];
        
    }else if(_nowMode == 3){
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_radioBox height]];
        
    }else if(_nowMode == 4){
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_photoBox height]];
    }else if(_nowMode == 7){
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height] - [_moreBox height]];
    }
 
    
}


#pragma mark - 私有方法
//消息发送
-(void)messageSend {
    NSLog(@"消息发送...");
    NSString * message = [_inputTextView text];
    NSLog(@"******%@",message);
    [self.delegate sendTextMessage:message];
    
}

//发送单图片消息
-(void)sendImageData:(NSArray *)images {
    
    NSLog(@"消息发送...");
    [self.delegate sendImageMessage:images];
    
    
}

//收缩键盘或操作视图
-(void)CloseActionViewOrKeyBoard:(NSInteger)mode {
    
    if(mode == 1){
       
        [self endEditing:YES];
    }else if(mode == 2){
        [UIView animateWithDuration:0.3 animations:^{
            [_expressionBox setY:D_HEIGHT_NO_NAV];
            [_bottomToolBox setY:[_expressionBox top] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //判断内容是否超过了一屏
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
           // }
        }];
        
        
    }else if(mode == 3){
      
        [UIView animateWithDuration:0.3 animations:^{
            [_radioBox setY:D_HEIGHT_NO_NAV];
            [_bottomToolBox setY:[_radioBox top] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //判断内容是否超过了一屏
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        }];
    }else if(mode == 4){
        
        [UIView animateWithDuration:0.3 animations:^{
            [_photoBox setY:D_HEIGHT_NO_NAV];
            [_bottomToolBox setY:[_photoBox top] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //判断内容是否超过了一屏
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        }];
    }else if(mode == 7){
       
        [UIView animateWithDuration:0.3 animations:^{
            [_moreBox setY:D_HEIGHT_NO_NAV];
            [_bottomToolBox setY:[_moreBox top] - [_bottomToolBox height]];
            [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
            //判断内容是否超过了一屏
            //if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
                [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
            //}
        }];
    }else{
        
    }
    
    
    _nowMode = 0;
}

//开启新的容器前收起上一个容器
-(void)toPrepareOpenMenuBox {
    
    if(_nowMode == 0){
        
    }else if(_nowMode == 2){
        
        [_expressionBox setY:D_HEIGHT_NO_NAV];
        
    }else if(_nowMode == 3){
        [_radioBox setY:D_HEIGHT_NO_NAV];
        
    }else if(_nowMode == 4){
        [_photoBox setY:D_HEIGHT_NO_NAV];
    }else if(_nowMode == 7){
        [_moreBox setY:D_HEIGHT_NO_NAV];
    }else{
        [_expressionBox setY:D_HEIGHT_NO_NAV];
        [_radioBox setY:D_HEIGHT_NO_NAV];
        [_photoBox setY:D_HEIGHT_NO_NAV];
        [_moreBox setY:D_HEIGHT_NO_NAV];
    }
}

-(void)tableClick {
    NSLog(@"tableClick....");
    [self CloseActionViewOrKeyBoard:_nowMode];
}

-(void)setMessageData:(NSArray *)messageData {
    
    //更新列表数据
    _tableData = [messageData mutableCopy];
    
    NSLog(@"2222222");
    
    NSLog(@"%f",_tableview.contentSize.height);
    NSLog(@"%f",[_tableview height]);
        [_tableview reloadData];
    
//    if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
//        _tableview.tableHeaderView.hidden = YES;
//    }
    
    //判断内容是否超过了一屏
   // if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
        
        NSLog(@"111111111");
        [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:YES];
   // }

   
}



-(void)setHistoryData:(NSArray *)historyData {
    
    
    [_tableview headerEndRefreshing];
    
    if(historyData.count <= 0){
        return;
    }
    
    _tableData = [historyData mutableCopy];
    
    [_tableview reloadData];
}



-(void)resumeBottomTool {
    
    [self toPrepareOpenMenuBox];
    _nowMode = 0;
    
    [self endEditing:YES];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        [_bottomToolBox setY:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
        [_tableview setHeight:D_HEIGHT_NO_NAV - [_bottomToolBox height]];
        //判断内容是否超过了一屏
       // if(_tableview.contentSize.height > _tableview.bounds.size.height || _tableview.contentSize.height == _tableview.bounds.size.height){
            [_tableview setContentOffset:CGPointMake(0, _tableview.contentSize.height -_tableview.bounds.size.height) animated:NO];
       // }
    }];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end
