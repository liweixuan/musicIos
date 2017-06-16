#import <Foundation/Foundation.h>
#import "DynamicModel.h"

@interface DynamicFrame : NSObject

@property(nonatomic,strong)DynamicModel * dynamicModel;     //动态数据源
@property(nonatomic,assign)CGRect       headerUrlFrame;     //头像
@property(nonatomic,assign)CGRect       nickNameFrame;      //用户昵称
@property(nonatomic,assign)CGRect       sexIconFrame;       //性别图标
@property(nonatomic,assign)CGRect       sexFrame;           //性别内容
@property(nonatomic,assign)CGRect       locationIconFrame;  //地理位置图标
@property(nonatomic,assign)CGRect       locationFrame;      //地理位置信息
@property(nonatomic,assign)CGRect       categoryIconFrame;  //乐器类别图标
@property(nonatomic,assign)CGRect       contentFrame;       //动态内容
@property(nonatomic,assign)CGRect       imagesBoxFrame;     //图片容器
@property(nonatomic,assign)CGRect       videoBoxFrame;      //视频容器
@property(nonatomic,assign)CGRect       videoPlayerFrame;   //播放按钮
@property(nonatomic,assign)CGRect       audioBoxFrame;      //音频容器
@property(nonatomic,assign)CGSize       imagesSize;         //图片大小
@property(nonatomic,assign)CGRect       tagBoxFrame;        //标签容器
@property(nonatomic,assign)CGRect       actionBoxFrame;     //操作区域容器
@property(nonatomic,assign)CGRect       commentBoxFrame;    //评论容器
@property(nonatomic,assign)CGRect       zanBoxFrame;        //点赞容器
@property(nonatomic,assign)CGRect       concernBoxFrame;    //关注容器
@property(nonatomic,assign)CGRect       commentIconFrame;   //评论图标
@property(nonatomic,assign)CGRect       commentCountFrame;  //评论数量
@property(nonatomic,assign)CGRect       zanIconFrame;       //点赞图标
@property(nonatomic,assign)CGRect       zanCountFrame;      //点赞数量
@property(nonatomic,assign)CGRect       concernIconFrame;   //关注图标
@property(nonatomic,assign)CGRect       concernTextFrame;   //关注文字

@property(nonatomic,assign)CGFloat      cellHeight;         //行高度

-(instancetype)initWithDynamic:(DynamicModel *)model;

@end
