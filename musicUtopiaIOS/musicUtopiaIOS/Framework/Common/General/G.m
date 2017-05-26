#import "G.h"

@implementation G : NSObject


+ (UIColor *)colorWithHexString:(NSString *)color {
    
    return [self colorWithHexString:color alpha:1.0f];
    
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //字符串应该是6或8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    //分离成r,g,b子字符串
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //扫描值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (NSString *)formatRestful:(NSString *)url Params:(NSArray *)params {
    
    NSString *urlStr = @"";
    for(NSDictionary *dict in params){

        //需要健值对的形式
        NSString *param = [NSString stringWithFormat:@"%@/%@/",[dict objectForKey:@"key"],[dict objectForKey:@"value"]];
        urlStr = [urlStr stringByAppendingString:param];

    }

    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * newStr = [NSString stringWithFormat:@"%@/%@",url,urlStr];
    newStr = [newStr substringToIndex:[newStr length] - 1];
 
    return newStr;
    
    
}

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = CONTENT_LINE_HEIGHT;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

+ (NSString *)formatData:(NSInteger)unixTime Format:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}


@end
