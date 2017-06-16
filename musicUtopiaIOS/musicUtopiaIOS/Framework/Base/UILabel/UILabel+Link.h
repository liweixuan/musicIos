#import <UIKit/UIKit.h>

@interface UILabel (Link)
-(UILabel *(^)(CGRect))L_Frame;
-(UILabel *(^)(UIColor *))L_BgColor;
-(UILabel *(^)(NSString *))L_Text;
-(UILabel *(^)(UIColor *))L_TextColor;
-(UILabel *(^)(NSInteger))L_Tag;
-(UILabel *(^)(NSInteger))L_Font;
-(UILabel *(^)(NSInteger))L_textAlignment;
-(UILabel *(^)(CGFloat))L_alpha;
-(UILabel *(^)(NSInteger))L_numberOfLines;
-(UILabel *(^)(BOOL))L_isEvent;
-(UILabel *(^)(id,SEL))L_Click;
-(UILabel *(^)(UIRectCorner,NSInteger))L_raius_location;
-(UILabel *(^)(NSInteger))L_lineHeight;
+(instancetype)LabelinitWith:(void (^)(UILabel *la)) initblock;
@end
