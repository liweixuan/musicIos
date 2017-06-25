#import "PrivateChatViewController.h"
#import "VideoRecordingViewController.h"
#import "ChatView.h"

@interface PrivateChatViewController ()<ChatViewDelegate,VideoRecordingDelegate,UINavigationControllerDelegate>
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
    
    //监听接收消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:@"RECEIVED_RCMESSAGE" object:nil];
    
}

-(void)goBack {
    NSLog(@"后退...");
}

//初始化变量
-(void)initVar {
    _messageData = [NSMutableArray array];
}


//初始化数据
-(void)initData {

    //获取当前会话的消息数据
    NSArray * tempData = [[RongCloudData getCoversationMessage:self.target ConversationType:ConversationType_PRIVATE Count:20] mutableCopy];
    
    //修改消息状态为已读
    [RongCloudData readConversationAllMessage:self.target ConversationType:ConversationType_PRIVATE];
    
    //模拟获取聊天数据
    for(int i = 0;i<tempData.count;i++){
        
        RCMessage * message = tempData[i];
        
        id frameData = [self formatMessageModel:message];
        
        [_messageData insertObject:frameData atIndex:0];
        
    }
    
    _chatView.messageData = _messageData;
}


//创建导航按钮
-(void)createNav {
    
    R_NAV_TITLE_BTN(@"R",@"清除消息",clearMessage)
    
}

//创建聊天视图
-(void)createChatView {
    

    _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT_NO_NAV)];
    _chatView.delegate = self;
    [self.view addSubview:_chatView];
    
}

#pragma mark - 相关代理

//获取历史消息
-(void)getHistoryMessage {
    NSLog(@"获取历史消息...");
    
    //截至的消息ID
    id message = [_messageData firstObject];

    long messageId = 0;
    
    //获取历史消息ID
    if([message isKindOfClass:[TextMessageFrame class]]){
        TextMessageFrame * frame = (TextMessageFrame * )message;
        messageId =  frame.textMessageModel.messageId;
    }else if([message isKindOfClass:[ImageMessageFrame class]]){
        ImageMessageFrame * frame = (ImageMessageFrame * )message;
        messageId =  frame.imageMessageModel.messageId;
    }else if([message isKindOfClass:[RadioMessageFrame class]]){
        RadioMessageFrame * frame = (RadioMessageFrame * )message;
        messageId =  frame.radioMessageModel.messageId;
    }
    
    
    NSArray * tempArr = [[RongCloudData getCoversationHistroyMessage:self.target ConversationType:ConversationType_PRIVATE oldestMessageId:messageId Count:20] mutableCopy];
    
    if(tempArr.count<=0){
        SHOW_HINT(@"已无更多历史消息");
        _chatView.historyData = @[];
        return;
    }
    
    for(int i=0;i<tempArr.count;i++){
        
       id frame =  [self formatMessageModel:tempArr[i]];
        [_messageData insertObject:frame atIndex:0];
        
    }
    
    

    _chatView.historyData = _messageData;
}

//发送文本消息消息
-(void)sendTextMessage:(NSString *)messageStr {
    
    
    //构建文本消息
    RCTextMessage * textMessage = [[RCTextMessage alloc] init];
    textMessage.content         = messageStr;
    
    //发送消息
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.target content:textMessage pushContent:nil pushData:nil success:^(long messageId) {
       
        NSLog(@"%ld",messageId);
        
        //创建本地UI
        long nowTime = [[NSDate date] timeIntervalSince1970];
        NSDictionary * messageDict  = @{
                                        @"type"               : @"TEXT",
                                        @"messageStr"         : messageStr,
                                        @"messageDirection"   : @(1),
                                        @"messageSendUser"    : [UserData getUsername],
                                        @"messageReceiveTime" : @(nowTime),
                                        @"rcMessage"          : @""
                                        };
        TextMessageModel * textMessageModel = [TextMessageModel textMessageWithDict:messageDict];
        TextMessageFrame * frame            = [[TextMessageFrame alloc] initWithTextMessage:textMessageModel];
        [_messageData addObject:frame];
        
        _chatView.messageData = _messageData;
        
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"消息发送失败...");
        NSLog(@"%ld",nErrorCode);
        NSLog(@"%ld",messageId);
    }];
    
    
    
    

    
    
}

//发送图片消息
-(void)sendImageMessage:(NSArray *)images {
    NSLog(@"发送图片消息...");
    
    
    
    for(int i =0;i<images.count;i++){
        
        RCImageMessage * imageMessage = [RCImageMessage messageWithImage:images[i]];
        
        //发送消息
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.target content:imageMessage pushContent:nil pushData:nil success:^(long messageId) {
            
            NSLog(@"%ld",messageId);
            long nowTime = [[NSDate date] timeIntervalSince1970];
            NSDictionary * messageDict = @{
                                           @"type"               : @"IMAGE",
                                           @"messageImage"       : images[i],
                                           @"messageDirection"   : @(1),
                                           @"messageSendUser"    : [UserData getUsername],
                                           @"messageReceiveTime" : @(nowTime),
                                           @"rcMessage"          : @""
                                           };
            ImageMessageModel * imageMessageModel = [ImageMessageModel ImageMessageWithDict:messageDict];
            ImageMessageFrame * frame            = [[ImageMessageFrame alloc] initWithImageMessage:imageMessageModel];
            [_messageData addObject:frame];
            
            _chatView.messageData = _messageData;
            
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"消息发送失败...");
            NSLog(@"%ld",nErrorCode);
            NSLog(@"%ld",messageId);
        }];
        
        
        
    }
    
    
    
    
}

