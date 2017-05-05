#import "LoadingView.h"

@implementation LoadingView

+ (UIView *)createDataLoadingView {
    
    UIView *loadingView         = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    loadingView.backgroundColor = HEX_COLOR(@"#F0F0F0");
    
    //创建图片视图
    UIImageView *animateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(D_WIDTH/2-100/2,100,100,100)];
    animateImageView.contentMode  = UIViewContentModeScaleAspectFit;
    [loadingView addSubview:animateImageView];
    
    //创建动画图片数组
    NSMutableArray *animateArr = [NSMutableArray array];
    for(int i = 0;i<14;i++){
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]];
        [animateArr addObject:img];
    }
    
    //设置动画属性
    animateImageView.animationImages = animateArr;
    animateImageView.animationDuration = 2;
    animateImageView.animationRepeatCount = 0;
    
    //开始动画
    [animateImageView startAnimating];
    
    //提示信息
    CGFloat animateImageViewY = CGRectGetMaxY(animateImageView.frame);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,animateImageViewY,D_WIDTH,30)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在请求数据，请稍后...";
    label.textColor = [UIColor grayColor];
    [loadingView addSubview:label];

    
    //返回加载中视图
    return loadingView;

}


@end
