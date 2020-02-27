//
//  SGOneViewDowningView.m
//  SGNetwork_Example
//
//  Created by bianrongqiang on 2020/2/22.
//  Copyright © 2020 CoderBRQ. All rights reserved.
//

#import "SGOneViewDowningView.h"
#import <Masonry.h>

@implementation SGOneViewDowningView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    UILabel *downloadProcessLabel = [UILabel new];
    downloadProcessLabel.textColor = [UIColor blackColor];
    downloadProcessLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:downloadProcessLabel];
    [downloadProcessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(30);
    }];
    self.processLabel = downloadProcessLabel;
}
@end
