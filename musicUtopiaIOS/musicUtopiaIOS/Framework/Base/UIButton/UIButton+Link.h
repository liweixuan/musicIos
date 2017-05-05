

#import <UIKit/UIKit.h>

@interface UIButton (Link)
-(UIButton *(^)(CGRect))L_Frame;
-(UIButton *(^)(NSString *,UIControlState))L_Title;
-(UIButton *(^)(UIColor *,UIControlState))L_TitleColor;
-(UIButton *(^)(id,SEL,UIControlEvents))L_TargetAction;
-(UIButton *(^)(UIColor*))L_BgColor;
-(UIButton *(^)(NSString *,UIControlState))L_BtnImageName ;
-(UIButton *(^)())L_RoundBtn;
-(UIButton *(^)(CGFloat))L_BorderWidth;
-(UIButton *(^)(UIColor *))L_BorderColor;
-(UIButton *(^)(CGFloat))L_Radius;
-(UIButton *(^)(NSInteger))L_radius_NO_masksToBounds;
-(UIButton *(^)(CGFloat))L_Font;
-(UIButton *(^)(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right))L_Padding;
-(UIView *(^)(UIView *))L_AddView;
+(instancetype)ButtonInitWith:(void(^)(UIButton *btn)) initBlock buttonType:(UIButtonType)type;




@end
