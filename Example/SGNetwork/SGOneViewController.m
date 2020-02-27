//
//  SGOneViewController.m
//  SGNetwork_Example
//
//  Created by bianrongqiang on 2020/2/2.
//  Copyright © 2020 CoderBRQ. All rights reserved.
//

#import "SGOneViewController.h"
#import <SGNetwork/SGNetwork.h>
#import "SGOneViewDowningView.h"
#import <Masonry.h>

@interface SGOneViewController ()
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) SGOneViewDowningView *downgingView;
@end

@implementation SGOneViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self setUpButtons];
    
    [self setUpDownloadingView];
    [self setUpBottomView];
    
    [self addObServer];
}

- (void)addObServer {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(test:) name:SGDownloadFileProgressNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)test:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        // NSString *URLString = noti.userInfo[@"URLString"];
        NSProgress *progress = (NSProgress *)noti.object;
        CGFloat pro = (CGFloat)progress.completedUnitCount/(CGFloat)progress.totalUnitCount;
        self.downgingView.processLabel.text = [NSString stringWithFormat:@"%f", pro];
    });
}

- (void)setUpBottomView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-55);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)exitButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpDownloadingView {
    SGOneViewDowningView *downingView = [[SGOneViewDowningView alloc] init];
    downingView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:downingView];
    self.downgingView = downingView;
    
    [downingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
        make.height.mas_equalTo(200);
    }];
}

- (void)setUpButtons {
    UIView *v = [UIView new];
    [self.view addSubview:v];
    v.frame = self.view.bounds;
    v.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    [v addSubview:b];
    b.backgroundColor = [UIColor blueColor];
    [b setTitle:@"开始" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(bClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [v addSubview:b1];
    b1.backgroundColor = [UIColor blueColor];
    [b1 setTitle:@"取消" forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(b1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [v addSubview:b2];
    b2.backgroundColor = [UIColor blueColor];
    [b2 setTitle:@"恢复" forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(b2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [v addSubview:b3];
    b3.backgroundColor = [UIColor blueColor];
    [b3 setTitle:@"清空缓存" forState:UIControlStateNormal];
    [b3 addTarget:self action:@selector(b3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = @[b, b1, b2, b3];
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.height.mas_equalTo(80);
    }];
}

- (void)b3Clicked:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    [SGDownloadFileTool.sharedManager deleteDownloadTaskWithURLString:@"http://localhost.charlesproxy.com:8080/video/001.mp4" completion:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.downgingView.processLabel.text = @"缓存清空完成";
        });
    }];
}

- (void)bClicked:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    [SGDownloadFileTool.sharedManager downloadFileWithURLString:@"http://localhost.charlesproxy.com:8080/video/001.mp4" progress:^(NSProgress * _Nonnull progress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"%@", response);
            NSLog(@"下载完成。。。。。。。。。。。:%@", filePath);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.downgingView.processLabel.text = @"下载完成";
            });

        }
    }];
}

- (void)b1Clicked:(UIButton *)button {
    [SGDownloadFileTool.sharedManager cancelDownloadWithURLString:@"http://localhost.charlesproxy.com:8080/video/001.mp4"];
}

- (void)b2Clicked:(UIButton *)button {
    [SGDownloadFileTool.sharedManager resumeDownloadWithURLString:@"http://localhost.charlesproxy.com:8080/video/001.mp4" progress:^(NSProgress * _Nonnull progress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
    }];
}
@end
