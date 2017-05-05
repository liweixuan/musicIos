#import "MyPopView.h"

@implementation MyPopView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
  
    UIRectFill([self bounds]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);

    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, 15, 0);//设置起点
    
    CGContextAddLineToPoint(context,0,30);
    
    CGContextAddLineToPoint(context,30,30);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [HEX_COLOR(APP_MAIN_COLOR) setFill]; //设置填充色
    
    [HEX_COLOR(APP_MAIN_COLOR) setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}

@end
