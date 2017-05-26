//
//  RegisterPasswordViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RegisterPasswordViewController.h"
#import "RegisterSubmitViewController.h"
#import "AlbumViewController.h"
#import "CameraViewController.h"

@interface RegisterPasswordViewController ()<AlbumDelegate,CameraDelegate>
{
    UITextField * _passwordInput;
    UITextField * _confirmPasswordInput;
    UITextField * _nicknameInput;
    UIImageView * _uploadHeader;
    UIImageView * _manIcon;
    UIImageView * _womanIcon;
    UIImageView * _rsSexView;
    UIButton    * _selectSex;
    UIView      * _inputBox;
    
    NSString    * _headerUrl;
    UIView      * _sexView;
    NSInteger     _sex;
}
@end

@implementation RegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加基本信息";
    
    [self initVar];
    
    //创建导航按钮
    R_NAV_TITLE_BTN(@"R",@"下一步",registerNext)
    
    [self createView];
    
}

-(void)initVar {
    _headerUrl = @"";
    _sex       = 2;
}

-(void)createView {
    
    //用户头像上传
    _uploadHeader = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2-120/2,30, 120, 120))
        .L_Event(YES)
        .L_Click(self,@selector(uploadHeaderClick))
        .L_ImageName(@"shangchuan")
        .L_radius(5)
        .L_AddView(self.view);
    }];
    
    //上传头像标题
    UILabel * uploadLabel = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0, [_uploadHeader bottom]+10,D_WIDTH,ATTR_FONT_SIZE))
        .L_Font(ATTR_FONT_SIZE)
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_Text(@"选择头像")
        .L_textAlignment(NSTextAlignmentCenter)
        .L_AddView(self.view);
    }];
    
    
    //选择性别按钮
    _selectSex = [UIButton ButtonInitWith:^(UIButton *btn) {
        
        btn
        .L_Frame(CGRectMake(D_WIDTH/2 - 120/2,[uploadLabel bottom]+20,120,35))
        .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
        .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
        .L_Title(@"选择性别",UIControlStateNormal)
        .L_radius_NO_masksToBounds(5)
        .L_TargetAction(self,@selector(selectSexClick),UIControlEventTouchUpInside)
        .L_AddView(self.view);
        
    } buttonType:UIButtonTypeCustom];
    
    _rsSexView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 40/2,[_selectSex bottom]+20,40,40))
        .L_Alpha(0.0)
        .L_AddView(self.view);
    }];
    
    //性别选择
    _sexView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,[_selectSex bottom]+10,D_WIDTH,60))
        .L_AddView(self.view);
    }];
    _sexView.hidden = YES;
    
    //男选择
    UIView * manView = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH/2,[_sexView height]))
        .L_Click(self,@selector(manSelectClick))
        .L_AddView(_sexView);
    }];
    
    _manIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake([manView width]/2 - 30/2 - 15,[manView height]/2- 30/2,30,30))
        .L_ImageName(@"sex_nan")
        .L_AddView(manView);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([_manIcon right] + 5,0,20,[manView height]))
        .L_Text(@"男")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(manView);
    }];
    
    //女选择
    UIView * womanView = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(D_WIDTH/2,0,D_WIDTH/2,[_sexView height]))
        .L_Click(self,@selector(womanSelectClick))
        .L_AddView(_sexView);
    }];
    
    _womanIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake([womanView width]/2 - 32/2 - 15,[womanView height]/2- 32/2,32,32))
        .L_ImageName(@"sex_nv")
        .L_AddView(womanView);
    }];
    
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake([_womanIcon right] + 5,0,20,[manView height]))
        .L_Text(@"女")
        .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
        .L_AddView(womanView);
    }];
    

    //创建输入容器框
    _inputBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,[_selectSex bottom]+20,D_WIDTH - CARD_MARGIN_LEFT *2,120))
        .L_AddView(self.view);
    }];
    
    UIImageView * nicknameIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"zhanghao");
    }];
    
    //昵称输入框
    _nicknameInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,0,[_inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"用户昵称")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(nicknameIcon)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(_inputBox);
    }];

    
    UIImageView * phoneIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"mima");
    }];
    
    //输入框
    _passwordInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,[_nicknameInput bottom]+10,[_inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"登录密码")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(phoneIcon)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(_inputBox);
    }];
    
    UIImageView * confirmPasswordIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(0,0,40,SMALL_ICON_SIZE))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_ImageName(@"mima");
    }];
    
    //输入框
    _confirmPasswordInput = [UITextField TextFieldInitWith:^(UITextField *text) {
        text
        .L_Frame(CGRectMake(0,[_passwordInput bottom]+10,[_inputBox width], TEXTFIELD_HEIGHT))
        .L_Placeholder(@"确认密码")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_LeftView(confirmPasswordIcon)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(20)
        .L_AddView(_inputBox);
    }];
    
    
    
}

