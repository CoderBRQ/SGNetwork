//
//  SGManager.h
//  SGNetwork
//
//  Created by bianrongqiang on 1/20/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGManager : NSObject
@property (nonatomic, class, readonly) SGManager *sharedManager;
- (void)fetchData;
@end

NS_ASSUME_NONNULL_END
