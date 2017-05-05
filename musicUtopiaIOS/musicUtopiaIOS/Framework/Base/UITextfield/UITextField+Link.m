
#import "UITextField+Link.h"

@implementation UITextField (Link)

+(instancetype)TextFieldInitWith:(void (^)(UITextField *))initblock{
    UITextField *text = [[UITextField alloc]init];
    if (initblock) {
        initblock(text);
    }
    return text;
}

-(UITextField *(^)(NSString *))L_Text {
    return ^UITextField *(NSString * str){
        self.text = str;
        return self;
    };
}

-( UITextField *(^)(CGRect))L_Frame{
    return  ^UITextField*(CGRect rect){
        self.frame = rect;
        return self;
        
    };
    
}

-(UITextField *(^)(UIColor *))L_BgColor{
    
    return  ^UITextField *(UIColor *color){
        
        self.backgroundColor = color;
        
        return self;
    };
}

-(UITextField *(^)(NSString *))L_Placeholder{
    return  ^UITextField *(NSString *placeHolder){
        self.placeholder = placeHolder;
        
        return self;
    };
    
}

-(UITextField *(^)(NSInteger))L_Font{
    return  ^UITextField *(NSInteger font){
        self.font = [UIFont systemFontOfSize:font];
        return self;
    };
    
}

-(UITextField *(^)(UIColor *))L_TextColor{
    
    return ^UITextField *(UIColor *color){
        self.textColor = color;
        return self;
    };
    
}

-(UITextField *(^)(NSInteger))L_textAlignment{
    return  ^UITextField *(NSInteger textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}

-(UITextField *(^)(BOOL))L_Secure{
    return ^UITextField *(BOOL secure){
        self.secureTextEntry = secure;
        return self;
    };
}

-(UITextField *(^)(NSInteger))L_Keyboard{
    return ^UITextField *(NSInteger keyboardType){
        self.keyboardType = keyboardType;
        return self;
    };
    
}

-(UITextField *(^)(NSInteger))L_ReturnKey{
    return ^UITextField *(NSInteger returnKeyDone){
        self.returnKeyType = returnKeyDone;
        return self;
    };
}

-(UITextField *(^)(NSInteger))L_BorderStyle{
    return ^UITextField *(NSInteger borderType){
        self.borderStyle = borderType;
        return self;
    };
}

-(UITextField *(^)(id))L_delegate{
    return ^UITextField *(id delegate){
        self.delegate = delegate;
        return self;
    };
  
}

-(UITextField *(^)(NSInteger))L_keyBoardAppearance{
    return ^UITextField *(NSInteger appearance){
        self.keyboardAppearance = appearance;
        return self;
    };
    
    
}

-(UITextField *(^)(UIView *))L_addView{
    return ^UITextField *(UIView *view){
        [view addSubview:self];
        return self;
    };
    
    
}

-(UITextField *(^)(UIView *))L_LeftView{
    return ^UITextField *(UIView *v){
        self.leftView = v;
        self.leftViewMode = UITextFieldViewModeAlways;
        return self;
    };
}

-(UITextField *(^)(UIView *))L_RightView {
    return ^UITextField *(UIView *v){
        self.rightView = v;
        self.rightViewMode = UITextFieldViewModeAlways;
        return self;
    };
}

-(UITextField *(^)(CGFloat))L_BorderWidth{
    return ^UITextField *(CGFloat w){
        self.layer.borderWidth = w;
        return  self;
    };
    
}

-(UITextField *(^)(UIColor *))L_BorderColor{
    return ^UITextField *(UIColor *color){
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

-(UITextField *(^)(BOOL))L_Enabled{
    return ^UITextField *(BOOL isEnabled){
        self.enabled = isEnabled;
        return self;
    };
}

-(UITextField *(^)(NSInteger))L_ClearButtonMode{
    return ^UITextField *(NSInteger mode){
        self.clearButtonMode = mode;
        return  self;
    };
}

-(UITextField *(^)(id, SEL, UIControlEvents))L_AddTarget{
    return ^UITextField *(id object,SEL action,UIControlEvents event){
        [self addTarget:object action:action forControlEvents:event];
        return self;
    };
}

-(UITextField *(^)(CGFloat))L_PaddingLeft{
    return ^UITextField *(CGFloat w){
        CGRect frame = self.frame;
        frame.size.width = w;
        UIView *leftView = [[UIView alloc]initWithFrame:frame];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftView;
        return self;
    };
}


@end