-(void)registerNext {
    
    if([_headerUrl isEqualToString:@""]){
        SHOW_HINT(@"请上传头像");
        return;
    }
    
    if(_sex == 2){
        SHOW_HINT(@"用户性别不能为空");
        return;
    }
    
    if([_nicknameInput.text isEqualToString:@""]){
        SHOW_HINT(@"用户昵称不能为空");
        return;
    }
    
    if([_passwordInput.text isEqualToString:@""] || [_confirmPasswordInput.text isEqualToString:@""]){
        SHOW_HINT(@"密码不能为空");
        return;
    }
    
    //验证两次密码是否一致
    if(![_passwordInput.text isEqualToString:_confirmPasswordInput.text]){
        SHOW_HINT(@"两次密码输入不一致");
        return;
    }
    
    RegisterSubmitViewController * registerSubVC = [[RegisterSubmitViewController alloc] init];
    registerSubVC.phone     = self.phone;
    registerSubVC.password  = _passwordInput.text;
    registerSubVC.sex       = _sex;
    registerSubVC.headerUrl = _headerUrl;
    registerSubVC.nickname  = _nicknameInput.text;
    [self.navigationController pushViewController:registerSubVC animated:YES];
    
}

-(void)uploadHeaderClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        AlbumViewController *AlbumVc = [[AlbumViewController alloc] init];
        AlbumVc.delegate = self;
        [self presentViewController:AlbumVc animated:YES completion:nil];
        
        
        
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CameraViewController * cameraVC = [[CameraViewController alloc] init];
        cameraVC.delegate = self;
        [self presentViewController:cameraVC animated:YES completion:nil];
        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)selectSexClick {
    _sexView.hidden   = NO;
    _rsSexView.hidden = YES;
    _rsSexView.alpha  = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_sexView setY:[_selectSex bottom]+10];
        [_inputBox setY:[_sexView bottom]+20];
    }];
}

-(void)manSelectClick {
    NSLog(@"选择男");
    _rsSexView.hidden = NO;
    _rsSexView.image  = _manIcon.image;
    _sexView.hidden   = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _rsSexView.alpha = 1;
    }];
    
    _sex = 0;
    
}

-(void)womanSelectClick {
    NSLog(@"选择女");
    _rsSexView.hidden = NO;
    _rsSexView.image  = _womanIcon.image;
    _sexView.hidden   = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _rsSexView.alpha = 1;
    }];
    
    _sex = 1;
}

#pragma mark - 代理
-(void)albumSelectImage:(UIImage *)image {
    

    //上传操作
    [self startActionLoading:@"头像上传中..."];
    [NetWorkTools uploadImage:@{@"image":image,@"imageDir":@"headerImage"} Result:^(BOOL results, NSString *fileName) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self endActionLoading];
        });
        
        if(!results){
            dispatch_sync(dispatch_get_main_queue(), ^{
                SHOW_HINT(@"头像上传失败，请重新尝试");
                return;
            });
        }
        
        _headerUrl = fileName;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _uploadHeader.image = image;
        });

    }];
 
    
}

-(void)cameraTakePhoto:(UIImage *)photo {
    
    
    
}

@end
