//
//  SGBackgroundConfigHTTPSessionManager.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/9.
//

#import "SGBackgroundConfigHTTPSessionManager.h"

@implementation SGBackgroundConfigHTTPSessionManager
static NSString * const BaseURLString = @"https://api.app.com/";
+ (instancetype)sharedManager {
    static SGBackgroundConfigHTTPSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SGBackgroundConfigHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString] sessionConfiguration:[self.class backgroundSessionConfiguration]];
    });
    return sharedManager;
}

+ (NSURLSessionConfiguration *)backgroundSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.sgnetwork.backgroundtaskid"];

    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;

    /*
     对于HTTP和HTTPS协议，NSURLRequestUseProtocolCachePolicy执行以下行为:

     如果请求不存在缓存的响应，则URL加载系统从原始源获取数据。

   否则，如果缓存的响应没有指示每次都必须重新验证它，并且缓存的响应没有过时(过期)，URL加载系统将返回缓存的响应。
  如果缓存的响应失效或需要重新验证，则URL加载系统向原始源发出HEAD请求，以查看资源是否已更改。如果是，则URL加载系统从原始源获取数据。否则，它将返回缓存的响应。
     */
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;// Always use this policy if you are making HTTP or HTTPS byte-range requests.
    configuration.allowsCellularAccess = YES;// The default value is YES.
    configuration.timeoutIntervalForRequest = 60.0;// 超时时间;
    
    /*
     对于使用backgroundSessionConfigurationWithIdentifier:方法创建的配置对象，
     使用此属性让系统控制何时应该进行传输。对于使用其他方法创建的配置对象，此属性将被忽略。
     
    在传输大量数据时，建议将此属性的值设置为YES。这样做可以让系统在对设备更优的时间安排传输。
     例如，系统可能会延迟传输大文件，直到设备插入并通过Wi-Fi连接到网络。此属性的默认值为NO。
     
    session对象仅将此属性的值应用于应用程序在前台启动时的传输。
     对于应用程序在后台启动的传输，系统总是根据需要启动传输——换句话说，系统假设这个属性是YES，
     并忽略您指定的任何值。*/
    configuration.discretionary = YES;
    configuration.sessionSendsLaunchEvents = YES;
    configuration.HTTPMaximumConnectionsPerHost = 4;// 每个session下最大并发请求数量。iOS 默认是 4
    return configuration;
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    [super URLSession:session task:task didCompleteWithError:error];
//    if (error) {
//        NSDate *resumeData = error.userInfo[@"NSURLSessionDownloadTaskResumeData"];
//
//    }
//}
@end
