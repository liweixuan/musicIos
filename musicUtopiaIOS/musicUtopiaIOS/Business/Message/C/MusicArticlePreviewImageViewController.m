//
//  MusicArticlePreviewImageViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MusicArticlePreviewImageViewController.h"
#import "PhotoView.h"
#import "MusicArticleCommentViewController.h"
#import "CustomNavigationController.h"

@interface MusicArticlePreviewImageViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    UIScrollView  * _imageViewScrollView;  //图片展现视图
    UIScrollView  * _mainScrollBox;        //总滚动容器视图
    UIView        * _popView;
    UIPageControl * _pageControl;
    UIView        * _boxMaskView;     //总遮罩
    UIView        * _photoMenuView;   //图片菜单操作视图
    
    NSString      * _nowImageUrl;   //长按后准备进行操作的图片（保存系统相册）
    
    UIView           * _replyView;
    UITextView       * _inputTextView;
    UILabel          * _inputPlaceholderLabel;
    CGFloat            _inputTextViewHeight;
    CGFloat            _keyboardHeight;
    UIView           * _maskView;   //遮罩
    NSInteger          _replyMode;  //0-回复动态 1-回复动态评论
    NSInteger          _replyUid;   //被回复人ID
}
@end

@implementation MusicArticlePreviewImageViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    //创建总滑动容器视图
    [self mainScrollBox];
    
    //创建图片展示视图
    [self createImageViewScrollView];
    
    //创建分页控件
    [self bottomToolView];
    
    //创建分享按钮
    [self createNavBtn];
    
    //创建返回按钮
    [self popButton];
    
    
    [self createNoti];
    
    //创建图片操作弹出框
    [self createPhotoMenuView];
    
    
    //创建总遮罩视图
    [self createMaskView];
 
}


-(void)createNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)createNavBtn {
    UIImageView * shareBtn = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH - 15 - MIDDLE_ICON_SIZE,30,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_Event(YES)
        .L_Click(self,@selector(shareBtnClick))
        .L_ImageName(@"fenxiang")
        .L_AddView(self.view);
    }];
}

//分享事件
-(void)shareBtnClick {
    NSLog(@"分享");
}

//创建底部回复框
-(void)bottomToolView {
    
    _replyView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT - 50,D_WIDTH,50))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor whiteColor])
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

#pragma mark - 创建图片展示视图
-(void)createImageViewScrollView {
    
    
    //创建图片展示
    for(int i=0;i<self.imageArr.count;i++){
        
        UIScrollView * imageViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*D_WIDTH,0,D_WIDTH,D_HEIGHT)];
        imageViewScrollView.pagingEnabled = YES;
        imageViewScrollView.backgroundColor = [UIColor blackColor];
        imageViewScrollView.delegate = self;
        imageViewScrollView.bounces = NO;
        imageViewScrollView.showsHorizontalScrollIndicator = NO;
        imageViewScrollView.showsVerticalScrollIndicator = NO;
        [_mainScrollBox addSubview:imageViewScrollView];
        
        NSDictionary * dictData = self.imageArr[i];
        
        NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"ai_img_url"]];
        NSLog(@"%@",imageURL);
        PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,imageViewScrollView.frame.size.width,imageViewScrollView.frame.size.height) andImage:imageURL dataType:URL_TYPE imgData:nil];
        
        //长按手势
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClicked:)];
        
        [photoView addGestureRecognizer:longTap];
        
        [imageViewScrollView addSubview:photoView];
        
        //}
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        tap.delegate = self;
        [imageViewScrollView addGestureRecognizer:tap];
        
        //双击手势（为了阻拦双击会产生单击事件）
        UITapGestureRecognizer * doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [tap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
        [imageViewScrollView addGestureRecognizer:doubleTap];
        
        imageViewScrollView.contentSize = CGSizeMake(D_WIDTH,imageViewScrollView.frame.size.height);
        imageViewScrollView.contentOffset = CGPointMake(0,0);
        
        
        
        //创建图片说明标题
        UIView * imageTitleView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(0,D_HEIGHT - 150,D_WIDTH,150))
            .L_BgColor([UIColor blackColor])
            .L_Alpha(0.5)
            .L_AddView(imageViewScrollView);
        }];
        
        //计数
        UILabel * titleCount = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(10,8,30,20))
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
            .L_Text([NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArr.count])
            .L_AddView(imageTitleView);
        }];
        
        //图片内容
        UILabel * imageContent = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(10,[titleCount bottom]+10,D_WIDTH-20,130))
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor([UIColor whiteColor])
            .L_numberOfLines(0)
            .L_Text(dictData[@"ai_content"])
            .L_AddView(imageTitleView);
        }];
        
        [imageContent sizeToFit];

    }
    
    
    _mainScrollBox.contentOffset = CGPointMake(0,0);
    
    
}

