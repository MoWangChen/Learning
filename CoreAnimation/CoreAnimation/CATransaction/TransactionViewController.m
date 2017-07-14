//
//  TransactionViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/13.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "TransactionViewController.h"
#import "EAGLViewController.h"
#import "EmitterViewController.h"

@interface TransactionViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, strong) UITabBarController *tabbar;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self testTabbarControllerFade];
}

#pragma mark - 过渡动画
// 对图层树的动画 (UITabBarController切换标签时,添加淡入淡出效果)
// CATransition 并不作用于指定图层属性,可以在即使不能准确得知改变了什么的情况下对图层做动画,例如UITableView哪一行被添加或者删除的情况下,直接就可以平滑的刷新
// 要确保CATransition添加到的图层在过渡动画发生时不会在树装结构中被移除,否则CATransition将会和图层一起被移除.只需要将动画添加到被影响图层的superLayer

// move to appDelegate
- (void)testTabbarControllerFade
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    EmitterViewController *emitter = [[EmitterViewController alloc] init];
    EAGLViewController *eagl = [[EAGLViewController alloc] init];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[emitter, eagl];
    tabbar.delegate = self;
    _tabbar = tabbar;
    window.rootViewController = _tabbar;
    [window makeKeyAndVisible];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    // apply transition to tabbar controller's view
    [_tabbar.tabBarController.view.layer addAnimation:transition forKey:nil];
}

#pragma mark - 隐式动画

- (void)testViewLayerChangeBackgroundColor
{
    // 图层行为
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(50.f, 50.f, 100.0f, 100.0f);
    self.colorLayer = view.layer;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 200, 80, 30.f);
    [button setTitle:@"change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)testLayerChangeBackgroundColor
{
    // 事务, 完成块
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.f, 50.f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // add a custom action
    CATransition *transtion = [CATransition animation];
    transtion.type = kCATransitionPush;
    transtion.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor":transtion};
    [self.view.layer addSublayer:self.colorLayer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 200, 80, 30.f);
    [button setTitle:@"change" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changeColor
{
    // 隐式动画
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    // 动画完成回调 [UIView animationDuration:completionBlock:]
    [CATransaction setCompletionBlock:^{
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}


@end
