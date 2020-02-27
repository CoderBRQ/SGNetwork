//
//  SGDownloadFileTool.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 下载进度通知
/// @discussion: object: NSProgress isntance 下载进度;  userInfo[@"URLString"]  文件对应的URL
FOUNDATION_EXTERN NSNotificationName const SGDownloadFileProgressNotification;
FOUNDATION_EXTERN NSNotificationName const SGDownloadFileCompletedNotificaton;

@interface SGDownloadFileTool : NSObject

@property (class, readonly, strong) SGDownloadFileTool *sharedManager;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

/// 开始下载
/// @param URLString 下载 URL
/// @param progress 进度
/// @param completionHandler 完成回调
- (void)downloadFileWithURLString:(NSString *)URLString
                         progress:(void (^)(NSProgress *progress))progress
                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


///  批量下载
/// @param URLStrings 文件地址数组
/// @discussion 默认并发下载数 4
- (void)downloadFilesWithURLStirngs:(NSArray *)URLStrings;


/// 批量下载
/// @param URLStrings 文件地址数组
/// @param count 下载并发数
- (void)downloadFilesWithURLStirngs:(NSArray *)URLStrings concurrentCount:(NSUInteger)count;

/// 取消下载
/// @param URLString 下载 URL
- (void)cancelDownloadWithURLString:(NSString *)URLString;

///  恢复下载
/// @param URLString 下载 URL
/// @param progress 进度
/// @param completionHandler 完成回调
- (void)resumeDownloadWithURLString:(NSString *)URLString
                           progress:(void (^)(NSProgress *progress))progress
                  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/// 删除下载任务，以及对应的文件和 resumeData
/// @param URLString 文件对应的 URL
- (void)deleteDownloadTaskWithURLString:(NSString *)URLString
                             completion:(void (^)(NSError * _Nullable error))completion;
                    
@end

NS_ASSUME_NONNULL_END
