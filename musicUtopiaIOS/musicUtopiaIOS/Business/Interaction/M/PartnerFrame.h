#import <Foundation/Foundation.h>
#import "PartnerModel.h"

@interface PartnerFrame : NSObject

@property(nonatomic,strong)PartnerModel * partnerModel;     //动态数据源
@property(nonatomic,assign)CGRect       headerUrlFrame;     //头像
@property(nonatomic,assign)CGRect       nickNameFrame;      //用户昵称
@property(nonatomic,assign)CGRect       sexIconFrame;       //性别图标
@property(nonatomic,assign)CGRect       sexFrame;           //性别内容
@property(nonatomic,assign)CGRect       locationIconFrame;  //地理位置图标
@property(nonatomic,assign)CGRect       locationFrame;      //地理位置信息
@property(nonatomic,assign)CGRect       tagBoxFrame;        //标签容器
@property(nonatomic,assign)CGRect       titleFrame;         //找伙伴标题
@property(nonatomic,assign)CGRect       contentFrame;       //找伙伴内容
@property(nonatomic,assign)CGRect       askIconFrame;       //伙伴要求图标
@property(nonatomic,assign)CGRect       askFrame;           //伙伴要求文字
@property(nonatomic,assign)CGRect       askContentBoxFrame; //伙伴要求内容容器
@property(nonatomic,assign)CGRect       actionBoxFrame;     //操作容器

@property(nonatomic,assign)CGFloat      cellHeight;         //行高度

-(instancetype)initWithPartner:(PartnerModel *)model;

@end
