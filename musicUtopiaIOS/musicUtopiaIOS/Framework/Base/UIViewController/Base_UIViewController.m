#import "Base_UIViewController.h"
#import "LoadingView.h"
#import "ErrorView.h"
#import "EmptyView.h"

@interface Base_UIViewController(){
    UIView        * _errorView;
    UIView        * _loadView;
    UIView        * _emptyView;
    MBProgressHUD * _hud;
}

@end

@implementation Base_UIViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)viewDidLoad {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    bgView.backgroundColor = HEX_COLOR(VC_BG);
    self.view      = bgView;
    self.delegate  = self;
    
}

-(void)startLoading {
    
    //创建请求动画
    _loadView = [LoadingView createDataLoadingView];
    [self.view addSubview:_loadView];
   
 
}

-(void)endLoading {
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _loadView.alpha = 0;
    }completion:^(BOOL finished) {
        [_loadView removeFromSuperview];
    }];
    
    
}

-(void)startError:(NSString *)errorMsg{
    
    [self endLoading];
    
    _errorView = [ErrorView createDataLoadingErrorView:errorMsg];
    [self.view addSubview:_errorView];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [_errorView addGestureRecognizer:tap];
    
}

-(void)dataReset {
    [self.delegate dataReset];
}

-(void)startEmpty {
    
    _emptyView = [EmptyView createEmptyView];
    [self.view addSubview:_emptyView];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [_emptyView addGestureRecognizer:tap];
    
}



-(void)viewTap:(UITapGestureRecognizer *)tap {
    [_errorView removeFromSuperview];
    [_emptyView removeFromSuperview];
    [self dataReset];
}

//开启操作加载请求
-(void)startActionLoading:(NSString *)msg {

    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.label.text = msg == nil ? @"处理中..." : msg;
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
}

//关闭操作加载请求
-(void)endActionLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud removeFromSuperview];
    });
}

@end
