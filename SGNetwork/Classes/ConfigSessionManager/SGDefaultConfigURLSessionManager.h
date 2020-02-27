//
//  SGDefaultConfigURLSessionManager.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/16.
//

#import "AFURLSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGDefaultConfigURLSessionManager : AFURLSessionManager
@property (class, readonly, strong) SGDefaultConfigURLSessionManager *sharedManager;
@end

NS_ASSUME_NONNULL_END
