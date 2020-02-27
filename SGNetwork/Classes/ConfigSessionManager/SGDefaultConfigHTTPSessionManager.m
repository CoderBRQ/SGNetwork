//
//  SGDefaultConfigHTTPSessionManager.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import "SGDefaultConfigHTTPSessionManager.h"

//localhost.charlesproxy.com
static NSString * const BaseURLString = @"http://localhost.charlesproxy.com:8080";
//static NSString * const BaseURLString = @"http://127.0.0.1:8080";

@implementation SGDefaultConfigHTTPSessionManager

+ (instancetype)sharedManager {
    static SGDefaultConfigHTTPSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SGDefaultConfigHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString] sessionConfiguration:[self.class defaultURLSessionConfiguration]];
        sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", @"image/jpeg", @"image/jpg",nil];
    });
    return sharedManager;
}

+ (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;// The default value is YES.
    configuration.timeoutIntervalForRequest = 20.0;// 超时时间
    return configuration;
}
@end
