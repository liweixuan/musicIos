#import "MusicScoreDetailViewController.h"
#import "PhotoView.h"
#import "AppDelegate.h"

@interface MusicScoreDetailViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
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
    NSInteger          _nowShowMode;    //当前显示模式 0-竖向显示 1-横向显示
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
    //    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    //    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    //        [self hideTopAndBottomBox];
    //        _topAndBottomIsHide = YES;
    //    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乐谱详细";
 
    [self startLoading];
    
    //初始化变量
    [self initVar];
    
//    //创建滚动容器
//    [self createScrollBox];
//    
//    //创建图片视图
//    [self createImageView];
//    
//    //顶部菜单容器
//    [self createTopView];
//    
//    //底部菜单容器
//    [self createBottomView];
//    
//    //创建显示模式选择视图
//    [self createShowModeView];

    //初始化数据
    [self initData];
    
}

//初始化变量
-(void)initVar {
    
    _topAndBottomIsHide = NO;
    
    _imageViewArr = [NSMutableArray array];
    
   // _imageData = @[@"http://musicalinstrumentutopia.oss-cn-qingdao.aliyuncs.com/musicScore/puzi_1.jpg",@"http://musicalinstrumentutopia.oss-cn-qingdao.aliyuncs.com/musicScore/puzi_2.jpg",@"http://musicalinstrumentutopia.oss-cn-qingdao.aliyuncs.com/musicScore/puzi_3.jpg"];
    
    //_imageData = @[[UIImage imageNamed:@"puzi_1.jpg"],[UIImage imageNamed:@"puzi_2.jpg"],[UIImage imageNamed:@"puzi_3.jpg"]];
    
    _imageData = [NSArray array];
    
    _nowShowMode  = 0;
    
}

//初始化数据
-(void)initData {
    
    //获取曲谱详细
    NSArray * params = @[@{@"key":@"ms_id",@"value":@(self.musicScoreId)}];
    NSString * url   = [G formatRestful:API_MUSIC_SCORE_DETAIL Params:params];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
 
        _imageData = array;

        
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
        
        //关闭遮罩
        [self endLoading];
        
        
  
    } errorBlock:^(NSString *error) {
        [self endLoading];
        SHOW_HINT(error);
    }];
    
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
    
    
    _mainScrollView.contentSize = CGSizeMake(D_WIDTH,D_HEIGHT*_imageData.count);
    _mainScrollView.delegate = self;

    
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    NSLog(@"双击...");
}

-(void)tapClicked:(UITapGestureRecognizer *)tap {
    //_popView.hidden = !_popView.hidden;
    
    NSLog(@"单击.....");
    
    if(_topAndBottomIsHide){
        
        [self showTopAndBottonBox];
        
    }else{
        
        [self hideTopAndBottomBox];
        
    }
    
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
        
        NSDictionary * dictData = _imageData[i];
        
        
        UIScrollView * imageViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,i*D_HEIGHT,D_WIDTH,itemH)];
        imageViewScrollView.pagingEnabled = YES;
        imageViewScrollView.backgroundColor = [UIColor blackColor];
        imageViewScrollView.delegate = self;
        imageViewScrollView.bounces = NO;
        imageViewScrollView.showsHorizontalScrollIndicator = NO;
        imageViewScrollView.showsVerticalScrollIndicator = NO;
        [_mainScrollView addSubview:imageViewScrollView];
        
        [_imageViewArr addObject:imageViewScrollView];
        

        NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"msi_url"]];
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
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [tap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
        [imageViewScrollView addGestureRecognizer:doubleTap];
        
        imageViewScrollView.contentSize = CGSizeMake(D_WIDTH,imageViewScrollView.frame.size.height);
        imageViewScrollView.contentOffset = CGPointMake(0,0);
        

    }

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
    [UILabel LabelinitWith:^(UILabel *la) {
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
    
    //收藏
    UIImageView * collectIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(@"shoucang")
        .L_Event(YES)
        .L_Click(self,@selector(collectBtnClick))
        .L_AddView(topActionBox);
    }];
    
    //分享按钮
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([collectIcon right]+CONTENT_PADDING_LEFT,0, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(@"fenxiang")
        .L_Event(YES)
        .L_Click(self,@selector(shareBtnClick))
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
        .L_ImageName(@"miaoshu")
        .L_AddView(_bottomBox);
    }];
    
    //文字描述
    UILabel * musicScoreHint = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([onePageBtn right]+ICON_MARGIN_CONTENT, [onePageBtn top]+5,145,SUBTITLE_FONT_SIZE))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_Text(@"去看看，该曲谱的知识")
        .L_isEvent(YES)
        .L_Click(self,@selector(showMusicScoreDetail:))
        .L_TextColor([UIColor whiteColor])
        .L_AddView(_bottomBox);
    }];
    
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([musicScoreHint right]+5,[_bottomBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
        .L_ImageName(@"fanhui")
        .L_AddView(_bottomBox);
    }];
    

    //设置按钮
    [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([_bottomBox width]-CONTENT_PADDING_LEFT-BIG_ICON_SIZE,[_bottomBox height]/2 - BIG_ICON_SIZE/2, BIG_ICON_SIZE, BIG_ICON_SIZE))
        .L_ImageName(@"shezhi")
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
//收藏
-(void)collectBtnClick {
    NSLog(@"收藏...");
    
    NSDictionary * params = @{@"ms_id":@(self.musicScoreId),@"u_id":@([UserData getUserId])};
    
    [self startActionLoading:@"收藏中..."];
    [NetWorkTools POST:API_COLLECT_MUSIC_SCORE params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        SHOW_HINT(@"曲谱已收藏");
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
}


//查看谱子详细
-(void)showMusicScoreDetail:(UITapGestureRecognizer *)tap {
    NSLog(@"查看谱子详细");
}


//分享
-(void)shareBtnClick {
    NSLog(@"分享...");
}

//长按
-(void)longTapClicked:(UILongPressGestureRecognizer *)longTap {
    NSLog(@"长按...");
}

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
        
        UIScrollView * itemView = _imageViewArr[i];
        
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
    
    _nowShowMode = 0;
    
    _pageLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_imageData.count];
    
    [self closeSettingModeView];
    [self mainScrollClick];

}

-(void)hViewClick {

    for(int i =0 ;i<_imageViewArr.count;i++){
        
        UIScrollView * itemView = _imageViewArr[i];
        
        [itemView setX:i * [itemView width]];
        [itemView setY:0];

    }
    

    _mainScrollView.contentSize   = CGSizeMake(D_WIDTH*_imageViewArr.count,D_HEIGHT);
    _mainScrollView.pagingEnabled =  YES;
    
    
    _nowShowMode = 1;
    
    _pageLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_imageData.count];
    
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {


    //获取当前移动的位置
    
    CGFloat scrollNowX = 0.0;
    if(_nowShowMode == 0){
        scrollNowX = scrollView.contentOffset.y;
    }else{
        scrollNowX = scrollView.contentOffset.x;
    }
    
    
    //获取当前滚动到第几个视图
    NSInteger nowIdx = 0;
    if(_nowShowMode == 0){
        nowIdx = (int)scrollNowX / D_HEIGHT;
    }else{
        nowIdx = (int)scrollNowX / D_WIDTH;
    }

    _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(nowIdx+1),(unsigned long)_imageData.count];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideTopAndBottomBox];
}
@end
