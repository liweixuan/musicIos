
#import <UIKit/UIKit.h>

@interface UIView (Link)
-(UIView *(^)(CGRect))L_Frame;
-(UIView *(^)(UIColor *))L_BgColor;
-(UIView *(^)(UIView *))L_AddView;
-(UIView *(^)(UIColor *))L_ShadowColor;
-(UIView *(^)(CGSize))L_shadowOffset;
-(UIView *(^)(CGFloat))L_shadowOpacity;
-(UIView *(^)(NSInteger))L_shadowRadius;
-(UIView *(^)(NSInteger))L_radius;
-(UIView *(^)(NSInteger))L_tag;
-(UIView *(^)(NSInteger))L_radius_NO_masksToBounds;
-(UIView *(^)(UIColor *))L_borderColor;
-(UIView *(^)(NSInteger))L_borderWidth;
-(UIView *(^)(UIRectCorner,NSInteger))L_raius_location;
-(UIView *(^)(id,SEL))L_Click;
-(UIView *(^)(CGFloat))L_Alpha;

+(instancetype)ViewInitWith:(void(^)(UIView * view)) initBlock;




@end
