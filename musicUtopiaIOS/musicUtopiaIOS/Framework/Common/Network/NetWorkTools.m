#import "NetWorkTools.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "GCD.h"

@implementation NetWorkTools : NSObject


+(AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = NETWORK_TIMEOUT;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil,nil];
    return manager;
    
}

+(void)GET:(NSString *)url
      params:(NSDictionary *)param
successBlock:(void (^)(NSArray *array))success
  errorBlock:(void (^)(NSString *error))errorInfo {
    
    
    AFHTTPSessionManager *manager = [self manager];
    
    //判断是否开启请求指示器
    if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
        [NetWorkTools startNetworkActivityIndicator];
    }
    
    //网络请求地址打印
    NSLog(@"当前请求的接口地址为：%@",url);
    
    //发起数据请求
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
            [NetWorkTools endNetworkActivityIndicator];
        }
        
        BOOL isSuccess = [[responseObject objectForKey:@"success"] boolValue];

        if(isSuccess){
            
            NSArray * dataArr = [responseObject objectForKey:@"result"];
            
            success(dataArr);
            
        }else{
            
            NSString * message = [responseObject objectForKey:@"message"];
            
            errorInfo(message);
            
        }
        
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //是否需要关闭指示器
        if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
            [NetWorkTools endNetworkActivityIndicator];
        }
        
        NSLog(@"###%@",error);
        
        //将错误代码转化为内容
        NSString * errorMsg = [NetWorkTools requestErrorCode:error.code];
        errorInfo(errorMsg);
        
    }];
    
    
}

+(void)POST:(NSString *)url
    params:(NSDictionary *)param
successBlock:(void (^)(NSArray *array))success
errorBlock:(void (^)(NSString *error))errorInfo {
    
    
    AFHTTPSessionManager *manager = [self manager];
    
    //判断是否开启请求指示器
    if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
        [NetWorkTools startNetworkActivityIndicator];
    }
    
    //网络请求地址打印
    NSLog(@"当前请求的接口地址为：%@",url);
    
    //发起数据请求
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
            [NetWorkTools endNetworkActivityIndicator];
        }
        
        NSLog(@"%@",responseObject);
        
        BOOL isSuccess = [[responseObject objectForKey:@"success"] boolValue];
        
        if(isSuccess){
            
            NSArray * dataArr = [responseObject objectForKey:@"result"];
            
            success(dataArr);
            
        }else{
            
            NSString * message = [responseObject objectForKey:@"error"][@"message"];
            
            errorInfo(message);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //是否需要关闭指示器
        if(IS_SHOW_NETWORK_ACTIVITY_INDICATOR) {
            [NetWorkTools endNetworkActivityIndicator];
        }
        
        NSLog(@"###%@",error);

        errorInfo(@"网络请求错误，请检查您的网络");
        
    }];
    
    
}

+(void)startNetworkActivityIndicator {
    //开启指示器
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

+(void)endNetworkActivityIndicator {
    //关闭指示器
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

//错误代码转化函数
+(NSString *)requestErrorCode:(NSInteger)errorCode {
    
    NSString *errorInfo = nil;
    
    switch (errorCode) {
        case -1001:
            errorInfo = @"网络请求超时";
            break;
            
        default:
            break;
    }
    
    return errorInfo;
    
}

+(void)uploadImage:(NSDictionary *)params Result:(uploadImageRequestResults)rs {

    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKey secretKey:AliyunSecretKey];
    
    OSSClient * client        = [[OSSClient alloc] initWithEndpoint:AliyunEndpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName            = AliyunBucketName;
    int randomValue           = arc4random() % 99999;
    NSTimeInterval interval   = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * fileName       = [NSString stringWithFormat:@"%@/image%d-%d.%@",params[@"imageDir"],(int)interval,randomValue,@"png"];
    put.objectKey             = fileName;
    NSData * imageData        = UIImagePNGRepresentation(params[@"image"]);
    put.uploadingData         = imageData;
    OSSTask * putTask         = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            rs(YES,fileName);
            NSLog(@"upload object success!");
        } else {
            rs(NO,fileName);
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];


}

+(void)uploadMoreImage:(NSArray *)params Result:(uploadMoreImageRequestResults)rs {
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKey secretKey:AliyunSecretKey];
    
    //创建一个线程队列
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
    
    //保存上传成功后的临时文件名
    NSMutableArray * fileNameArr = [NSMutableArray array];
    
    __block NSInteger completedCount = 0;
    
    for(int i = 0;i<params.count;i++){
        
        NSDictionary *dict = params[i];
        
        //让线程在group中执行(线程1)
        [queue execute:^{
            
            OSSClient * client        = [[OSSClient alloc] initWithEndpoint:AliyunEndpoint credentialProvider:credential];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName            = AliyunBucketName;
            int randomValue           = arc4random() % 99999;
            NSTimeInterval interval   = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString * fileName       = [NSString stringWithFormat:@"%@/image%d-%d.%@",dict[@"imageDir"],(int)interval,randomValue,@"png"];
            put.objectKey             = fileName;
            NSData * imageData        = UIImagePNGRepresentation(dict[@"image"]);
            put.uploadingData         = imageData;
            OSSTask * putTask         = [client putObject:put];
            
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    [fileNameArr addObject:fileName];
                    completedCount++;
                    NSLog(@"已经完成:%ld/%lu",(long)completedCount,(unsigned long)params.count);
                    NSLog(@"upload object success!");
                } else {
                    
                    [fileNameArr addObject:@"None"];
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                
                
                if(fileNameArr.count == params.count){
                    
                    //检查是否有未上传成功的
                    for(int i=0;i<fileNameArr.count;i++){
                        if([fileNameArr[i] isEqualToString:@"None"]){
                            NSLog(@"文件有上传失败");
                            
                            rs(NO,nil);
                            
                            return nil;
                        }
                    }

                    rs(YES,fileNameArr);
                    NSLog(@"文件全部上传完成");
                }
                
                
                return nil;
            }];
        }];
    }

}



+(void)uploadVideo:(NSDictionary *)params Result:(uploadVideoRequestResults)rs {

    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKey secretKey:AliyunSecretKey];
    
    OSSClient * client        = [[OSSClient alloc] initWithEndpoint:AliyunEndpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName            = AliyunBucketName;
    int randomValue           = arc4random() % 99999;
    NSTimeInterval interval   = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * fileName       = [NSString stringWithFormat:@"%@/video%d-%d.%@",params[@"videoDir"],(int)interval,randomValue,@"mp4"];
    put.objectKey             = fileName;
    NSData * videoData        = params[@"video"];
    put.uploadingData         = videoData;
    OSSTask * putTask         = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            rs(YES,fileName);
            NSLog(@"upload object success!");
        } else {
            rs(NO,fileName);
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
    
}
@end
