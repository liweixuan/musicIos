//乐器类别选择（通用）

#import <UIKit/UIKit.h>

@protocol MusciCategorySelectViewDelegate <NSObject>

//类别点击
-(void)categoryClick:(NSString *)c_name Cid:(NSInteger)c_id;

@end


@interface MusciCategorySelectView : UIView

@property(nonatomic,strong)id<MusciCategorySelectViewDelegate> delegate;

-(NSDictionary *)createViewBoxWidth:(CGFloat)boxWidth CategoryArr:(NSArray *)cArr;

@end
