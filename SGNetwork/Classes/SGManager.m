//
//  SGManager.m
//  SGNetwork
//
//  Created by bianrongqiang on 1/20/20.
//

#import "SGManager.h"
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>



@implementation SGManager


+ (SGManager *)sharedManager {
    static SGManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:NULL] init];
    });
    return _sharedManager;
}

- (void)fetchData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.baidu.com" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}
@end
