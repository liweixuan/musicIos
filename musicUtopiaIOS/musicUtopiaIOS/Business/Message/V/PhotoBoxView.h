#import "Base_UIView.h"

@protocol PhotoBoxViewDelegate <NSObject>

//恢复底部工具位置
-(void)resetBottomTool;

//发送图片数据
-(void)sendImageData:(NSArray *)images;

@end

@interface PhotoBoxView : Base_UIView
@property(nonatomic,strong)id<PhotoBoxViewDelegate> delegate;
@end
