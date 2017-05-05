/*
 * 文件：通用方法类
 * 描述：通用方法库集合
 */

#import <Foundation/Foundation.h>

@interface G : NSObject

/*
 * 颜色处理相关通用方法
 */

+ (UIColor *)colorWithHexString:(NSString *)color;                      //设置十六进制色
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha; //设置带透明度的十六进制色


/*
 * 字符串处理相关通用方法
 */

+ (NSString *)formatRestful:(NSString *)url Params:(NSArray *)params; //生成restful的请求地址
+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize; //根据内容获取字符串的大小

/*
 * 日期处理相关通用方法
 */
+ (NSString *)formatData:(NSInteger)unixTime Format:(NSString *)format;






@end
