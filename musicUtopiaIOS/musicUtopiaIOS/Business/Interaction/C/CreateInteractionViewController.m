#import "CreateInteractionViewController.h"
#import "SelectMusicCategoryViewController.h"
#import "CreateTagViewController.h"

@interface CreateInteractionViewController ()<UITextViewDelegate>
{
    UIView       * _dynamicInputView;
    UIView       * _uploadView;
    UILabel      * _placeHolder;
    UIScrollView * _scrollBoxView;
}
@end

@implementation CreateInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    
    //初始化
    [self initVar];
    
    //设置滚动父容器
    [self createScrollView];
    
    //创建右侧按钮
    [self createNavigationRightBtn];
    
    //创建动态内容输入
    [self createDynamicInputBox];
    
    //上传图片，音频，视频视图
    [self createUploadView];
    
    //创建选项列表
    [self createSelectItemView];
    
    
    
}

-(void)initVar {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 视图创建
//滚动父容器创建
-(void)createScrollView {
    
    _scrollBoxView = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
       
        view
        .L_Frame(self.view.frame)
        .L_contentSize(CGSizeMake(D_WIDTH,1000))
        .L_AddView(self.view);
        
    }];
}


-(void)createDynamicInputBox {
    
    _dynamicInputView = [UIView ViewInitWith:^(UIView *view) {
       
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT*2,220))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);

    }];
    
    //创建textview输入框
    UITextView * dynamicTextView  = [[UITextView alloc] initWithFrame:CGRectMake(5,0,[_dynamicInputView width]-10,220)];
    dynamicTextView.delegate      = self;
    dynamicTextView.returnKeyType = UIReturnKeyDone;
    [_dynamicInputView addSubview:dynamicTextView];
    
    //模拟placeholder
    _placeHolder = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(5,5,100,20))
        .L_Text(@"想和大家分享什么")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Font(12)
        .L_AddView(dynamicTextView);
    }];
    
    //分割线
    UIView * lineView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,150,[_dynamicInputView width],1))
        .L_BgColor(HEX_COLOR(MIDDLE_LINE_COLOR))
        .L_AddView(_dynamicInputView);
    }];
    
    //类型选择视图
    UIView * typeViewBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(5,[lineView bottom],[_dynamicInputView width]-10,69))
        .L_AddView(_dynamicInputView);
    }];
    
    //创建四种类型的图标
    NSArray * sendType = @[ICON_DEFAULT,ICON_DEFAULT,ICON_DEFAULT,ICON_DEFAULT];
    
    for(int i =0;i<sendType.count;i++) {

        CGFloat sendW = [_dynamicInputView width]/sendType.count;
        
        [UIButton ButtonInitWith:^(UIButton *btn) {
            
            btn
            .L_Frame(CGRectMake(i * sendW + (sendW/2 - 35/2),[typeViewBox height]/2 - 35/2, 35, 35))
            .L_BgColor([UIColor orangeColor])
            .L_BtnImageName(ICON_DEFAULT,UIControlStateNormal)
            .L_AddView(typeViewBox);
        
        } buttonType:UIButtonTypeCustom];
        
        
    }
    
}

//上传图片，音频，视频视图
-(void)createUploadView {
    
    _uploadView = [UIView ViewInitWith:^(UIView *view) {
        
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_dynamicInputView bottom] + CARD_MARGIN_TOP,D_WIDTH - CARD_MARGIN_LEFT*2,90))
        .L_BgColor([UIColor whiteColor])
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOffset(CGSizeMake(2,2))
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(_scrollBoxView);
        
    }];
    
}

//创建选项列表
-(void)createSelectItemView {
    
    NSArray * selectArr = @[@"动态分类",@"动态标签"];
    
    CGFloat sy = [_uploadView bottom] + 20;
    
    for(int i =0;i<selectArr.count;i++){

        UIView * selectView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,sy,D_WIDTH - CARD_MARGIN_LEFT*2,NORMAL_CELL_HIEGHT))
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_tag(i + 1)
            .L_Click(self,@selector(selectViewClick:))
            .L_radius_NO_masksToBounds(5)
            .L_AddView(_scrollBoxView);
        }];
        
        //标题
        [UILabel LabelinitWith:^(UILabel *la) {
            
            la
            .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,0,100,NORMAL_CELL_HIEGHT))
            .L_Text(selectArr[i])
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(SUBTITLE_FONT_COLOR))
            .L_AddView(selectView);
            
        }];
        
        //选择内容显示
        UILabel * selectedValue = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([selectView width] - 200,0,150,[selectView height]))
            .L_textAlignment(NSTextAlignmentRight)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_Text(@"请选择")
            .L_AddView(selectView);
        }];
        
        //右侧箭头ICON
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake([selectedValue right] + (50/2 - MIDDLE_ICON_SIZE/2),[selectView height]/2 - MIDDLE_ICON_SIZE /2,MIDDLE_ICON_SIZE,MIDDLE_ICON_SIZE))
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(selectView);
        }];
        
        sy = [selectView bottom] + 5;
        
    }
    
    //设置SCROLL的内容高度
    [_scrollBoxView setContentSize:CGSizeMake(D_WIDTH,sy + 10)];
    
    
}

-(void)createNavigationRightBtn {
    
    R_NAV_TITLE_BTN(@"R",@"发布",sendDynamicBtn)
    
}


#pragma mark - 事件处理
-(void)sendDynamicBtn {
    NSLog(@"右侧按钮...");
}

//选择视图点击事件
-(void)selectViewClick:(UITapGestureRecognizer *)tap {
    
    NSInteger TAG = tap.view.tag;
    
    //选择分类
    if(TAG == 1){
        
        PUSH_VC(SelectMusicCategoryViewController, YES, @{});
        
    //选择标签
    }else{
        
        PUSH_VC(CreateTagViewController, YES, @{});
        
    }
    
}

#pragma mark - 代理事件处理
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeHolder.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        
        if (textView.text.length<1) {
            _placeHolder.hidden = NO;
        }
        
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}

@end
