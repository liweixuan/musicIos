#import <Foundation/Foundation.h>
#import "RadioMessageModel.h"

@interface RadioMessageFrame : NSObject
@property(nonatomic,strong)RadioMessageModel * radioMessageModel; //动态数据源

@property(nonatomic,assign)CGRect   messageTimeFrame;     //发送或接收时间
@property(nonatomic,assign)CGRect   headerFrame;          //头像位置
@property(nonatomic,assign)CGRect   chatBubbleFrame;      //聊天气泡位置
@property(nonatomic,assign)CGRect   messageLengthFrame;   //消息时长
@property(nonatomic,assign)CGRect   radioPlayerIconFrame; //语音播放图标

@property(nonatomic,assign)CGFloat  cellHeight;          //行高度


-(instancetype)initWithRadioMessage:(RadioMessageModel *)model;
@end
