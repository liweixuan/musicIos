#import "Base_UIViewController.h"

@protocol SendImageViewControllerDelegate <NSObject>

//发送图片
-(void)sendImage:(UIImage *)image;

@end

@interface SendImageViewController : Base_UIViewController
@property(nonatomic,strong)UIImage * image; //要预览的图片
@property(nonatomic,strong)id<SendImageViewControllerDelegate> SendImageDelegate;
@end
