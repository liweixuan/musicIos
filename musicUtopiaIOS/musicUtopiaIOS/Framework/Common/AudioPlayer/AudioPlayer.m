#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer()
{
    AVAudioRecorder * _recorder;     //录制对象
    AVAudioPlayer   * _player;       //播放对象
    
    NSString        * _tempFileName; //临时文件名
}
@end

@implementation AudioPlayer

#pragma mark - 开始录制
-(void)startRecording {

    _tempFileName = [self getRandomStr];
    
    NSString * filePath = [NSString stringWithFormat:@"%@/%@.caf",[self documentsDirectory],_tempFileName];
    NSURL    * fileUrl  = [NSURL fileURLWithPath:filePath];

    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                               AVSampleRateKey: @8000.00f,
                               AVNumberOfChannelsKey: @1,
                               AVLinearPCMBitDepthKey: @16,
                               AVLinearPCMIsNonInterleaved: @NO,
                               AVLinearPCMIsFloatKey: @NO,
                               AVLinearPCMIsBigEndianKey: @NO};
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:settings error:&error];
    
    if(_recorder.isRecording) {
        return;
    }
    
    [_recorder record];
}

#pragma mark - 录制完成
-(NSString *)stopRecording {
    
    [_recorder stop];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf",[self documentsDirectory],_tempFileName];
    NSLog(@"path:%@",filePath);
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSData *avdio = [NSData dataWithContentsOfURL:fileUrl];
    if(avdio!=nil){
        NSLog(@"录制成功");
        return filePath;
    }
    NSLog(@"录制失败");
    return nil;
}

#pragma mark - 取消录制
-(void)cancelRecording {
    [_recorder stop];
    [_recorder deleteRecording];
}

#pragma mark - 获取一个音频文件的所需秒数
-(NSInteger)getAudioFileDuration:(NSString *)audiofilePath {
    
    NSError * err;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audiofilePath] error:&err];
    float duration = (float)_player.duration;
    
    return (int)duration;
}

#pragma mark - 返回将时间戳作为的随机串
-(NSString *)getRandomStr {
    CGFloat    ramdomFloat  = [[NSDate date] timeIntervalSince1970];
    NSString * randomNumber = [NSString stringWithFormat:@"%.0f",ramdomFloat];
    return randomNumber;
}



#pragma mark - 获取沙盒documents目录
-(NSString *)documentsDirectory {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *createPath = [NSString stringWithFormat:@"%@/audioDataDir", [paths objectAtIndex:0]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    return createPath;
}

-(void)playAudio:(NSData *)audioData playTime:(NSInteger)time {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    _player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    NSLog(@"error:%@",error);
    BOOL isplay = [_player play];
    NSLog(@"播放状态:%d",isplay);
}

-(void)stopPlayAudio {
    [_player stop];
}
@end
