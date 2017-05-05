#import <UIKit/UIKit.h>


typedef enum : NSInteger {
    URL_TYPE = 1,   //路径模式
    DATA_TYPE       //数据源模式
} ImageType;

@interface PhotoView : UIScrollView
@property(nonatomic,strong)NSString *imageurl;
@property(nonatomic,strong)UIImage  *image;
//创建可伸缩的图片
//参数1:图片大小
//参数2:图片的完整路径
//参数3:创建图片的模式
//参数4:数据源(如果模式为 数据源模式的情况下有效)
- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image dataType:(ImageType)type imgData:(UIImage *)imgdata;
@end
