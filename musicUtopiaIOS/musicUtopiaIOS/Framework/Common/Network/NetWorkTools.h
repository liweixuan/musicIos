@interface NetWorkTools : NSObject

+(AFHTTPSessionManager *)manager;

//GET请求
+(void)GET:(NSString *)url
    params:(NSDictionary *)param
    successBlock:(void (^)(NSArray *array))success
    errorBlock:(void (^)(NSString *error))errorInfo;

//POST请求
+(void)POST:(NSString *)url
    params:(NSDictionary *)param
successBlock:(void (^)(NSArray *array))success
errorBlock:(void (^)(NSString *error))errorInfo;

//单张图片上传结果，//单张图片上传
typedef void(^uploadImageRequestResults)(BOOL results,NSString *fileName);
+(void)uploadImage:(NSDictionary *)params Result:(uploadImageRequestResults)rs;

//多张图片上传结果，//多张图片上传
typedef void(^uploadMoreImageRequestResults)(BOOL results,NSArray *fileNames);
+(void)uploadMoreImage:(NSArray *)params Result:(uploadMoreImageRequestResults)rs;

//视频上传结果
typedef void(^uploadVideoRequestResults)(BOOL results,NSString *fileName);
+(void)uploadVideo:(NSDictionary *)params Result:(uploadVideoRequestResults)rs;

@end
