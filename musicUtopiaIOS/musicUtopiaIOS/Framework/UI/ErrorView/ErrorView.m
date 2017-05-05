#import "ErrorView.h"

@implementation ErrorView
+(UIView *)createDataLoadingErrorView:(NSString *)errorMsg {
    
    UIView *loadingErrorView         = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    loadingErrorView.backgroundColor = HEX_COLOR(@"#F0F0F0");
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(D_WIDTH/2-60/2,100,60,60)];
    errorImageView.contentMode = UIViewContentModeScaleAspectFit;
    errorImageView.image = [UIImage imageNamed:@"request_failed"];
    [loadingErrorView addSubview:errorImageView];
    
    UILabel * errorMsgLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,[errorImageView bottom]+25, D_WIDTH, 20)];
    errorMsgLabel.text      = errorMsg;
    errorMsgLabel.textColor = HEX_COLOR(@"#F00F00");
    errorMsgLabel.font      = [UIFont systemFontOfSize:14];
    errorMsgLabel.textAlignment = NSTextAlignmentCenter;
    [loadingErrorView addSubview:errorMsgLabel];
    
    UILabel * resetInfo = [[UILabel alloc] initWithFrame:CGRectMake(0,[errorMsgLabel bottom]+15,D_WIDTH,20)];
    resetInfo.font = [UIFont systemFontOfSize:14];
    resetInfo.textColor = HEX_COLOR(@"#999999");
    resetInfo.text = @"点击画面重新加载";
    resetInfo.textAlignment = NSTextAlignmentCenter;
    [loadingErrorView addSubview:resetInfo];

    return loadingErrorView;
}


@end
