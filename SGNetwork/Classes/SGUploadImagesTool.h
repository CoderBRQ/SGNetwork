//
//  SGUploadImagesTool.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGUploadImagesTool : NSObject

/// 初始化方法
/// @param maxConcurrentRequestsCount 并发请求数
- (instancetype)initWithMaxConcurrentRequestsCount:(int)maxConcurrentRequestsCount;


/// 多张图片上传。每张图片一个请求，可以设置图片并发请求数
/// @param images 图片对象数组
/// @param urlString 服务器地址
/// @param fileID 文件标识
/// @param compressRate 压缩比
/// @param progress 上传进度
/// @param success 上传成功
/// @param failure 上传失败
- (void)uploadImages:(NSArray <UIImage *>*)images
           urlString:(NSString *)urlString
              fileID:(NSString *)fileID
        compressRate:(CGFloat)compressRate
            progress:(nullable void (^)(NSProgress *uploadProgress))progress
             success:(nullable void (^)(id _Nullable responseObject))success
             failure:(nullable void (^)(NSError *error))failure;

/// 单张图片上传
/// @param image 图片对象
/// @param urlString 服务器地址
/// @param fileID 文件标识
/// @param compressRate 压缩比；png 无法压缩
/// @param progress 上传进度
/// @param success 上传成功
/// @param failure 上传失败
- (void)uploadImage:(UIImage *)image
          urlString:(NSString *)urlString
             fileID:(NSString *)fileID
       compressRate:(CGFloat)compressRate
           progress:(nullable void (^)(NSProgress *uploadProgress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

 /// 取消上传
- (void)cancelUploadImagesRequest;
@end

NS_ASSUME_NONNULL_END
