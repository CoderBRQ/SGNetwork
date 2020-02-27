//
//  SGAppDelegate.m
//  SGNetwork
//
//  Created by CoderBRQ on 01/06/2020.
//  Copyright (c) 2020 CoderBRQ. All rights reserved.
//

#import "SGAppDelegate.h"
#import <SGNetwork/SGNetwork.h>
@implementation SGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"APP 启动：%s", __func__);
    return YES;
}
 
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"将变为非活跃状态：%s", __func__);
}
 
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"进入后台：%s", __func__);
}
 
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"由后台进入前台：%s", __func__);
}
 
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"变为活跃状态：%s", __func__);
}
 
- (void)applicationWillTerminate:(UIApplication *)application
{
    
    NSLog(@"杀死 APP %s", __func__);
}
 
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    NSLog(@" 应用处于后台，所有下载任务完成调用：%s", __func__);
}
@end
