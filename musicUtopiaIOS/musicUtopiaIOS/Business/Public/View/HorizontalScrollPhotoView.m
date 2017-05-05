#import "HorizontalScrollPhotoView.h"

@implementation HorizontalScrollPhotoView

+(UIView *)createHorizontalScrollPhotoView:(NSArray *)photoArr ViewSize:(CGSize)size{
    
    UIView * pView = [UIView ViewInitWith:^(UIView *view) {
       
        view
        .L_Frame(CGRectMake(0,0,size.width,size.height))
        .L_BgColor([UIColor grayColor]);
    }];
    
    
    return pView;
}

@end
