//
//  SGUploadImagesTool.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/15.
//

#import "SGUploadImagesTool.h"
#import "SGDefaultConfigHTTPSessionManager.h"

@interface SGUploadImagesTool ()
@property (nonatomic, assign) int maxConcurrentRequestsCount;
@property (nonatomic, strong) dispatch_semaphore_t sem;
@end

@implementation SGUploadImagesTool

- (instancetype)init {
    return [self initWithMaxConcurrentRequestsCount:0];
}

- (instancetype)initWithMaxConcurrentRequestsCount:(int)maxConcurrentRequestsCount {
    NSAssert(maxConcurrentRequestsCount >= 0, @"请求并发数不得小于零");
    self = [super init];
    if (self) {
        if (maxConcurrentRequestsCount == 0) {
            self.sem = dispatch_semaphore_create(4);
        }else {
            self.sem = dispatch_semaphore_create(maxConcurrentRequestsCount - 1);
        }
    }
    return self;
}

- (void)uploadImage:(UIImage *)image
          urlString:(NSString *)urlString
             fileID:(NSString *)fileID
       compressRate:(CGFloat)compressRate
           progress:(nullable void (^)(NSProgress *uploadProgress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
        
    [SGDefaultConfigHTTPSessionManager.sharedManager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        static long i = 0;
        NSData *imageData;
        if(UIImagePNGRepresentation(image)){
            imageData = UIImagePNGRepresentation(image);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:[NSString stringWithFormat:@"%@%ld", @"yyyyMMddHHmmss", i++]];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
            [formData appendPartWithFileData:imageData name:fileID fileName:fileName mimeType:@"png"];
        }else {
            imageData = UIImageJPEGRepresentation(image,compressRate);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:[NSString stringWithFormat:@"%@%ld", @"yyyyMMddHHmmss", i++]];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            [formData appendPartWithFileData:imageData name:fileID fileName:fileName mimeType:@"jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

- (void)uploadImages:(NSArray<UIImage *> *)images
           urlString:(NSString *)urlString
              fileID:(NSString *)fileID
        compressRate:(CGFloat)compressRate
            progress:(void (^)(NSProgress * _Nonnull))progress
             success:(void (^)(id _Nullable))success
             failure:(void (^)(NSError * _Nonnull))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (long  i = images.count - 1; i >= 0; i--) {
            [self uploadImage:images[i] urlString:urlString fileID:fileID compressRate:compressRate progress:^(NSProgress * _Nonnull uploadProgress) {
                progress(uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_semaphore_signal(self->_sem);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self cancelUploadImagesRequest];
                failure(error);
            }];
            dispatch_semaphore_wait(self->_sem, DISPATCH_TIME_FOREVER);
        }
        success(@"上传成功");
    });
}

- (void)cancelUploadImagesRequest {
    [SGDefaultConfigHTTPSessionManager.sharedManager.operationQueue cancelAllOperations];
}
@end
