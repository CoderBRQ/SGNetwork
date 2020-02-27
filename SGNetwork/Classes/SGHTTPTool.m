//
//  SGHTTPTool.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import "SGHTTPTool.h"
#import "SGDefaultConfigHTTPSessionManager.h"

@implementation SGHTTPTool

- (void)GET:(NSString *)urlString
parameters:(nullable id)parameters
  progress:(nullable void (^)(NSProgress * _Nonnull progress))progress
   success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    [SGDefaultConfigHTTPSessionManager.sharedManager GET:urlString parameters:parameters progress:progress success:success failure:failure];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
    progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
//    [SGDefaultConfigHTTPSessionManager.sharedManager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
    
    [SGDefaultConfigHTTPSessionManager.sharedManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}
@end
