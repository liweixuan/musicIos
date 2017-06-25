#import "Base_UIViewController.h"
#import "DynamicFrame.h"

@interface InteractionCommentViewController : Base_UIViewController
@property(nonatomic,strong)DynamicFrame * dynamicFrame; //动态数据
@property(nonatomic,assign)BOOL isDeleteBtn;
@end
