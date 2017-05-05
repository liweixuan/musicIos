#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
- (UIImage *)resizedImage:(NSString *)name;

/**
 *  根据源更改图片长宽
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
