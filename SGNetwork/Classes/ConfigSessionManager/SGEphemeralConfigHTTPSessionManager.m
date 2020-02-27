//
//  SGEphemeralConfigHTTPSessionManager.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/9.
//

#import "SGEphemeralConfigHTTPSessionManager.h"

@implementation SGEphemeralConfigHTTPSessionManager

static NSString * const BaseURLString = @"https://www.api.com/";

+ (instancetype)sharedManager {
    
    static SGEphemeralConfigHTTPSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SGEphemeralConfigHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString] sessionConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    });
    return sharedManager;
}
@end
