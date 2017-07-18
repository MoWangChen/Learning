//
//  TimingFunctionController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/18.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "TimingFunctionController.h"
#import "TimingFunctionTool.h"

@interface TimingFunctionController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation TimingFunctionController

// CAMediaTimingFunction functionWithControlPoints:::: 做出自定义的三次贝塞尔曲线

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    _containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_containerView];
    
     _ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    [self.view addSubview:_ballView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // replay animation to tap
    [self animate];
}

- (void)animate
{
    // reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    
    // set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numFrames];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        [frames addObject:[TimingFunctionTool interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    
    // create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = frames;
    
    // apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
    

}

@end
