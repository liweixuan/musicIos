
#import <UIKit/UIKit.h>

@interface UITextField (Link)
//初始化
+(instancetype)TextFieldInitWith:(void (^)(UITextField *text)) initblock;
//text 内容
-(UITextField *(^)(NSString *))L_Text;
//尺寸位置
-(UITextField *(^)(CGRect))L_Frame;
//背景图
-(UITextField *(^)(UIColor *))L_BgColor;
//占位字符串
-(UITextField *(^)(NSString *))L_Placeholder;
//字体格式
-(UITextField *(^)(NSInteger ))L_Font;
//字体颜色
-(UITextField *(^)(UIColor *))L_TextColor;
//字体布局
-(UITextField *(^)(NSInteger ))L_textAlignment;
//安全输入
-(UITextField *(^)(BOOL ))L_Secure;
//键盘样式
-(UITextField*(^)(NSInteger ))L_Keyboard;
//return键自定义
-(UITextField *(^)(NSInteger ))L_ReturnKey;
//边框样式
-(UITextField *(^)(NSInteger ))L_BorderStyle;
//代理
-(UITextField *(^)(id))L_delegate;
//键盘颜色
-(UITextField *(^)(NSInteger))L_keyBoardAppearance;
//添加到界面
-(UITextField *(^)(UIView *))L_addView;
//左小视图
-(UITextField *(^)(UIView *))L_LeftView;
//右小视图
-(UITextField *(^)(UIView *))L_RightView;
//边框宽度
-(UITextField *(^)(CGFloat))L_BorderWidth;
//边框颜色
-(UITextField *(^)(UIColor *))L_BorderColor;
//是否允许输入
-(UITextField *(^)(BOOL))L_Enabled;
//清除按钮存在模式
-(UITextField *(^)(NSInteger))L_ClearButtonMode;
//添加动作事件
-(UITextField *(^)(id,SEL,UIControlEvents))L_AddTarget;
//左间距填充
-(UITextField *(^)(CGFloat))L_PaddingLeft ;


@end
