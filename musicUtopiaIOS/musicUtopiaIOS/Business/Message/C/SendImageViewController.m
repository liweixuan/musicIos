//
//  SendImageViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SendImageViewController.h"

@interface SendImageViewController ()
{
    UIView * _topActionBox;     //顶部操作容器
    UIView * _bottomActionBox;  //底部操作容器
    
    BOOL     _isShowActionBox;  //是否显示上下菜单
}
@end

@implementation SendImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR(@"#666666");
    
    _isShowActionBox = true;
    
    //创建预览图片视图
    [self createImageView];
    
    //上下操作部分
    [self createAction];
}

//创建预览图片视图
-(void)createImageView {
    
    UIImageView * imageview = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
       imgv
        .L_Frame(CGRectMake(0,0,D_WIDTH,D_HEIGHT))
        .L_Image(self.image)
        .L_Event(YES)
        .L_Click(self,@selector(imageClick))
        .L_ImageMode(UIViewContentModeScaleAspectFit)
        .L_AddView(self.view);
    }];
    
}

//上下操作部分
-(void)createAction {
    
    _topActionBox = [UIView ViewInitWith:^(UIView *view) {
       view
        .L_Frame(CGRectMake(0,0,D_WIDTH,64))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.view);
    }];
    
    //标题
    [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,20 + 44/2 - TITLE_FONT_SIZE/2,[_topActionBox width],TITLE_FONT_SIZE))
        .L_Font(TITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_Text(@"预览")
        .L_AddView(_topActionBox);
    }];
    
    //取消按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CONTENT_PADDING_LEFT,20 + 44/2 - SUBTITLE_FONT_SIZE/2,40,SUBTITLE_FONT_SIZE))
        .L_Title(@"取消",UIControlStateNormal)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TargetAction(self,@selector(cancelSendImage),UIControlEventTouchUpInside)
        .L_TitleColor(HEX_COLOR(@"#999999"),UIControlStateNormal)
        .L_AddView(_topActionBox);
    } buttonType:UIButtonTypeCustom];
    
    _bottomActionBox = [UIView ViewInitWith:^(UIView *view) {
        view
        .L_Frame(CGRectMake(0,D_HEIGHT - 40,D_WIDTH,40))
        .L_BgColor([UIColor whiteColor])
        .L_AddView(self.view);
    }];
    
    //发送按钮
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([_bottomActionBox width] - 40 - CONTENT_PADDING_LEFT,40/2 - SUBTITLE_FONT_SIZE/2,40,SUBTITLE_FONT_SIZE))
        .L_Title(@"发送",UIControlStateNormal)
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_TargetAction(self,@selector(sendImageMessage),UIControlEventTouchUpInside)
        .L_TitleColor(HEX_COLOR(APP_MAIN_COLOR),UIControlStateNormal)
        .L_AddView(_bottomActionBox);
    } buttonType:UIButtonTypeCustom];
    
}


#pragma mark - 事件
-(void)cancelSendImage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageClick {
    
    if(_isShowActionBox){
        
        _isShowActionBox = NO;
        [UIView animateWithDuration:0.1 animations:^{
            [_topActionBox setY: - [_topActionBox height]];
            [_bottomActionBox setY: D_HEIGHT];
        }];
        
    }else{
        
        _isShowActionBox = YES;
        [UIView animateWithDuration:0.1 animations:^{
            [_topActionBox setY:0];
            [_bottomActionBox setY: D_HEIGHT - 40];
        }];
        
    }
    
    
}

//发送图片
-(void)sendImageMessage {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.SendImageDelegate sendImage:self.image];
    }];
}
@end
