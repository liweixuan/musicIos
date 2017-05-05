#import "CreateChatroomViewController.h"

@interface CreateChatroomViewController ()
{
    UIImageView * _uploadImageView;
    UITextField * _roomName;
}
@end

@implementation CreateChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建聊天室";
    
    //创建导航按钮
    [self createNav];
    
    //创建视图
    [self createView];
}


//创建视图
-(void)createView {
    
    
    //上传视图
    _uploadImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
        imgv
        .L_Frame(CGRectMake(D_WIDTH/2 - 90/2,30, 90, 90))
        .L_ImageName(IMAGE_DEFAULT)
        .L_AddView(self.view);
    }];
    
    //上传标题
    UILabel * uploadTitle = [UILabel LabelinitWith:^(UILabel *la) {
       la
        .L_Frame(CGRectMake(0, [_uploadImageView bottom]+CONTENT_PADDING_TOP, D_WIDTH,SUBTITLE_FONT_SIZE))
        .L_Text(@"聊天室头像")
        .L_Font(SUBTITLE_FONT_SIZE)
        .L_textAlignment(NSTextAlignmentCenter)
        .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
        .L_AddView(self.view);
    }];
    
    //聊天室名称
    _roomName = [UITextField TextFieldInitWith:^(UITextField *text) {
       text
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT, [uploadTitle bottom]+20,D_WIDTH - CARD_MARGIN_LEFT * 2, TEXTFIELD_HEIGHT))
        .L_Placeholder(@"聊天室名称")
        .L_BgColor([UIColor whiteColor])
        .L_Font(TEXTFIELD_FONT_SIZE)
        .L_PaddingLeft(CONTENT_PADDING_LEFT)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_ShadowColor([UIColor grayColor])
        .L_shadowOpacity(0.2)
        .L_radius_NO_masksToBounds(5)
        .L_AddView(self.view);
    }];
    
    
}


//创建导航按钮
-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"保存",saveChatRoom);
}

#pragma mark - 事件
-(void)saveChatRoom {
    NSLog(@"开始创建聊天室...");
}

@end
