//
//  ScrollView.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

+ (Class)layerClass
{
    return [CAScrollLayer class];
}

- (void)setup
{
    // enable clipping
    self.layer.masksToBounds = YES;
    
    // attach pan gesture recognizer
    UIPanGestureRecognizer *recognizer = nil;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    
}

@end
