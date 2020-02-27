//
//  SGHTTPTool.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGHTTPTool : NSObject

- (void)GET:(NSString *)urlString
 parameters:(nullable id)parameters
   progress:(nullable void (^)(NSProgress * _Nonnull progress))progress
    success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
    progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
