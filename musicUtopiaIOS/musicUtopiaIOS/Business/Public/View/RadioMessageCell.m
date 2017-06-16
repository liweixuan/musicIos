#import "RadioMessageCell.h"
#import "AudioPlayer.h"

@interface RadioMessageCell()
{
    UILabel     * _messagetimeView;
    UIImageView * _headerView;
    UIImageView * _chatBubbleView;
    UILabel     * _messageLengthView;
    UIImageView * _radioPlayerView;
    
    RadioMessageFrame * _nowFrame; //当前的数据
}
@end

@implementation RadioMessageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //背景色
        self.contentView.backgroundColor = HEX_COLOR(VC_BG);
        
        _messagetimeView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentCenter)
            .L_AddView(self.contentView);
        }];
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv.L_AddView(self.contentView);
        }];
        
        _chatBubbleView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Event(YES)
            .L_Click(self,@selector(radioClick))
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_AddView(self.contentView);
        }];
        
        _messageLengthView = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_chatBubbleView);
        }];
        
        _radioPlayerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_chatBubbleView);
        }];
        
        
    }
    return self;
}

-(void)setFrameData:(RadioMessageFrame *)frameData {
    
    _nowFrame = frameData;
    
    //设置时间位置
    _messagetimeView.frame = frameData.messageTimeFrame;
    _messagetimeView.L_Text(frameData.radioMessageModel.messageReceiveTime);
    
    //设置头像位置+数据
    _headerView.frame = frameData.headerFrame;
    [MemberInfoData getMemberInfo:frameData.radioMessageModel.messageSendUser MemberEnd:^(NSDictionary *memberInfo) {
        
        NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,memberInfo[@"m_headerUrl"]];
        _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
        _headerView.L_Round();
    }];
    
    //聊天气泡
    UIImage * bubbleImage = nil;
    
    //设置按钮视图背景
    _chatBubbleView.frame = frameData.chatBubbleFrame;
    
    
    if(frameData.radioMessageModel.messageDirection == 1){
        bubbleImage = [UIImage imageNamed:@"right_bubble"];
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.2 topCapHeight:bubbleImage.size.height * 0.8];
    }else{
        bubbleImage = [UIImage imageNamed:@"left_bubble"];
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.8 topCapHeight:bubbleImage.size.height * 0.8];
    }
    
    //消息时长
    _messageLengthView.frame = frameData.messageLengthFrame;
    _messageLengthView.L_Text([NSString stringWithFormat:@"%ld''",(long)frameData.radioMessageModel.radioLength]);
    
    //消息图标
    if(frameData.radioMessageModel.messageDirection == 1){
        _radioPlayerView.frame = frameData.radioPlayerIconFrame;
        _radioPlayerView.L_ImageName(@"radio_right_3");
    }else{
        _radioPlayerView.frame = frameData.radioPlayerIconFrame;
        _radioPlayerView.L_ImageName(@"radio_left_3");
    }

}

//点击语音消息
-(void)radioClick {
    NSLog(@"点击语音消息...");
 
    NSData * audioData = _nowFrame.radioMessageModel.radioData;
 
    AudioPlayer * audioPlayer = [[AudioPlayer alloc] init];
    [audioPlayer playAudio:audioData playTime:_nowFrame.radioMessageModel.radioLength];

    [_radioPlayerView stopAnimating];
    
    NSArray * animates = [NSArray array];

    //根据方向播放
    if(_nowFrame.radioMessageModel.messageDirection == 1){
        
        animates = @[
                     [UIImage imageNamed:@"radio_right_1"],
                     [UIImage imageNamed:@"radio_right_2"],
                     [UIImage imageNamed:@"radio_right_3"]];
        
    }else{
        
        animates = @[
                     [UIImage imageNamed:@"radio_left_1"],
                     [UIImage imageNamed:@"radio_left_2"],
                     [UIImage imageNamed:@"radio_left_3"]];
        
        
    }
    
    
    _radioPlayerView.animationImages = animates;
    _radioPlayerView.animationDuration = 1;
    _radioPlayerView.animationRepeatCount = 0;
    [_radioPlayerView startAnimating];
    
    NSInteger radioLength = (_nowFrame.radioMessageModel.messageDirection + 1);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(radioLength * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_radioPlayerView stopAnimating];
        
        if(_nowFrame.radioMessageModel.messageDirection == 1){
            _radioPlayerView.L_ImageName(@"radio_right_3");
        }else{
            _radioPlayerView.L_ImageName(@"radio_left_3");
        }
        
    });
    
    
}

@end
