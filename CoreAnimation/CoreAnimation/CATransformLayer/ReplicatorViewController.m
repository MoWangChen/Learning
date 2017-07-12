//
//  ReplicatorViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/7/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ReplicatorViewController.h"

@interface ReplicatorViewController ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation ReplicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    _containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_containerView];
    
    // create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:replicator];
    
    // configure the replicator
    replicator.instanceCount = 10;
    
    // apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 180, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -180, 0);
    replicator.instanceTransform = transform;
    
    // apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    // create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(125, 100, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
    
}

@end
