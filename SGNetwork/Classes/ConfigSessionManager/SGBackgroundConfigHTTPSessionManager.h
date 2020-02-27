//
//  SGBackgroundConfigHTTPSessionManager.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/9.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SGBackgroundConfigHTTPSessionManager : AFHTTPSessionManager
@property (class, readonly, strong) SGBackgroundConfigHTTPSessionManager *sharedManager;
@end

NS_ASSUME_NONNULL_END
