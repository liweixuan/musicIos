#import "HintManager.h"
#import "UILabel+Link.h"

@interface HintManager() {
    UIView * _infoView;
}
@end

@implementation HintManager
+(HintManager *)sharedManager {
    static HintManager *sharedHintManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHintManagerInstance = [[self alloc] init];
    });
    return sharedHintManagerInstance;
}

-(void)createHintView:(NSString *)type message:(NSString *)msg{
    
    if(_infoView == nil){
        
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,0)];
        UIColor *color = nil;
        
        if([type isEqualToString:@"info"]){
            color = HEX_COLOR(@"#0099FF");
        }else if([type isEqualToString:@"error"]){
            color = HEX_COLOR(@"#FF0000");
        }else if([type isEqualToString:@"warning"]){
            color = HEX_COLOR(@"#FF6600");
        }else if([type isEqualToString:@"success"]){
            color = HEX_COLOR(@"#00CC66");
        }
        
        _infoView.backgroundColor = color;
        UIWindow * windowView = [[UIApplication sharedApplication].delegate window];
        [windowView addSubview:_infoView];
        
        UILabel *message = [UILabel LabelinitWith:^(UILabel *label){
            label.L_Frame(CGRectMake(0,20,_infoView.frame.size.width,44)).L_Text(@"撒打算打算的").L_alpha(0).L_Tag(11).L_textAlignment(NSTextAlignmentCenter).L_Font(12).L_TextColor([UIColor whiteColor]).L_numberOfLines(2).L_lineHeight(10);
        }];
        [_infoView addSubview:message];

        //创建手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoViewClick)];
        [_infoView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_infoView setHeight:64];
        } completion:^(BOOL finished) {
            message.alpha = 1;
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:4.0f];
        }];
        
    }
    
}

-(void)infoMessage:(NSString *)msg {
    [self createHintView:@"info" message:msg];
}

-(void)errorMessage:(NSString *)msg {
    [self createHintView:@"error" message:msg];
}

-(void)warningMessage:(NSString *)msg {
    [self createHintView:@"warning" message:msg];
}

-(void)successMessage:(NSString *)msg {
    [self createHintView:@"success" message:msg];
}

-(void)delayMethod {
    [UIView animateWithDuration:0.4 animations:^{
        [_infoView viewWithTag:11].alpha = 0;
        [_infoView setHeight:0];
    } completion:^(BOOL finished) {
        [_infoView removeFromSuperview];
        _infoView = nil;
    }];
    
}

-(void)infoViewClick {
    if (_hintClick) {
        _hintClick();
    }
    
}
@end
