#ifndef M_Color_h
#define M_Color_h

/*
 * 颜色转换处理
 */
#define RGB_COLOR(R,G,B)           [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGB_COLOR_OPACITY(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define HEX_COLOR(HEX)             [G colorWithHexString:HEX]
#define HEX_COLOR_OPACITY(HEX,A)   [G colorWithHexString:HEX alpha:A]

#endif
