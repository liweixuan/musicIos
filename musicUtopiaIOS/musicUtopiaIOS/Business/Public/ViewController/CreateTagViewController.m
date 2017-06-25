#import "CreateTagViewController.h"
#import "TagLabel.h"
#import "CreateInteractionViewController.h"

@interface CreateTagViewController ()
{
    UITextField * _tagInput;
    UILabel     * _maxHint;
    UIView      * _tagBox;
    
    NSMutableArray * _tagArr;
}
@end

@implementation CreateTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建标签";

    //初始化变量
    [self initVar];
    
    //创建导航右侧按钮
    [self createNav];
    
    //创建输入框
    [self createInputView];
    
    //预览显示标签容器
    [self createTagBox];
    
    [self initCreateTag];
    
}

-(void)initVar {
    _tagArr = [NSMutableArray array];
}


//创建导航右侧按钮
-(void)createNav {
    
    R_NAV_TITLE_BTN(@"R",@"保存",saveTag)
    
}

-(void)createInputView {
    
    //昵称输入框
    _tagInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,20,D_WIDTH - CARD_MARGIN_LEFT *2,TEXTFIELD_HEIGHT))
        .L_Placeholder(@"标签名称")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_PaddingLeft(15)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    }];
    
    //添加按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_tagInput right] - 50, [_tagInput top],50,TEXTFIELD_HEIGHT))
        .L_Title(@"添加",UIControlStateNormal)
        .L_Font(CONTENT_FONT_SIZE)
        .L_TargetAction(self,@selector(addTagClick),UIControlEventTouchUpInside)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
    //提示文字
    _maxHint = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake([_tagInput left]+5,[_tagInput bottom]+10,200,ATTR_FONT_SIZE))
        .L_Text(@"最多为6个字")
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
}


-(void)createTagBox {
    
    _tagBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake([_tagInput left]+2,[_maxHint bottom]+10,[_tagInput width],40))
        .L_AddView(self.view);
    }];
    
    
}


-(void)addTagClick {
    
    if(_tagInput.text.length <= 0){
        SHOW_HINT(@"内容不能为空")
        [self.view endEditing:YES];
        return;
    }
    
    if(_tagInput.text.length > 6){
        SHOW_HINT(@"已超过标签限制的字数")
        [self.view endEditing:YES];
        return;
    }
    
    if(_tagArr.count >= 3){
        SHOW_HINT(@"标签数已满")
        [self.view endEditing:YES];
        return;
    }
    
    NSString * tagValue = _tagInput.text;
    
    if(![_tagArr containsObject: tagValue]){
        [_tagArr addObject:tagValue];
    }else{
        SHOW_HINT(@"该标签已存在")
        [self.view endEditing:YES];
        return;
    }
    
    
    [self createTag];
  
}

-(void)initCreateTag {
    NSArray * tagArrData = [NSArray array];
    if(![self.defaultTags isEqualToString:@""] && self.defaultTags != nil){
        tagArrData = [self.defaultTags componentsSeparatedByString:@"|"];
    }
    
    _tagArr = [tagArrData mutableCopy];
    
    CGFloat nowX = 0.0;
    
    for(int i =0;i<tagArrData.count;i++){
        
        //内容大小
        CGSize s = [G labelAutoCalculateRectWith:tagArrData[i] FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(1000, 1000)];
        
        //创建UILabel
        TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(nowX,5,s.width + 30 + 15,30)];
        tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        tagLabel.text = tagArrData[i];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 15;
        tagLabel.insets = UIEdgeInsetsMake(0,15, 0,30);
        [_tagBox addSubview:tagLabel];
        
        //X轴位置变化
        nowX += s.width + 30 + 10 + 15;
        
        //删除按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake([tagLabel right] - 25, [tagLabel top]+5,20,20))
            .L_BtnImageName(@"shanchu",UIControlStateNormal)
            .L_TargetAction(self,@selector(deleteTagClick:),UIControlEventTouchUpInside)
            .L_tag(i)
            .L_AddView(_tagBox);
        } buttonType:UIButtonTypeCustom];
        
    }
    
    _tagInput.text = @"";
}

-(void)createTag {
    

    CGFloat nowX = 0.0;
    
    for(int i =0;i<_tagArr.count;i++){
        
        //内容大小
        CGSize s = [G labelAutoCalculateRectWith:_tagArr[i] FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(1000, 1000)];
        
        //创建UILabel
        TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(nowX,5,s.width + 30 + 15,30)];
        tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        tagLabel.text = _tagArr[i];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 15;
        tagLabel.insets = UIEdgeInsetsMake(0,15, 0,30);
        [_tagBox addSubview:tagLabel];
        
        //X轴位置变化
        nowX += s.width + 30 + 10 + 15;
        
        //删除按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake([tagLabel right] - 25, [tagLabel top]+5,20,20))
            .L_BtnImageName(@"shanchu",UIControlStateNormal)
            .L_TargetAction(self,@selector(deleteTagClick:),UIControlEventTouchUpInside)
            .L_tag(i)
            .L_AddView(_tagBox);
        } buttonType:UIButtonTypeCustom];
        
    }
    
    _tagInput.text = @"";
}

-(void)deleteTagClick:(UIButton *)sender {
    
    NSInteger tagv = sender.tag;

    
    //删除数组中的当前元素
    [_tagArr removeObjectAtIndex:tagv];
    
    //删除原有标签
    for(UIView *view in [_tagBox subviews]){
        [view removeFromSuperview];
    }
    
    //重新创建标签
    [self createTag];
    
}


-(void)saveTag {
    
    if(_tagArr.count <= 0){
        SHOW_HINT(@"未添加任何标签")
        [self.view endEditing:YES];
        return;
    }
    
    //向上一个控制器传值
    NSString * tagStr = [_tagArr componentsJoinedByString:@"|"];
    
    //@"CreatePartnerVC" 
    
    //向控制器发送数据通知
    [[NSNotificationCenter defaultCenter] postNotificationName:self.TAG_NAME object:self userInfo:@{@"tagStr":tagStr}];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
