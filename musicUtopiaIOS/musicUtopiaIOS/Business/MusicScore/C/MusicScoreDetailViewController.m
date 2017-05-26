#import "MusicScoreDetailViewController.h"
#import "PhotoView.h"

@interface MusicScoreDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView     * _mainScrollView;
    NSArray          * _imageData;
    UIView           * _topBox;
    UIView           * _bottomBox;
    UIView           * _showModeSelectView;
    UIView           * _showSelectView;
    UILabel          * _pageLabel;
    
    BOOL               _topAndBottomIsHide;
    
    NSMutableArray   * _imageViewArr;   //图片对象数组
}
@end

@implementation MusicScoreDetailViewController

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置延迟操作定时器
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self hideTopAndBottomBox];
        _topAndBottomIsHide = YES;
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乐谱详细";
    
    //初始化变量
    [self initVar];
    
    //初始化数据
    [self initData];
    
    //创建滚动容器
    [self createScrollBox];
    
    //创建图片视图
    [self createImageView];
    
    //顶部菜单容器
    [self createTopView];
    
    //底部菜单容器
    [self createBottomView];
    
    //创建显示模式选择视图
    [self createShowModeView];
}

//初始化变量
-(void)initVar {
    
    _topAndBottomIsHide = NO;
    
    _imageViewArr = [NSMutableArray array];
    
}

//初始化数据
-(void)initData {
    //_imageData = @[@"pu_1.jpg",@"pu_2.jpg",@"pu_3.jpg"];
    _imageData = @[@"puzi_1.jpg",@"puzi_2.jpg",@"puzi_3.jpg"];
}


//创建显示模式选择视图
-(void)createShowModeView {
    
    _showModeSelectView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_BgColor([UIColor blackColor])
        .L_Click(self,@selector(showModeViewClick))
        .L_Alpha(0.0)
        .L_AddView(self.view);
    }];
    
    _showSelectView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(20,D_HEIGHT/2 - 120/2,D_WIDTH - 20 *2,120))
        .L_BgColor([UIColor blackColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius(5)
        .L_Alpha(0.0)
        .L_AddView(self.view);
    }];
    
    
    //横线显示视图
    UIView * hView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,[_showSelectView width]/2,[_showSelectView height]))
        .L_Click(self,@selector(hViewClick))
        .L_AddView(_showSelectView);
    }];
    
    //图标
    UIImageView * hIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([hView width]/2 - 60/2,[hView height]/2 - 60/2 - 8,60,60))
        .L_ImageName(IMAGE_DEFAULT)
        .L_AddView(hView);
    }];
    
    //文字
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0, [hIcon bottom]+8, [hView width],SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor([UIColor whiteColor])
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"横向显示")
        .L_AddView(hView);
    }];
    
    
    //分割线
    UIView * middleLine = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake([hView right]-1,[hView height]/2 - 80/2, 1,80))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(hView);
    }];
    
    //竖向显示视图
    UIView * vView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake([_showSelectView width]/2,0,[_showSelectView width]/2,[_showSelectView height]))
        .L_Click(self,@selector(vViewClick))
        .L_AddView(_showSelectView);
    }];
    
    //图标
    UIImageView * vIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([hView width]/2 - 60/2,[vView height]/2 - 60/2 - 8,60,60))
        .L_ImageName(IMAGE_DEFAULT)
        .L_AddView(vView);
    }];
    
    //文字
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0, [vIcon bottom]+8, [vView width],SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TextColor([UIColor whiteColor])
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"竖向显示")
        .L_AddView(vView);
    }];
    
}

//创建滚动容器
-(void)createScrollBox {
    
    _mainScrollView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,0,[self.view width],D_HEIGHT))
        .L_bounces(NO)
        .L_BgColor([UIColor blackColor])
        .L_showsVerticalScrollIndicator(NO)
        .L_showsHorizontalScrollIndicator(NO)
        .L_AddView(self.view);
    }];
    
    _mainScrollView.delegate = self;

    //设置单击
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainScrollClick)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [_mainScrollView addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [_mainScrollView addGestureRecognizer:doubleTapGesture];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
}

//创建图片视图
-(void)createImageView {
    
    for(int i =0;i<_imageData.count;i++){
        
        //高度
        CGFloat itemH = 0.0;
        
        if(i != _imageData.count - 1){
            itemH = D_HEIGHT - 3;
        }else{
            itemH = D_HEIGHT;
        }
        
        //图片容器
        UIImage * image = [UIImage imageNamed:_imageData[i]];
        PhotoView * photoview = [[PhotoView alloc] initWithFrame:CGRectMake(0,i*D_HEIGHT,D_WIDTH,itemH) andImage:@"FULL" dataType:DATA_TYPE imgData:image];
        [_mainScrollView addSubview:photoview];
        
        
        [_imageViewArr addObject:photoview];

    }
    
    _mainScrollView.contentSize = CGSizeMake(D_WIDTH,D_HEIGHT*_imageData.count);
    
    
}

