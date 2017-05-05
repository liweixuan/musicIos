#import "UIImageView+Link.h"

@implementation UIImageView (Link)

-(UIImageView *(^)(CGRect))L_Frame {
    return ^UIImageView *(CGRect rect){
        self.frame = rect;
        return self;
    };
}

-(UIImageView *(^)(UIColor *))L_BgColor {
    return ^UIImageView *(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}

-(UIImageView *(^)(UIImage *))L_Image {
    return ^UIImageView *(UIImage *image){
        self.image = image;
        return self;
    };
}

-(UIImageView *(^)(NSString *))L_ImageName {
    return ^UIImageView *(NSString *imageName){
        self.image = [UIImage imageNamed:imageName];
        return self;
    };
}

-(UIImageView *(^)(UIViewContentMode))L_ImageMode {
    return ^UIImageView *(UIViewContentMode imageMode){
        self.contentMode = imageMode;
        return self;
    };
}

-(UIImageView *(^)(BOOL))L_Event {
    return ^UIImageView *(BOOL e){
        self.userInteractionEnabled = e;
        return self;
    };
}

-(UIImageView *(^)())L_Round {
    return ^UIImageView *(){
        self.layer.cornerRadius  = self.frame.size.width / 2;
        self.layer.masksToBounds = YES;
        return self;
    };
}

-(UIImageView *(^)(NSInteger))L_Corner{
    return ^UIImageView *(NSInteger r){
        self.layer.cornerRadius  = r;
        self.layer.masksToBounds = YES;
        return self;
    };
}


+(instancetype)ImageViewInitWith:(void (^)(UIImageView *imgv)) initblock {
    UIImageView *imagev = [[UIImageView alloc] init];
    if (initblock) {
        initblock(imagev);
    }
    return imagev;
}

-(UIImageView *(^)(NSString *,NSString *))L_ImageUrlName {
    
    return ^UIImageView *(NSString * name,NSString * defaultImage){
        [self sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:defaultImage]];
        return self;
    };

}

-(UIImageView *(^)(id,SEL))L_Click {
    return ^UIImageView *(id obj,SEL sel){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:obj action:sel];
        [self addGestureRecognizer:tap];
        return self;
    };
}


@end
