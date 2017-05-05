#import "EmptyView.h"

@implementation EmptyView
+(UIView *)createEmptyView {
    
    UIView *emptyView         = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    emptyView.backgroundColor = HEX_COLOR(@"#F0F0F0");
    
    //无数据时显示图
    UIImageView * emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(D_WIDTH/2-100/2,100,100,100)];
    emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    emptyImageView.image = [UIImage imageNamed:@"load_failed"];
    [emptyView addSubview:emptyImageView];
    
    UILabel * msgLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,[emptyImageView bottom]+15, D_WIDTH, 20)];
    msgLabel.text      = @"抱歉，该内容为空";
    msgLabel.textColor = HEX_COLOR(@"#F00F00");
    msgLabel.font      = [UIFont systemFontOfSize:14];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:msgLabel];
    
    UILabel * resetInfo = [[UILabel alloc] initWithFrame:CGRectMake(0,[msgLabel bottom]+15,D_WIDTH,20)];
    resetInfo.font = [UIFont systemFontOfSize:14];
    resetInfo.textColor = HEX_COLOR(@"#999999");
    resetInfo.text = @"点击画面重新加载";
    resetInfo.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:resetInfo];

    return emptyView;
    
}
@end
