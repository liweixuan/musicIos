

#import "UIView+Link.h"

@implementation UIView (Link)

+(instancetype)ViewInitWith:(void (^)(UIView *))initBlock{
    UIView *v = [[UIView alloc]init];
    if (initBlock) {
        initBlock(v);
    }
    return v;
    
}

-(UIView *(^)(CGRect))L_Frame{
    return ^UIView *(CGRect rect){
        self.frame = rect;
        return self;
    };
    
}

-(UIView *(^)(UIColor *))L_BgColor{
    return ^UIView *(UIColor *color){
        self.backgroundColor =color ;
        return self;
    };
    
}

-(UIView *(^)(UIView *))L_AddView{
    return ^UIView *(UIView *view){
        [view addSubview:self];
        return self;
    };
}

-(UIView *(^)(UIColor *))L_ShadowColor {
    return ^UIView *(UIColor *color){
        self.layer.shadowColor = color.CGColor;
        return self;
    };
}

-(UIView *(^)(CGSize))L_shadowOffset {
    return ^UIView *(CGSize size){
        self.layer.shadowOffset = size;
        return self;
    };
}

-(UIView *(^)(CGFloat))L_shadowOpacity {
    return ^UIView *(CGFloat o){
        self.layer.shadowOpacity = o;
        return self;
    };
}

-(UIView *(^)(NSInteger))L_shadowRadius {
    return ^UIView *(NSInteger r){
        self.layer.shadowRadius = r;
        return self;
    };
}

-(UIView *(^)(NSInteger))L_radius {
    return ^UIView *(NSInteger r){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = r;
        return self;
    };
}

-(UIView *(^)(CGFloat))L_Alpha {
    return ^UIView *(CGFloat a){
        self.alpha = a;
        return self;
    };
}

-(UIView *(^)(NSInteger))L_radius_NO_masksToBounds {
    return ^UIView *(NSInteger r){
        self.layer.cornerRadius = r;
        return self;
    };
}

-(UIView *(^)(NSInteger))L_tag {
    return ^UIView *(NSInteger t){
        self.tag = t;
        return self;
    };
}

-(UIView *(^)(UIColor *))L_borderColor {
    return ^UIView *(UIColor * color){
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

-(UIView *(^)(NSInteger))L_borderWidth {
    return ^UIView *(NSInteger w){
        self.layer.borderWidth = w;
        return self;
    };
}

-(UIView *(^)(id,SEL))L_Click {
    return ^UIView *(id obj,SEL sel){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:obj action:sel];
        [self addGestureRecognizer:tap];
        return self;
    };
}

-(UIView *(^)(UIRectCorner,NSInteger))L_raius_location {
    
    return ^UIView *(UIRectCorner rc,NSInteger rv){
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rc cornerRadii:CGSizeMake(rv,rv)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        return self;
    };
}


@end
