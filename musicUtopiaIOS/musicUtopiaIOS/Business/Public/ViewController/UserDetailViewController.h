#import "Base_UIViewController.h"

@interface UserDetailViewController : Base_UIViewController
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,assign)BOOL isCacnelConcernAction;
@end
