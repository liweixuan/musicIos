#import "NetWorkTools.h"

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

@end
