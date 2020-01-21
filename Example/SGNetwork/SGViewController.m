//
//  SGViewController.m
//  SGNetwork
//
//  Created by CoderBRQ on 01/06/2020.
//  Copyright (c) 2020 CoderBRQ. All rights reserved.
//

#import "SGViewController.h"
#import <SGHud.h>

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Take it easy");
    SGHud *hud = [[SGHud alloc] initWithFrame:CGRectMake(66, 111, 55, 77)];
    [self.view addSubview:hud];
    [self fk];
}

- (void)fk {
    NSLog(@"what the ");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"sljlsd");
}


@end
