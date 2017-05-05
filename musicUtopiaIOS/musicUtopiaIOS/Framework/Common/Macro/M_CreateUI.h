#ifndef M_CreateUI_h
#define M_CreateUI_h

//快速创建导航按钮
#define R_NAV_TITLE_BTN(DIR,TITLE,EVENT) UIBarButtonItem * BarButtonItem = [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStyleDone target:self action:@selector(EVENT)];\
    BarButtonItem.tintColor = HEX_COLOR(APP_MAIN_COLOR);\
    if([DIR isEqualToString:@"L"]){ \
        self.navigationItem.leftBarButtonItem = BarButtonItem; }else{ \
        self.navigationItem.rightBarButtonItem = BarButtonItem; }


//快速跳转
#define PUSH_VC(VC_NAME,IS_HIDE_TAB,PARAMS) VC_NAME * viewcontroller = [[VC_NAME alloc] init]; \
viewcontroller.hidesBottomBarWhenPushed = IS_HIDE_TAB; \
for(NSString *key in PARAMS){ \
    [viewcontroller setValue:PARAMS[key] forKey:key]; } \
[self.navigationController pushViewController:viewcontroller animated:YES];


//删除加载中动画
#define REMOVE_LOADVIEW [UIView animateWithDuration:0.3 animations:^{ \
_loadView.alpha = 0.0; \
} completion:^(BOOL finished) { \
    [_loadView removeFromSuperview]; \
}];

//提示信息
#define SHOW_HINT(MSG)      UIView *view = [[UIApplication sharedApplication].delegate window];\
MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];\
HUD.mode = MBProgressHUDModeText;\
HUD.labelText = MSG;\
HUD.margin = 10.0;\
HUD.yOffset = 150.0;\
HUD.removeFromSuperViewOnHide = YES;\
[HUD hide:YES afterDelay:1.0];\


#endif
