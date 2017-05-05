#import <UIKit/UIKit.h>

@interface PhotoMessageViewController : UIViewController
@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,strong)UIImage  * imageData;
@property(nonatomic,assign)NSInteger  imageType; //显示类型 1-URL类型 2-数据源类型
@end
