//
//  SGDefaultConfigURLSessionManager.m
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import "SGDefaultConfigURLSessionManager.h"

@implementation SGDefaultConfigURLSessionManager
+ (instancetype)sharedManager {
    static SGDefaultConfigURLSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SGDefaultConfigURLSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    });
    return sharedManager;
}
@end
