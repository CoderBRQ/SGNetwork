//
//  SGViewController.m
//  SGNetwork
//
//  Created by CoderBRQ on 01/06/2020.
//  Copyright (c) 2020 CoderBRQ. All rights reserved.
//

#import "SGViewController.h"
#import <SDWebImage.h>
#import <SGNetwork/SGNetwork.h>
#import <SVProgressHUD.h>
#import <AVKit/AVKit.h>
#import "SGOneViewController.h"
#import <Masonry/Masonry.h>


@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    SGOneViewController *one = [SGOneViewController new];
    [self presentViewController:one animated:YES completion:nil];
}


@end

//
//// 多个请求后，继续下一个操作
//- (void)mutipleRequest {
//
//        dispatch_group_t group = dispatch_group_create();
//
//        dispatch_queue_t queue = dispatch_queue_create("asdfaaaasdf", DISPATCH_QUEUE_CONCURRENT);
//
//        dispatch_group_enter(group);
//
//        dispatch_group_async(group, queue, ^{
//            SGHTTPTool *tool = [[SGHTTPTool alloc] init];
//            [tool POST:@"/video" parameters:@{@"url_long" : @111222} progress:^(NSProgress * _Nonnull uploadProgress) {
//
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                dispatch_group_leave(group);
//                NSLog(@"22222");
//            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                dispatch_group_leave(group);
//                NSLog(@"22222yyyy");
//            }];
//        });
//
//        dispatch_group_enter(group);
//
//        dispatch_group_async(group, queue, ^{
//            SGHTTPTool *tool = [[SGHTTPTool alloc] init];
//            [tool POST:@"/video" parameters:@{@"url_long" : @111222} progress:^(NSProgress * _Nonnull uploadProgress) {
//
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                dispatch_group_leave(group);
//
//                NSLog(@"11111");
//            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                dispatch_group_leave(group);
//
//                NSLog(@"11111yyy");
//            }];
//        });
//
//        dispatch_group_enter(group);
//        dispatch_group_async(group, queue, ^{
//            SGHTTPTool *tool = [[SGHTTPTool alloc] init];
//            [tool POST:@"/video" parameters:@{@"url_long" : @111222} progress:^(NSProgress * _Nonnull uploadProgress) {
//
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                dispatch_group_leave(group);
//                NSLog(@"0000000");
//            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                dispatch_group_leave(group);
//                NSLog(@"0000000yyy");
//            }];
//        });
//
//        dispatch_group_notify(group, queue, ^{
//            NSLog(@"88888%s", __func__);
//            NSLog(@"=======================");
//        });
//}
//
//
//- (void)uploadImage {
//
//    UIImage *image2 = [UIImage imageNamed:@"login_btn_qq"];
//    SGUploadImagesTool *tool = [[SGUploadImagesTool alloc] initWithMaxConcurrentRequestsCount:1];
//
//    [tool uploadImages:@[image2, image2, image2, image2, image2, image2, image2, image2, image2, image2, image2]
//             urlString:@"v1/uploader"
//                fileID:@"file"
//          compressRate:0.5
//              progress:^(NSProgress * _Nonnull uploadProgress) {
//         NSLog(@"%@", uploadProgress);
//    }success:^(id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    }failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error.description);
//    }];
//}