//发送语音消息
-(void)sendRadioMessage:(NSData *)radioData TimeLength:(NSInteger)length {
    
    RCVoiceMessage * voiceMessage = [RCVoiceMessage messageWithAudio:radioData duration:length];

    
    //发送消息
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.target content:voiceMessage pushContent:nil pushData:nil success:^(long messageId) {
        
        NSLog(@"%ld",messageId);
        long nowTime = [[NSDate date] timeIntervalSince1970];
        NSDictionary * messageDict = @{
                                       @"type"               : @"RADIO",
                                       @"radioData"          : radioData,
                                       @"radioLength"        : @(length),
                                       @"messageDirection"   : @(1),
                                       @"messageSendUser"    : [UserData getUsername],
                                       @"messageReceiveTime" : @(nowTime),
                                       @"rcMessage"          : @""
                                       };
        RadioMessageModel * radioMessageModel = [RadioMessageModel RadioMessageWithDict:messageDict];
        RadioMessageFrame * frame             = [[RadioMessageFrame alloc] initWithRadioMessage:radioMessageModel];
        [_messageData addObject:frame];
        
        _chatView.messageData = _messageData;
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"消息发送失败...");
        NSLog(@"%ld",nErrorCode);
        NSLog(@"%ld",messageId);
    }];
    
    
    
}

//跳转至视频录制界面
-(void)goVideoRecord {
    VideoRecordingViewController * videoRecordVC = [[VideoRecordingViewController alloc] init];
    videoRecordVC.delegate = self;
    [self presentViewController:videoRecordVC animated:YES completion:nil];
}

//发送小视频
-(void)sendVideo:(NSString *)videoPath {
    
    
    
    
    
    
}

-(void)clearMessage {
    NSLog(@"清除消息...");
    [RongCloudData removeConversationAllMessage:self.target ConversationType:ConversationType_PRIVATE];
    
    [_messageData removeAllObjects];
    _chatView.messageData = _messageData;
}

#pragma mark - 融云消息接收
-(void)receivedMessage:(NSNotification *)sender {
 
    //获取消息
    RCMessage * message = sender.userInfo[@"message"];

    id frameData =  [self formatMessageModel:message];
    
    [_messageData addObject:frameData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _chatView.messageData = _messageData;
    });
    
    //修改消息状态为已读
    [RongCloudData readMessage:message.messageId];
    
    
}

#pragma mark - 私有方法
-(id)formatMessageModel:(RCMessage *)message {
    
    //构建消息数据源
    if([message.objectName isEqualToString:@"RC:TxtMsg"]){
        
        RCTextMessage * textMessage = (RCTextMessage *)message.content;
        
        
        //构建数据源
        NSDictionary * dictData = @{
                                    @"type"             : @"TEXT",
                                    @"messageId"        : @(message.messageId),
                                    @"messageSendUser"  : message.senderUserId,
                                    @"messageStr"       : textMessage.content,
                                    @"messageDirection" : @(message.messageDirection),
                                    @"messageReceiveTime" : @(message.receivedTime/1000),
                                    @"rcMessage"        : message
                                    };
        
        
        //取出当前信息
        TextMessageModel * textMessageModel = [TextMessageModel textMessageWithDict:dictData];
        TextMessageFrame * frame            = [[TextMessageFrame alloc] initWithTextMessage:textMessageModel];
        
        return frame;
        
    }else if([message.objectName isEqualToString:@"RC:ImgMsg"]) {
        
        
        RCImageMessage * imageMessage = (RCImageMessage *)message.content;
        
        NSLog(@"!!!!!%@",imageMessage.thumbnailImage);
        
        //构建数据源
        NSDictionary * dictData = @{
                                    @"type"                 : @"IMAGE",
                                    @"messageId"        : @(message.messageId),
                                    @"messageImage"       : imageMessage.thumbnailImage,
                                    @"messageSendUser"  : message.senderUserId,
                                    @"messageDirection" : @(message.messageDirection),
                                    @"messageReceiveTime" : @(message.receivedTime/1000),
                                    @"rcMessage"        : message
                                    };
        
        ImageMessageModel * imageMessageModel = [ImageMessageModel ImageMessageWithDict:dictData];
        ImageMessageFrame * frame             = [[ImageMessageFrame alloc] initWithImageMessage:imageMessageModel];
        
        return frame;
        
        
    }else if([message.objectName isEqualToString:@"RC:VcMsg"]){
        
        RCVoiceMessage * voiceMessage = (RCVoiceMessage *)message.content;
        
        //构建数据源
        NSDictionary * dictData = @{
                                    @"type"                 : @"RADIO",
                                    @"messageId"        : @(message.messageId),
                                    @"radioData"        : voiceMessage.wavAudioData,
                                    @"messageSendUser"  : message.senderUserId,
                                    @"radioLength"      : @(voiceMessage.duration),
                                    @"messageDirection" : @(message.messageDirection),
                                    @"messageReceiveTime" : @(message.receivedTime/1000),
                                    @"rcMessage"            : message
                                    };
        
        RadioMessageModel * radioMessageModel = [RadioMessageModel RadioMessageWithDict:dictData];
        RadioMessageFrame * frame             = [[RadioMessageFrame alloc] initWithRadioMessage:radioMessageModel];
        
        return frame;
    
    }
    
    return nil;
}


@end
