//
//  SGDefaultConfigHTTPSessionManager.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGDefaultConfigHTTPSessionManager : AFHTTPSessionManager
@property (class, readonly, strong) SGDefaultConfigHTTPSessionManager *sharedManager;
@end

NS_ASSUME_NONNULL_END
