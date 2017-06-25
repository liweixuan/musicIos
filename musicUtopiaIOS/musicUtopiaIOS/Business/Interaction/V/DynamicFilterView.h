#import "Base_UIView.h"

@protocol DynamicFilterViewDelegate <NSObject>
-(void)dynamicFilterResult:(NSMutableDictionary *)filterParams;  //动态筛选条件
@end

@interface DynamicFilterView : Base_UIView
@property(nonatomic,strong)id<DynamicFilterViewDelegate> delegate;
@end
