//
//  PresentationViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/14.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "PresentationViewController.h"

@interface PresentationViewController ()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation PresentationViewController

// 使用呈现图层响应用户行为,而不是使用模型图层,呈现图层是当前显示在界面上的图层,在动画过程中,用户的操作可以精准的判断位置

- (void)viewDidLoad {
    [super viewDidLoad];

    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // check if we've tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        
        // randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }else {
        
        // otherwise (slowly) move the layer to new positon
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}




@end
