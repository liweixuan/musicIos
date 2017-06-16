//
//  MusicArticleDetailViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicArticleDetailViewController.h"
#import "MusicArticleCommentViewController.h"

@interface MusicArticleDetailViewController ()<UITextViewDelegate,UIWebViewDelegate>
{
    UIWebView        * _webView;
    UIView           * _titleView;
    UIView           * _bottomToolView;
    UIView           * _replyView;
    UITextView       * _inputTextView;
    UILabel          * _inputPlaceholderLabel;
    CGFloat            _inputTextViewHeight;
    CGFloat            _keyboardHeight;
    UIView           *  _maskView; //遮罩
    
    int _lastPosition;
}
@end

@implementation MusicArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    //创建文章标题头视图
    [self createArticleHeaderView];
    
    //创建右侧分享按钮
    [self createNav];
    
    //创建webView
    [self createWebView];
    
    //创建回复视图
    [self bottomToolView];
    
    //创建监听
    [self createNoti];
    
    //开始加载
    [self startLoading];
}


-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
}

-(void)createNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

//创建右侧分享按钮
-(void)createNav {
    
    UIImageView * shareImage = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_Click(self,@selector(shareClick))
        .L_ImageName(@"fenxiang");
    }];

    UIBarButtonItem * shareBtn       = [[UIBarButtonItem alloc] initWithCustomView:shareImage];

    NSArray * barButtonArr = @[shareBtn];
    self.navigationItem.rightBarButtonItems = barButtonArr;
    
}

-(void)createArticleHeaderView {
    
    _titleView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH,80))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.view);
    }];
    
    //新闻标题
    UILabel * titleLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(10,5,D_WIDTH-20,32))
        .L_Font(16)
        .L_numberOfLines(0)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_Text(self.newsDetail[@"a_title"])
        .L_AddView(_titleView);
    }];
    
    //发布时间
    UILabel * sendTime = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(10,[titleLabel  bottom],120,30))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text([G formatData:[self.newsDetail[@"a_create_time"] integerValue] Format:@"YYYY-MM-dd HH:mm"])
        .L_AddView(_titleView);
    }];
    
    //评论数图标
    UIImageView * pinglunIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([sendTime right],[sendTime top]+10,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(@"pinglun")
        .L_AddView(_titleView);
    }];
    
    //评论数
    UILabel * pinglunCount = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([pinglunIcon right]+ICON_MARGIN_CONTENT,[sendTime  top],30,[sendTime height]))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"200")
        .L_AddView(_titleView);
    }];
    
    //点赞图标
    UIImageView * zanIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([pinglunCount right]+5,[sendTime top]+10,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
        .L_ImageName(@"dianzan")
        .L_AddView(_titleView);
    }];
    
    //点赞数
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([zanIcon right]+ICON_MARGIN_CONTENT,[sendTime  top],30,[sendTime height]))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"99")
        .L_AddView(_titleView);
    }];
    
    //来源
    [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(D_WIDTH - 70, [sendTime  top],65,30))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text([NSString stringWithFormat:@"来源:整理"])
        .L_AddView(_titleView);
    }];
    
    
}


-(void)createWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,[_titleView bottom]+1,D_WIDTH,D_HEIGHT_NO_NAV - [_titleView height] - 50)];
    _webView.backgroundColor = HEX_COLOR(VC_BG);
    [self.view addSubview:_webView];
    _webView.delegate = self;
    [_webView loadHTMLString:self.newsDetail[@"a_content"] baseURL:nil];

}

-(void)bottomToolView {
    
    _replyView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT - 64 - 50,D_WIDTH,50))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.8)
        .L_AddView(self.view);
    }];
    
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(CARD_MARGIN_LEFT,5,[_replyView width] - CARD_MARGIN_LEFT*2 - 40 - 40,40)];
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
    
    //创建查看评论按钮
    UIImageView * pinglunIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_inputTextView right]+10,[_replyView height]/2 - BIG_ICON_SIZE/2,BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_Event(YES)
        .L_ImageName(@"pinglun")
        .L_Click(self,@selector(showCommentClick))
        .L_AddView(_replyView);
    }];
    
    //创建点赞按钮
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([pinglunIcon right]+15,[_replyView height]/2 - BIG_ICON_SIZE/2 - 3,BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_Event(YES)
        .L_ImageName(@"dianzan")
        .L_Click(self,@selector(zanClick))
        .L_AddView(_replyView);
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
    
    //文章ID
    NSInteger aid = [self.newsDetail[@"a_id"] integerValue];
    
    //发布动态评论信息
    NSDictionary * params = @{
                              @"ac_uid"     :@([UserData getUserId]),
                              @"ac_aid"     :@(aid),
                              @"ac_content" :msg
                              };
    
    [self startActionLoading:@"评论发布中..."];
    
    [NetWorkTools POST:API_ARTICLE_REPLY params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        SHOW_HINT(@"评论发布成功");
        [self maskBoxClick];
        
        
    } errorBlock:^(NSString *error) {
        SHOW_HINT(@"评论发布失败");
        NSLog(@"%@",error);
    }];
    
    
    
}


-(void)shareClick {
    NSLog(@"分享...");
    
    NSInteger aid = [self.newsDetail[@"a_id"] integerValue];
    
    NSLog(@"%ld",(long)aid);
}



-(void)showCommentClick {
    NSLog(@"查看评论");
    NSInteger aid = [self.newsDetail[@"a_id"] integerValue];
    PUSH_VC(MusicArticleCommentViewController, YES, @{@"aid":@(aid)});
}

-(void)zanClick {

    NSInteger aid         = [self.newsDetail[@"a_id"] integerValue];
    NSDictionary * params = @{@"a_id":@(aid)};
    
    [self startActionLoading:@"点赞中..."];
    [NetWorkTools POST:API_ARTICLE_ZAN params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        SHOW_HINT(@"点赞成功");
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
    
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F0F5F8'"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333'"];
    [self endLoading];
}

@end