-(void)createTopView {
    _topBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,0,D_WIDTH,50))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.8)
        .L_AddView(self.view);
    }];
    
    //反回按钮
    UIImageView * backIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[_topBox height]/2 - MIDDLE_ICON_SIZE/2,MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE))
        .L_ImageName(@"back")
        .L_Event(YES)
        .L_Click(self,@selector(backClick))
        .L_AddView(_topBox);
    }];
    
    //页数显示
    _pageLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([backIcon right]+ICON_MARGIN_CONTENT,[backIcon top]+3,30,TITLE_FONT_SIZE))
        .L_Text([NSString stringWithFormat:@"1/%ld",(long)self.imageCount])
        .L_TextColor([UIColor whiteColor])
        .L_Font(TITLE_FONT_SIZE)
        .L_AddView(_topBox);
    }];
    
    //曲谱名称
    UILabel * nameLabel = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([_pageLabel right]+ICON_MARGIN_CONTENT,[_pageLabel top],200,TITLE_FONT_SIZE))
        .L_Text(self.musicScoreName)
        .L_Font(TITLE_FONT_SIZE)
        .L_TextColor([UIColor whiteColor])
        .L_AddView(_topBox);
    }];
    
    
    
    //操作按钮容器
    UIView * topActionBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake([_topBox width] - BIG_ICON_SIZE * 2 - CONTENT_PADDING_LEFT*2, [_topBox height]/2 - BIG_ICON_SIZE/2,BIG_ICON_SIZE*2+CONTENT_PADDING_LEFT,BIG_ICON_SIZE))
        .L_AddView(_topBox);
    }];
    
    //查看评论按钮
    UIImageView * showCommentIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(topActionBox);
    }];
    
    //分享按钮
    UIImageView * shareIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([showCommentIcon right]+CONTENT_PADDING_LEFT,0, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(topActionBox);
    }];
}

-(void)createBottomView {
    _bottomBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT - 50,D_WIDTH,50))
        .L_BgColor([UIColor blackColor])
        .L_Alpha(0.8)
        .L_AddView(self.view);
    }];
    
    //单页演奏示范
    UIImageView * onePageBtn =  [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,[_bottomBox height]/2 - BIG_ICON_SIZE/2, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_bottomBox);
    }];
    
    //文字描述
    UILabel * onePageTitle = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([onePageBtn right]+ICON_MARGIN_CONTENT, [onePageBtn top]+5,90,SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_Text(@"单页演奏示范")
        .L_TextColor([UIColor whiteColor])
        .L_AddView(_bottomBox);
    }];
    
    //整曲演奏示范
    UIImageView * allMusicScoreBtn =  [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([onePageTitle right]+ CONTENT_PADDING_LEFT,[_bottomBox height]/2 - BIG_ICON_SIZE/2, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_AddView(_bottomBox);
    }];
    
    //文字描述
    UILabel * allMusciScoreTitle = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([allMusicScoreBtn right]+ICON_MARGIN_CONTENT, [allMusicScoreBtn top]+5,90,SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_Text(@"整曲演奏示范")
        .L_TextColor([UIColor whiteColor])
        .L_AddView(_bottomBox);
    }];
    
    //设置按钮
    UIImageView * settingBtn =  [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_bottomBox width]-CONTENT_PADDING_LEFT-BIG_ICON_SIZE,[_bottomBox height]/2 - BIG_ICON_SIZE/2, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(ICON_DEFAULT)
        .L_Event(YES)
        .L_Click(self,@selector(settingClick))
        .L_AddView(_bottomBox);
    }];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//隐藏顶部于底部导航容器
-(void)hideTopAndBottomBox {
    [UIView animateWithDuration:0.3 animations:^{
        [_topBox setY:-[_topBox height]];
        [_bottomBox setY:D_HEIGHT];
    }];
    _topAndBottomIsHide = YES;
}

//显示顶部于底部导航容器
-(void)showTopAndBottonBox {
    [UIView animateWithDuration:0.3 animations:^{
        [_topBox setY:0];
        [_bottomBox setY:D_HEIGHT - [_bottomBox height]];
    }];
    _topAndBottomIsHide = NO;
}


#pragma mark - 事件
//反回按钮
-(void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mainScrollClick {

    if(_topAndBottomIsHide){
        
        [self showTopAndBottonBox];
        
    }else{
        
        [self hideTopAndBottomBox];
        
    }
}


-(void)vViewClick {

    for(int i =0 ;i<_imageViewArr.count;i++){
        
        UIView * itemView = _imageViewArr[i];
        
        //高度
        CGFloat itemH = 0.0;
        
        if(i != _imageViewArr.count - 1){
            itemH = D_HEIGHT - 3;
        }else{
            itemH = D_HEIGHT;
        }
        
        [itemView setX:0];
        [itemView setY:i * D_HEIGHT];
        [itemView setHeight:itemH];
        
    }
    
    
    _mainScrollView.contentSize   = CGSizeMake(D_WIDTH,D_HEIGHT*_imageViewArr.count);
    _mainScrollView.pagingEnabled =  NO;
    
    [self closeSettingModeView];
    [self mainScrollClick];

}

-(void)hViewClick {

    for(int i =0 ;i<_imageViewArr.count;i++){
        
        UIView * itemView = _imageViewArr[i];
        
        [itemView setX:i * [itemView width]];
        [itemView setY:0];

    }
    

    _mainScrollView.contentSize   = CGSizeMake(D_WIDTH*_imageViewArr.count,D_HEIGHT);
    _mainScrollView.pagingEnabled =  YES;
    
    
    [self closeSettingModeView];
    [self mainScrollClick];

}

//设置按钮
-(void)settingClick {
    [UIView animateWithDuration:0.3 animations:^{
        _showModeSelectView.alpha = 0.5;
        _showSelectView.alpha     = 0.7;
    }];

}

//关闭设置视图
-(void)closeSettingModeView {
    [UIView animateWithDuration:0.3 animations:^{
        _showModeSelectView.alpha = 0.0;
        _showSelectView.alpha     = 0.0;
    }];
}

//点击模式选择遮罩
-(void)showModeViewClick {
    [self closeSettingModeView];
}


#pragma mark - 代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滚动中...");
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"开始...");
    [self hideTopAndBottomBox];
}
@end