-(void)createUIPageControl {
    
    if(self.imageArr.count > 1){
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, D_HEIGHT - 50, D_WIDTH,50)];
        _pageControl.numberOfPages = self.imageArr.count;
        _pageControl.currentPage   = self.imageIdx;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        [self.view addSubview:_pageControl];
        
    }
    
    
    
}

//创建总滑动容器视图
-(void)mainScrollBox {
    _mainScrollBox = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _mainScrollBox.bounces = NO;
    _mainScrollBox.pagingEnabled = YES;
    _mainScrollBox.delegate = self;
    _mainScrollBox.showsHorizontalScrollIndicator = NO;
    _mainScrollBox.showsVerticalScrollIndicator   = NO;
    _mainScrollBox.contentSize = CGSizeMake(D_WIDTH*self.imageArr.count,D_HEIGHT);
    [self.view addSubview:_mainScrollBox];
}

//-(void)createMaskView {
//    _boxMaskView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
//    _boxMaskView.backgroundColor = RGB_COLOR_OPACITY(0,0,0,0.4);
//    _boxMaskView.hidden = YES;
//    [self.view addSubview:_boxMaskView];
//    
//    //遮罩单击手势
//    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapClicked)];
//    [_boxMaskView addGestureRecognizer:maskTap];
//}

-(void)createPhotoMenuView {
    _photoMenuView = [[UIView alloc] initWithFrame:CGRectMake(0,D_HEIGHT,D_WIDTH,105)];
    _photoMenuView.backgroundColor = RGB_COLOR(200,200,200);
    [self.view addSubview:_photoMenuView];
    
    UIButton *savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savePhotoBtn setTitle:@"保存" forState:UIControlStateNormal];
    [savePhotoBtn setTitleColor:RGB_COLOR(51,51,51) forState:UIControlStateNormal];
    savePhotoBtn.frame = CGRectMake(0,0,D_WIDTH,50);
    savePhotoBtn.backgroundColor = [UIColor whiteColor];
    [savePhotoBtn addTarget:self action:@selector(savePhotoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_photoMenuView addSubview:savePhotoBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB_COLOR(51,51,51) forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0,[savePhotoBtn bottom]+5,D_WIDTH,50);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_photoMenuView addSubview:cancelBtn];
}

-(void)maskTapClicked {
    _boxMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [_photoMenuView setY:D_HEIGHT];
    }];
}

-(void)savePhotoBtnClicked {
    
    
    UIImage *img = nil;
    if(self.imageType == 1){
        NSURL* imageurl = [NSURL URLWithString:[self.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
        NSData*  data = [NSData dataWithContentsOfURL:imageurl];//获取网咯图片数据
        img = [UIImage imageWithData:data];
    }else{
        img = self.imageData;
    }
    
    
    if(img!=nil){
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        
    }else{
        NSLog(@"保存失败,请重新尝试");
        [self cancelBtnClicked];
    }
    
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
    if(!error){
        SHOW_HINT(@"保存成功")
        
        [self cancelBtnClicked];
    }else{
        NSLog(@"保存失败,请重新尝试");
        [self cancelBtnClicked];
    }
}

-(void)cancelBtnClicked {
    _boxMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [_photoMenuView setY:D_HEIGHT];
    }];
}


#pragma mark - 创建展现图片
-(void)createImage {
    
    
    PhotoView *photoView;
    if(self.imageType == 1){
        photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,_imageViewScrollView.frame.size.width,_imageViewScrollView.frame.size.height) andImage:self.imgUrl dataType:URL_TYPE imgData:nil];
        
    }else if(self.imageType == 2){
        photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0,_imageViewScrollView.frame.size.width,_imageViewScrollView.frame.size.height) andImage:nil dataType:DATA_TYPE imgData:self.imageData];
        
    }
    
    
    //长按手势
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClicked:)];
    
    [photoView addGestureRecognizer:longTap];
    
    [_imageViewScrollView addSubview:photoView];
    
    //}
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [_imageViewScrollView addGestureRecognizer:tap];
    
    //双击手势（为了阻拦双击会产生单击事件）
    UITapGestureRecognizer * doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [tap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
    [_imageViewScrollView addGestureRecognizer:doubleTap];
    
    _imageViewScrollView.contentSize = CGSizeMake(0,_imageViewScrollView.frame.size.height);
    _imageViewScrollView.contentOffset = CGPointMake(0,0);
    
}

