//
//  TextViewViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "TextViewViewController.h"

@interface TextViewViewController ()<UITextViewDelegate>
{
    UITextView * _valueTextView;
    UILabel      * _placeHolder;
}
@end

@implementation TextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.VCTitle;
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"保存",saveSubmit)
    
    //创建视图
    [self createView];
}

//创建视图
-(void)createView {
    
//    //创建输入容器框
//    UIView * inputBox = [UIView ViewInitWith:^(UIView *view) {
//        view
//        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,12,D_WIDTH - CARD_MARGIN_LEFT *2,200))
//        .L_ShadowColor([UIColor grayColor])
//        .L_shadowOffset(CGSizeMake(2,2))
//        .L_shadowOpacity(0.2)
//        .L_radius(5)
//        .L_AddView(self.view);
//    }];
//
    
    
    
    NSString * inputStr = @"";
    if(self.defaultStr == nil || [self.defaultStr isEqualToString:@""]  || [self.defaultStr isEqualToString:@"点击设置"]){
        inputStr = @"";
        
    }else{
        inputStr = self.defaultStr;
    
    }
    

    //创建textview输入框
    _valueTextView  = [[UITextView alloc] initWithFrame:CGRectMake(CARD_MARGIN_LEFT,15,D_WIDTH - CARD_MARGIN_LEFT *2,200)];
    _valueTextView.delegate            = self;
    _valueTextView.returnKeyType       = UIReturnKeyDone;
    _valueTextView.font = [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE];
    _valueTextView.layer.cornerRadius = 5;
    _valueTextView.layer.shadowOffset = CGSizeMake(2,2);
    _valueTextView.layer.shadowOpacity = 0.5;
    _valueTextView.text              = inputStr;
    _valueTextView.layer.borderWidth = 1;
    _valueTextView.layer.borderColor = HEX_COLOR(@"#EEEEEE").CGColor;
    _valueTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_valueTextView];
    
    //模拟placeholder
    _placeHolder = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(5,5,150,20))
        .L_Text(self.VCTitle)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_AddView(_valueTextView);
    }];
    _placeHolder.hidden = YES;
    
    
    [_valueTextView becomeFirstResponder];
    
}

#pragma mark - 代理事件处理
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeHolder.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length <= 0){
        _placeHolder.hidden = NO;
    }
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

-(void)saveSubmit {
    
    
    NSString * inputValue = _valueTextView.text;
    
    if([inputValue isEqualToString:@""]){
        return;
    }
    
    [self.view endEditing:YES];
    
    
    //发送数据通知信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INPUT_RESULT_VALUE" object:self userInfo:@{@"inputValue":inputValue,@"inputTag":@(self.inputTag)}];
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}
@end
