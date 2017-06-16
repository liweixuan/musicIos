//
//  RadioBoxView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioBoxView.h"
#import "AudioPlayer.h"

@interface RadioBoxView()
{
    NSArray     * _radioAnimateArr;
    UIButton    * _radioRecordBtn;
    UILabel     * _cancelHint;
    UILabel     * _recordingLoading;
    AudioPlayer * _player;
}
@end

@implementation RadioBoxView


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        //创建按住发送语音图标
        [self createRadioRecordView];
        
        //音频操作对象
        _player = [[AudioPlayer alloc] init];
        
        
    }
    return self;
}


//初始化变量
-(void)initVar {
    _radioAnimateArr = @[
                         [UIImage imageNamed:@"send_radio_icon_0"],
                         [UIImage imageNamed:@"send_radio_icon_1"],
                         [UIImage imageNamed:@"send_radio_icon_2"],
                         [UIImage imageNamed:@"send_radio_icon_3"],
                         ];
}

//创建按住发送语音图标
-(void)createRadioRecordView {
    
    _radioRecordBtn = [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake([self width]/2 - 180/2,[self height]/2 - 160/2,180,180))
        .L_BtnImageName(@"send_radio_icon_0",UIControlStateNormal)
        .L_TargetAction(self,@selector(touchDown),UIControlEventTouchDown)
        .L_TargetAction(self,@selector(touchUpInside),UIControlEventTouchUpInside)
        .L_TargetAction(self,@selector(touchUpOutside),UIControlEventTouchUpOutside)
        .L_TargetAction(self,@selector(touchDragExit),UIControlEventTouchDragExit)
        .L_TargetAction(self,@selector(touchDragEnter),UIControlEventTouchDragEnter)
        .L_AddView(self);
    } buttonType:UIButtonTypeCustom];
    [_radioRecordBtn setAdjustsImageWhenHighlighted:NO];
    _radioRecordBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _cancelHint = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0,20, [self width],CONTENT_FONT_SIZE))
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor([UIColor grayColor])
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"--- 松开取消本次语音 ---")
        .L_AddView(self);
    }];
    
    _cancelHint.hidden = YES;
    
    
    _recordingLoading = [UILabel LabelinitWith:^(UILabel *la) {
        la
        .L_Frame(CGRectMake(0,20, [self width],CONTENT_FONT_SIZE))
        .L_Font(CONTENT_FONT_SIZE)
        .L_TextColor([UIColor grayColor])
        .L_textAlignment(NSTextAlignmentCenter)
        .L_Text(@"--- 正在录音 ---")
        .L_AddView(self);
    }];
    
    _recordingLoading.hidden = YES;

    
    
}

#pragma mark - 事件处理
//语音按钮按住时
-(void)touchDown {
    NSLog(@"按住时...");
    
    _recordingLoading.hidden = NO;
    
    //播放动画组
    UIImageView * imageView = _radioRecordBtn.imageView;
    imageView.contentMode   = UIViewContentModeScaleAspectFit;
    
    imageView.animationImages = _radioAnimateArr;
    imageView.animationDuration = 1;
    imageView.animationRepeatCount = 0;
    
    if (!imageView.isAnimating) {
        [imageView startAnimating];
    }
    
    //开始录制
    [_player startRecording];
    
    
    
}

//在按钮内部抬起时
-(void)touchUpInside {
    NSLog(@"在按钮内部抬起时...");

    NSDictionary * radioDict = [_player stopRecording];
    
    NSLog(@"录制音频的路径：%@",radioDict[@"filePath"]);
    NSLog(@"录制音频的时长：%@",radioDict[@"timeLength"]);
    
    _recordingLoading.hidden = YES;
    
    //播放动画组
    UIImageView * imageView = _radioRecordBtn.imageView;
    
    if (imageView.isAnimating) {
        [imageView stopAnimating];
    }
    
    [self.delegate sendRadioData:radioDict[@"radioData"] TimeLength:[radioDict[@"timeLength"] integerValue]];
    

}

//在按钮外部抬起时
-(void)touchUpOutside {
    NSLog(@"在按钮外部抬起时...");
    
    //取消录制
    [_player cancelRecording];
    
    _recordingLoading.hidden = YES;
    _cancelHint.hidden = YES;
    SHOW_HINT(@"已取消本次录音");
    
    //播放动画组
    UIImageView * imageView = _radioRecordBtn.imageView;
    
    if (imageView.isAnimating) {
        [imageView stopAnimating];
    }
}

//从控件窗口内部拖动到外部时
-(void)touchDragExit {
    NSLog(@"控件窗口内部拖动到外部时...");
    _recordingLoading.hidden = YES;
    _cancelHint.hidden = NO;
}

//从控件窗口之外拖动到内部时
-(void)touchDragEnter {
    NSLog(@"从控件窗口之外拖动到内部时...");
    
    _recordingLoading.hidden = NO;
    _cancelHint.hidden = YES;
}
@end
