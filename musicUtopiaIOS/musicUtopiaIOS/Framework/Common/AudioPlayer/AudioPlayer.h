#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject
-(void)      startRecording;  //开始录制
-(NSString *)stopRecording;   //完成录制
-(void)      cancelRecording; //取消录制

-(void)      playAudio:(NSData *)audioData playTime:(NSInteger)time; //播放音频
-(void)      stopPlayAudio;   //停止播放

-(NSInteger) getAudioFileDuration:(NSString *)audiofilePath; //获取一个音频播放所需秒数
@end
