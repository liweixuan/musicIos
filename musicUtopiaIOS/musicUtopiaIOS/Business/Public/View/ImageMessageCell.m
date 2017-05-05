//
//  ImageMessageCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ImageMessageCell.h"
#import "UUImageAvatarBrowser.h"
#import "PhotoMessageViewController.h"

@interface ImageMessageCell()
{
    UILabel     * _messagetimeView;
    UIImageView * _headerView;
    UIImageView * _chatBubbleView;
    UIImageView * _contentImageView;
}
@end

@implementation ImageMessageCell

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
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_AddView(self.contentView);
        }];
        
        _contentImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Event(YES)
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_radius(5)
            .L_AddView(_chatBubbleView);
        }];
        
       
        
    }
    return self;
}

-(void)setFrameData:(ImageMessageFrame *)frameData {
    
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
    
    
    if(frameData.imageMessageModel.tempMessageDirection == 1){
        bubbleImage = [UIImage imageNamed:@"right_bubble"];
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.2 topCapHeight:bubbleImage.size.height * 0.8];
    }else{
        bubbleImage = [UIImage imageNamed:@"left_bubble"];
        _chatBubbleView.image = [bubbleImage stretchableImageWithLeftCapWidth:bubbleImage.size.width*0.8 topCapHeight:bubbleImage.size.height * 0.8];
    }
    
    
    _contentImageView.frame = frameData.chatContentFrame;
    _contentImageView.L_Click(self,@selector(imageContentClick:));
    if(frameData.imageMessageModel.tempMessageImage!=nil){
        _contentImageView.L_Image(frameData.imageMessageModel.tempMessageImage);
    }else{
       _contentImageView.L_ImageUrlName(frameData.imageMessageModel.tempMessageUrl,IMAGE_DEFAULT);
    }

    
    

}


-(void)imageContentClick:(UITapGestureRecognizer *)tap {
    //[UUImageAvatarBrowser showImage:(UIImageView *)tap.view];
    UIImageView * imageView =  (UIImageView *)tap.view;
    PhotoMessageViewController *photoVC = [[PhotoMessageViewController alloc] init];
    photoVC.imageType = 2;
    photoVC.imageData = imageView.image;
    
    photoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[self viewController] presentViewController:photoVC animated:YES completion:nil];
}


- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

@end
