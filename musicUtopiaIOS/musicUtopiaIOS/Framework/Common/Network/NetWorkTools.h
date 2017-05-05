@interface NetWorkTools : NSObject

+(AFHTTPSessionManager *)manager;

+(void)GET:(NSString *)url
    params:(NSDictionary *)param
    successBlock:(void (^)(NSArray *array))success
    errorBlock:(void (^)(NSString *error))errorInfo;



@end
