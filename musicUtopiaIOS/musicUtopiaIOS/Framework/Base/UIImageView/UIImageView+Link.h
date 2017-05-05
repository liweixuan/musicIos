#import <UIKit/UIKit.h>

@interface UIImageView (Link)
-(UIImageView *(^)(CGRect))L_Frame;
-(UIImageView *(^)(UIColor *))L_BgColor;
-(UIImageView *(^)(UIImage *))L_Image;
-(UIImageView *(^)(NSString *))L_ImageName;
-(UIImageView *(^)())L_Round;
-(UIImageView *(^)(UIViewContentMode))L_ImageMode;
-(UIImageView *(^)(NSInteger))L_Corner;
-(UIImageView *(^)(BOOL))L_Event;
-(UIImageView *(^)(NSString *,NSString *))L_ImageUrlName;
-(UIImageView *(^)(id,SEL))L_Click;
+(instancetype)ImageViewInitWith:(void (^)(UIImageView *imgv)) initblock;
@end
