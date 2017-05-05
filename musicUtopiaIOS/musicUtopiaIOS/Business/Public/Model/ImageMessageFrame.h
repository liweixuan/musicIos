#import <Foundation/Foundation.h>
#import "ImageMessageModel.h"

@interface ImageMessageFrame : NSObject
@property(nonatomic,strong)ImageMessageModel * imageMessageModel; //动态数据源

@property(nonatomic,assign)CGRect   messageTimeFrame;    //发送或接收时间
@property(nonatomic,assign)CGRect   headerFrame;         //头像位置
@property(nonatomic,assign)CGRect   chatBubbleFrame;     //聊天气泡位置
@property(nonatomic,assign)CGRect   chatContentFrame;    //聊天内容位置

@property(nonatomic,assign)CGFloat  cellHeight;          //行高度


-(instancetype)initWithImageMessage:(ImageMessageModel *)model;
@end
