//
//  SGHud.m
//  SGNetwork
//
//  Created by bianrongqiang on 1/20/20.
//

#import "SGHud.h"
#import <UIImageView+WebCache.h>

@interface SGHud ()
@property (nonatomic, weak) UIImageView *imageView;
@end
@implementation SGHud

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpImageView];
    }
    return self;
    
}

- (void)setUpImageView {
    UIImageView *v = [UIImageView new];
    self.imageView = v;
    [self addSubview:v];
    v.bounds = self.bounds;
    v.backgroundColor = [UIColor redColor];
    [v sd_setImageWithURL:nil];
}
@end
