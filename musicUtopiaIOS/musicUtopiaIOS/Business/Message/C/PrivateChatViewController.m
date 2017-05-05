#import "PrivateChatViewController.h"
#import "ChatView.h"

@interface PrivateChatViewController ()<ChatViewDelegate>
{
    ChatView       * _chatView;     //聊天视图
    NSMutableArray * _messageData;  //聊天数据
}
@end

@implementation PrivateChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私聊";
    
    //初始化变量
    [self initVar];

    //创建导航按钮
    [self createNav];
    
    //创建聊天视图
    [self createChatView];

    //初始化数据
    [self initData];
    
}

//初始化变量
-(void)initVar {
    
    _messageData = [NSMutableArray array];
    
}

//初始化数据
-(void)initData {
    
    NSArray * tempData = @[
                          @{@"type":@"TEXT",@"tempMessageStr":@"你好啊！你在干啥",@"tempMessageDirection":@(1)},
                        @{@"type":@"TEXT",@"tempMessageStr":@"4月20日，李克强总理在考察威海孙家疃医院时就强调了医",@"tempMessageDirection":@(1)},
                        @{@"type":@"TEXT",@"tempMessageStr":@"4月20日，李克强总理在考察威海孙家疃医院时就强调了医联体的重要作用：中医讲通则不痛"},
                        @{@"type":@"TEXT",@"tempMessageStr":@"此次指导意见所言明的医联体的重要性不言而喻，也对医联体的功能与目标进一步做了明确。医联体最重要的目的是要将优质医疗资源“下沉”，要求试点省份的三级公立医院要全部参与并发挥引领作用，每个地市以及分级诊疗试点城市至少建成一个有明显成效的医联体",@"tempMessageDirection":@(2)},
                        @{@"type":@"TEXT",@"tempMessageStr":@"恩",@"tempMessageDirection":@(1)},
                          @{@"type":@"TEXT",@"tempMessageStr":@"88",@"tempMessageDirection":@(1)},
                        @{@"type":@"IMAGE",@"tempMessageUrl":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493893371514&di=9c2d63e27f3bbcf180f444465b96912a&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F0823dd54564e925833e00f0b9a82d158cdbf4e7b.jpg",@"tempMessageDirection":@(1)},
                        @{@"type":@"IMAGE",@"tempMessageUrl":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493893404161&di=954dfc9cc0699b58453f1433872998ac&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201501%2F06%2F20150106081156_ziGRT.jpeg",@"tempMessageDirection":@(2)}
                        ];
    
    //模拟获取聊天数据
    for(int i = 0;i<tempData.count;i++){
        
        NSDictionary * dictData = tempData[i];


        if([dictData[@"type"] isEqualToString:@"TEXT"]){
            
            TextMessageModel * textMessageModel = [TextMessageModel textMessageWithDict:dictData];
            TextMessageFrame * frame            = [[TextMessageFrame alloc] initWithTextMessage:textMessageModel];
            [_messageData addObject:frame];
            
        }else if([dictData[@"type"] isEqualToString:@"IMAGE"]){
            
            ImageMessageModel * imageMessageModel = [ImageMessageModel ImageMessageWithDict:dictData];
            ImageMessageFrame * frame             = [[ImageMessageFrame alloc] initWithImageMessage:imageMessageModel];
            [_messageData addObject:frame];
            
            
        }
        
        
        
    }
    
    _chatView.messageData = _messageData;
 
}


//创建导航按钮
-(void)createNav {
    
}

//创建聊天视图
-(void)createChatView {
    
    _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT_NO_NAV)];
    _chatView.delegate = self;
    [self.view addSubview:_chatView];
    
}

#pragma mark - 相关代理

//发送文本消息消息
-(void)sendTextMessage:(NSString *)messageStr {

    NSDictionary * messageDict          = @{@"tempMessageStr":messageStr,@"tempMessageDirection":@(1)};
    TextMessageModel * textMessageModel = [TextMessageModel textMessageWithDict:messageDict];
    TextMessageFrame * frame            = [[TextMessageFrame alloc] initWithTextMessage:textMessageModel];
    [_messageData addObject:frame];
    
    _chatView.messageData = _messageData;
    
}

//发送图片消息
-(void)sendImageMessage:(NSArray *)images {
    NSLog(@"发送图片消息...");
    
    for(int i =0;i<images.count;i++){
        
        NSDictionary * messageDict = @{@"tempMessageImage":images[i],@"tempMessageDirection":@(1)};
        ImageMessageModel * imageMessageModel = [ImageMessageModel ImageMessageWithDict:messageDict];
        ImageMessageFrame * frame            = [[ImageMessageFrame alloc] initWithImageMessage:imageMessageModel];
        [_messageData addObject:frame];
        
    }
    
    _chatView.messageData = _messageData;
    
    
}


@end
