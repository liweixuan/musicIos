//
//  CreateAskViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CreateAskViewController.h"
#import "TagLabel.h"

@interface CreateAskViewController ()
{
    UITextField    * _tagInput;
    UILabel        * _maxHint;
    UIView         * _tagBox;
    
    NSMutableArray * _tagArr;
}
@end

@implementation CreateAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加要求";
    
    //初始化变量
    [self initVar];
    
    //创建导航右侧按钮
    [self createNav];
    
    //创建输入框
    [self createInputView];
    
    //预览显示标签容器
    [self createTagBox];
    
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
        .L_Placeholder(@"要求内容")
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
        .L_Text(@"最多为20个字")
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
    
    
    //是否有默认需要创建的标签
    if(self.nowTags != nil && ![self.nowTags isEqualToString:@"点击设置"]){
        
        NSArray * askArr = [self.nowTags componentsSeparatedByString:@"|"];
        
        for(int i = 0;i<askArr.count;i++){
            
            [_tagArr addObject:askArr[i]];

            
        }
        
        [self createTag];
        
        
        
    }
    
    
}


-(void)addTagClick {
    
    if(_tagInput.text.length <= 0){
        SHOW_HINT(@"内容不能为空")
        [self.view endEditing:YES];
        return;
    }
    
    if(_tagInput.text.length > 20){
        SHOW_HINT(@"已超过要求限制的字数")
        [self.view endEditing:YES];
        return;
    }
    
    NSString * tagValue = _tagInput.text;
    
    if(![_tagArr containsObject: tagValue]){
        [_tagArr addObject:tagValue];
    }
    
    
    [self createTag];
    
}

-(void)createTag {
    
    CGFloat nowY = 0.0;
    
    for(int i =0;i<_tagArr.count;i++){
        

        //创建UILabel
        TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(0,nowY,[_tagBox width],36)];
        tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        tagLabel.userInteractionEnabled = YES;
        tagLabel.text = _tagArr[i];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 18;
        tagLabel.insets = UIEdgeInsetsMake(0,15, 0,36);
        [_tagBox addSubview:tagLabel];
        
        nowY = [tagLabel bottom] + 10;


        //删除按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake([tagLabel right] - 30, [tagLabel top]+8,20,20))
            .L_BtnImageName(@"shanchu",UIControlStateNormal)
            .L_TargetAction(self,@selector(deleteTagClick:),UIControlEventTouchUpInside)
            .L_tag(i)
            .L_AddView(_tagBox);
        } buttonType:UIButtonTypeCustom];

        
    }
    
    [_tagBox setHeight:_tagArr.count * 40];
    
    _tagInput.text = @"";
    
}

-(void)deleteTagClick:(UIButton *)sender {
    
    NSInteger tagv = sender.tag;
    
    NSLog(@"####%ld",(long)tagv);
    
    
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
        SHOW_HINT(@"未添加任何要求")
        [self.view endEditing:YES];
        return;
    }
    
    //向上一个控制器传值
    NSString * tagStr = [_tagArr componentsJoinedByString:@"|"];
    
    //向控制器发送数据通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INPUT_RESULT_VALUE" object:self userInfo:@{@"inputValue":tagStr,@"inputTag":@(self.inputTag)}];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
