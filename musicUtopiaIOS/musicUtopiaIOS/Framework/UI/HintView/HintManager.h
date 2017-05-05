#import <Foundation/Foundation.h>


typedef void(^hintClick)();
@interface HintManager : NSObject
@property (nonatomic,strong) hintClick hintClick;
+(HintManager *)sharedManager;
-(void)infoMessage:(NSString *)msg;
-(void)errorMessage:(NSString *)msg;
-(void)warningMessage:(NSString *)msg;
-(void)successMessage:(NSString *)msg;
@end
