//
//  SGDownloadFileTool.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/15.
//

#import "SGDownloadFileTool.h"
#import "SGDefaultConfigURLSessionManager.h"
#import "SGBackgroundConfigHTTPSessionManager.h"
#import "SGNetworkFileHander.h"

NSNotificationName const SGDownloadFileProgressNotification = @"SGDownloadFileProgressNotification";
NSNotificationName const SGDownloadFileCompletedNotificaton = @"SGDownloadFileCompletedNotificaton";
@interface SGDownloadFileTool ()
@property (nonatomic, strong) NSMutableDictionary *downloadTaskDic;
@property (nonatomic, strong) dispatch_semaphore_t sem;
@end

@implementation SGDownloadFileTool

#pragma mark - lazy load
- (NSMutableDictionary *)downloadTaskDic {
    if (_downloadTaskDic == nil) {
        _downloadTaskDic = [NSMutableDictionary dictionary];
    }
    return _downloadTaskDic;
}

+ (instancetype)sharedManager {
    static SGDownloadFileTool *sharedManager;
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        sharedManager = [[super allocWithZone:NULL] init];
    });
    return sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [SGDownloadFileTool sharedManager];
}

#pragma mark - public methods

- (void)downloadFilesWithURLStirngs:(NSArray *)URLStrings {
    [self downloadFilesWithURLStirngs:URLStrings concurrentCount:4];
}

- (void)downloadFilesWithURLStirngs:(NSArray *)URLStrings concurrentCount:(NSUInteger)count {
    
    self.sem = dispatch_semaphore_create(count);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < URLStrings.count; i++) {
            [self downloadFileWithURLString:URLStrings[i] progress:^(NSProgress * _Nonnull progress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                [NSNotificationCenter.defaultCenter postNotificationName:SGDownloadFileCompletedNotificaton object:response userInfo:@{@"URLString": URLStrings[i]}];
                dispatch_semaphore_signal(self->_sem);
            }];

            dispatch_semaphore_wait(self->_sem, DISPATCH_TIME_FOREVER);
        }
     });
}

- (void)downloadFileWithURLString:(NSString * )URLString
                         progress:(void (^)(NSProgress *progress))progress
                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    NSParameterAssert(URLString);
    
    if (SGIsFileExitWithURLString(URLString)) {
        NSURL *filePath = [NSURL fileURLWithPath:SGFilePathWithURLString(URLString)];
        completionHandler(nil, filePath, nil);
        return;
    }
    
    if (![self isReadyForDownloadFileWithURLString:URLString]) {
        return;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downloadTask = [SGBackgroundConfigHTTPSessionManager.sharedManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 当前线程为子线程，观察此通知的回调方法也在此子线程中
        [NSNotificationCenter.defaultCenter postNotificationName:SGDownloadFileProgressNotification object:downloadProgress userInfo:@{@"URLString": URLString}];
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:SGCreateFilePath(URLString)];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (filePath != nil && SGIsResumeDataExitWithURLString(URLString)) {// filePath 不为空时，表示下载完成
            SGRemoveResumeDataWithURLString(URLString); // 移除不再使用的 resumeData
        }
        completionHandler(response, filePath, error);
    }];
    
    [self.downloadTaskDic setObject:downloadTask forKey:SGFileNameWithURLString(URLString)];
    [downloadTask resume];
}

- (void)cancelDownloadWithURLString:(NSString *)URLString{
    
    NSParameterAssert(URLString);
    if (![self isReadyForCancelDownloadWithURLString:URLString]) {
        return;
    }
    
    NSURLSessionDownloadTask *downloadTask = self.downloadTaskDic[SGFileNameWithURLString(URLString)];
    if (downloadTask) {
        __weak typeof(self) weakSelf = self;
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.downloadTaskDic removeObjectForKey:SGFileNameWithURLString(URLString)];
            [resumeData writeToFile:SGCreateResumeDataFilePath(URLString) atomically:YES];
        }];
    }
}

- (void)resumeDownloadWithURLString:(NSString * )URLString
                           progress:(void (^)(NSProgress *progress))progress
                  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    NSParameterAssert(URLString);
    
    if (SGIsFileExitWithURLString(URLString)) {
        NSURL *filePath = [NSURL fileURLWithPath:SGFilePathWithURLString(URLString)];
        completionHandler(nil, filePath, nil);
        return;
     }
    
    if (![self isReadyForResumeDataWithURLString:URLString]) {
        return;
    }
    
    NSURLSessionDownloadTask *downloadTask = [SGBackgroundConfigHTTPSessionManager.sharedManager downloadTaskWithResumeData:SGResumeDataWithURLString(URLString) progress:^(NSProgress * _Nonnull downloadProgress) {
        [NSNotificationCenter.defaultCenter postNotificationName:SGDownloadFileProgressNotification object:downloadProgress];
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:SGCreateFilePath(URLString)];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (filePath != nil && SGIsResumeDataExitWithURLString(URLString)) {// filePath 不为空时，表示下载完成
            SGRemoveResumeDataWithURLString(URLString); // remove resumeData
        }
        completionHandler(response, filePath, error);
    }];
    SGRemoveResumeDataWithURLString(URLString); // remove resumeData
    [self.downloadTaskDic setObject:downloadTask forKey:SGFileNameWithURLString(URLString)];
    [downloadTask resume];
}

- (void)deleteDownloadTaskWithURLString:(NSString *)URLString
                             completion:(nonnull void (^)(NSError *))completion{
    NSParameterAssert(URLString);
    [NSFileManager.defaultManager removeItemAtPath:SGFilePathWithURLString(URLString) error:nil];
    [NSFileManager.defaultManager removeItemAtPath:SGResumeDataFilePathWithURLString(URLString) error:nil];
    NSURLSessionDownloadTask *downloadTask = self.downloadTaskDic[SGFileNameWithURLString(URLString)];
   if (downloadTask) {
       [self.downloadTaskDic removeObjectForKey:SGFileNameWithURLString(URLString)];
   }
    completion(nil);
}

#pragma mark - private methods
- (BOOL)isReadyForDownloadFileWithURLString:(NSString * _Nonnull)URLString {
    
    NSData *resumeData = SGResumeDataWithURLString(URLString);
    NSURLSessionDownloadTask *downloadTask = self.downloadTaskDic[SGFileNameWithURLString(URLString)];
    return  downloadTask == nil && resumeData == nil;
}

- (BOOL)isReadyForCancelDownloadWithURLString:(NSString * _Nonnull)URLString {
    
    NSURLSessionDownloadTask *downloadTask = self.downloadTaskDic[SGFileNameWithURLString(URLString)];
    return  downloadTask != nil;
}

- (BOOL)isReadyForResumeDataWithURLString:(NSString * _Nonnull)URLString {
    
    NSData *resumeData = SGResumeDataWithURLString(URLString);
    NSURLSessionDownloadTask *downloadTask = self.downloadTaskDic[SGFileNameWithURLString(URLString)];
    return downloadTask == nil && resumeData != nil;
}
@end
