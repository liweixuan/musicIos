
#import "UIButton+Link.h"

@implementation UIButton (Link)
-(UIButton *(^)(CGRect))L_Frame{
    return ^UIButton *(CGRect rect){
        self.frame = rect;
        return self;
    };
}

+(instancetype)ButtonInitWith:(void (^)(UIButton *))initBlock buttonType:(UIButtonType)type{
    UIButton *btn = [UIButton buttonWithType:type];
    if (initBlock) {
        initBlock(btn);
    }
    return btn;
}
-(UIButton *(^)(NSString *,UIControlState))L_Title {
    return ^UIButton *(NSString * str,UIControlState state){
        [self setTitle:str forState:state];
        return self;
    };
}

-(UIButton *(^)(UIColor *,UIControlState))L_TitleColor {
    return ^UIButton *(UIColor * color,UIControlState state){
        [self setTitleColor:color forState:state];
        return self;
    };
}

-(UIButton *(^)(id,SEL,UIControlEvents))L_TargetAction {
    return ^UIButton *(id object,SEL sel,UIControlEvents event){
        [self addTarget:object action:sel forControlEvents:event];
        return self;
    };
}

-(UIButton *(^)(UIColor *))L_BgColor {
    return ^UIButton *(UIColor * color){
        self.backgroundColor = color;
        return self;
    };
}

-(UIButton *(^)(NSString *,UIControlState))L_BtnImageName {
    return ^UIButton *(NSString * str,UIControlState state){
        [self setImage:[UIImage imageNamed:str] forState:state];
        return self;
    };
}

-(UIButton *(^)())L_RoundBtn{
    return ^UIButton *(){
        self.layer.cornerRadius  = self.frame.size.width / 2;
        self.layer.masksToBounds = YES;
        return self;
    };
}

-(UIButton *(^)(CGFloat))L_Radius {
    return ^UIButton *(CGFloat w){
        self.layer.cornerRadius  = w;
        self.layer.masksToBounds = YES;
        return self;
    };
}

-(UIButton *(^)(NSInteger))L_radius_NO_masksToBounds {
    return ^UIButton *(NSInteger w){
        self.layer.cornerRadius  = w;
        return self;
    };

}

-(UIButton *(^)(CGFloat))L_BorderWidth {
    return ^UIButton *(CGFloat w){
        self.layer.borderWidth =  w;
        return self;
    };
}


-(UIButton *(^)(UIColor *))L_BorderColor {
    return ^UIButton *(UIColor * color){
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

-(UIButton *(^)(CGFloat))L_Font {
    return ^UIButton *(CGFloat w){
        self.titleLabel.font = [UIFont systemFontOfSize:w];
        return self;
    };
}

-(UIButton *(^)(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right))L_Padding {
    return ^UIButton *(CGFloat t,CGFloat l,CGFloat b,CGFloat r){
        self.titleEdgeInsets = UIEdgeInsetsMake(t,l,b,r);
        return self;
    };

    
}

-(UIView *(^)(UIView *))L_AddView {
    return ^UIView *(UIView *v){
        [v addSubview:self];
        return self;
    };
    
}




@end