-(void)longTapClicked:(UILongPressGestureRecognizer *)longTap {
    if (longTap.state == UIGestureRecognizerStateBegan) {
        
        //PhotoView *pView = (PhotoView *)longTap.view;
        //_nowImageUrl = pView.imageurl;
        
        _boxMaskView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [_photoMenuView setY:D_HEIGHT-105];
        }];
        
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    NSLog(@"双击...");
}

-(void)tapClicked:(UITapGestureRecognizer *)tap {
    //_popView.hidden = !_popView.hidden;
    
    NSLog(@"单击.....");
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建返回按钮
-(void)popButton {
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,64)];
    _popView.hidden = YES;
    _popView.backgroundColor = RGB_COLOR_OPACITY(201,201,201,0.2);
    [self.view addSubview:_popView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5,64/2-30/2+10,30,30);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:backBtn];
}

#pragma mark - 返回按钮点击时
-(void)backBtnClicked {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前移动的位置
    CGFloat scrollNowX = scrollView.contentOffset.x;
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = (int)scrollNowX / D_WIDTH;
    
    _pageControl.currentPage = nowIdx;
    
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

-(void)messageSend:(NSString *)msg {
    
    //判断回复的类型
    NSDictionary * params = [NSDictionary dictionary];
    NSString     * apiUrl = @"";
    
    if(_replyMode == 0){
        
        apiUrl = API_ARTICLE_REPLY;
        
        //发布动态评论信息
        params = @{
                   @"ac_uid"     : @([UserData getUserId]),
                   @"ac_aid"     : @(self.aid),
                   @"ac_content" : msg
                   };
        
        
    }else{
        
        apiUrl = API_ARTICLE_REPLY_COMMENT;
        
        //发布动态回复评论信息
        params = @{
                   
                   @"ac_uid"       : @([UserData getUserId]),
                   @"ac_aid"       : @(self.aid),
                   @"ac_content"   : msg,
                   @"ac_reply_uid" : @(_replyUid)
                   };
        
    }
    
    
    
    [self startActionLoading:@"评论发布中..."];
    
    [NetWorkTools POST:apiUrl params:params successBlock:^(NSArray *array) {
        
        [self endActionLoading];
        
        SHOW_HINT(@"评论发布成功");
        [self maskBoxClick];
 
    } errorBlock:^(NSString *error) {
        SHOW_HINT(error);
    }];
    
    
    
}

-(void)showCommentClick {
    NSLog(@"查看评论");
    NSInteger aid = self.aid;
    
 
    MusicArticleCommentViewController * musicArticleCommentVC = [[MusicArticleCommentViewController alloc] init];
    musicArticleCommentVC.aid = aid;
    musicArticleCommentVC.isBack = YES;
    
    CustomNavigationController * customNav = [[CustomNavigationController alloc] initWithRootViewController:musicArticleCommentVC];

    [self presentViewController:customNav animated:YES completion:nil];
    
}

-(void)zanClick {
    
    NSInteger aid         = self.aid;
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
    [_replyView setY:D_HEIGHT - frame.size.height - [_replyView height]];
    
    [self showMaskView];
    
}

//创建遮罩
-(void)createMaskView {
    
    _maskView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT - 50))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.0)
        .L_Click(self,@selector(maskBoxClick))
        .L_AddView(self.view);
    }];
    
}

//显示遮罩
-(void)showMaskView {
    
    
    [_maskView setHeight:D_HEIGHT - _keyboardHeight - 50];
    [UIView animateWithDuration:0.4 animations:^{
        
        _maskView.alpha = 0.3;
    }];
}

//键盘将要隐藏
-(void)keyboardWillHidden:(NSNotification *)notification {
    [_inputTextView setHeight:40];
    [_replyView setHeight:50];
    [_replyView setY:D_HEIGHT - [_replyView height]];
}


//遮罩视图点击时
-(void)maskBoxClick {
    [self.view endEditing:YES];
    //[UIView animateWithDuration:0.4 animations:^{
        _maskView.alpha = 0.0;
    //}];
}
@end
