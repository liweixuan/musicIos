#import "TextMessageCell.h"

@interface TextMessageCell()
{
    UILabel     * _messagetimeView;
    UIImageView * _headerView;
    UIImageView * _chatBubbleView;
    UILabel     * _chatContentView;
}
@end

@implementation TextMessageCell

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
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_AddView(self.contentView);
        }];
        
        _chatContentView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(SUBTITLE_FONT_SIZE)
            .L_numberOfLines(-1)
            .L_AddView(_chatBubbleView);
        }];
        
    }
    return self;
}

-(void)setFrameData:(TextMessageFrame *)frameData {
    
    //设置时间位置
    _messagetimeView.frame = frameData.messageTimeFrame;
    _messagetimeView.L_Text(@"05-11 12:12");
    
    //设置头像位置+数据
    _headerView.frame = frameData.headerFrame;
    _headerView.L_ImageName(HEADER_DEFAULT);
    
    //聊天气泡
    UIImage * bubbleImage = nil;
    
    //设置按钮视图背景
    _chatBubbleView.frame = frameData.chatBubbleFrame;
    
    
    if(frameData.textMessageModel.tempMessageDirection == 1){
        bubbleImage = [UIImage imageNamed:@"right_bubble"];
        _chatContentView.L_TextColor([UIColor whiteColor]);
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.2 topCapHeight:bubbleImage.size.height * 0.8];
    }else{
        bubbleImage = [UIImage imageNamed:@"left_bubble"];
        _chatContentView.L_TextColor(HEX_COLOR(@"666666"));
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.8 topCapHeight:bubbleImage.size.height * 0.8];
    }

    
    _chatContentView.frame = frameData.chatContentFrame;
    _chatContentView.L_Text(frameData.textMessageModel.tempMessageStr);
    _chatContentView.L_lineHeight(CONTENT_LINE_HEIGHT);
    [_chatContentView sizeToFit];
    
}

@end
