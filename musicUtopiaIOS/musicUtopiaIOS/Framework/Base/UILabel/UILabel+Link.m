#import "UILabel+Link.h"

@implementation UILabel (Link)

+(instancetype)LabelinitWith:(void (^)(UILabel *la)) initblock {
    UILabel *la = [[UILabel alloc] init];
    if (initblock) {
        initblock(la);
    }
    return la;
}

-(UILabel *(^)(CGRect))L_Frame {
    
    return ^UILabel *(CGRect rect){
        self.frame = rect;
        return self;
    };
    
}


-(UILabel *(^)(id,SEL))L_Click {
    return ^UILabel *(id obj,SEL sel){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:obj action:sel];
        [self addGestureRecognizer:tap];
        return self;
    };
}


-(UILabel *(^)(BOOL))L_isEvent {
    return ^UILabel *(BOOL e){
        self.userInteractionEnabled = e;
        return self;
    };
}


-(UILabel *(^)(UIRectCorner,NSInteger))L_raius_location {
    return ^UILabel *(UIRectCorner rc,NSInteger rv){
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rc cornerRadii:CGSizeMake(rv,rv)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        return self;
    };
}

-(UILabel *(^)(UIColor *))L_BgColor {
    
    return ^UILabel *(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
    
}

-(UILabel *(^)(NSString *))L_Text {
    return ^UILabel *(NSString *text){
        self.text = text;
        return self;
    };
}

-(UILabel *(^)(UIColor *))L_TextColor {
    return ^UILabel *(UIColor *color){
        self.textColor = color;
        return self;
    };
}

-(UILabel *(^)(NSInteger))L_Tag {
    return ^UILabel *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

-(UILabel *(^)(NSInteger))L_Font {
    return ^UILabel *(NSInteger fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

-(UILabel *(^)(NSInteger))L_textAlignment {
    return ^UILabel *(NSInteger alignValue){
        self.textAlignment = alignValue;
        return self;
    };
}

-(UILabel *(^)(CGFloat))L_alpha {
    return ^UILabel *(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

-(UILabel *(^)(NSInteger))L_numberOfLines {
    return ^UILabel *(NSInteger numberOfLines){
        self.numberOfLines = numberOfLines;
        return self;
    };
}

-(UILabel *(^)(NSInteger))L_lineHeight {
    return ^UILabel *(NSInteger lineHeightValue){
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineHeightValue];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        self.attributedText = attributedString;
        
        return self;
    };

}
@end
