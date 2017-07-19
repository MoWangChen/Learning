//
//  ViewController.m
//  CoreAnimation
//
//  Created by 谢鹏翔 on 2017/6/26.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"
#import "AlphaViewController.h"
#import "SolidViewController.h"
#import "TransformViewController.h"
#import "ReplicatorViewController.h"
#import "EmitterViewController.h"
#import "EAGLViewController.h"
#import "TransactionViewController.h"
#import "PresentationViewController.h"
#import "TimingFunctionController.h"
#import "InstrumentsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self testInstruments];
}

- (void)testInstruments
{
    [self presentViewController:[InstrumentsViewController new] animated:YES
                     completion:nil];
}

- (void)testTimingFunction
{
    [self presentViewController:[TimingFunctionController new] animated:YES completion:nil];
}

- (void)testPresentation
{
    [self presentViewController:[PresentationViewController new] animated:YES completion:nil];
}

- (void)testTransaction
{
    [self presentViewController:[TransactionViewController new] animated:YES completion:nil];
}

- (void)testEAGLLayer
{
    [self presentViewController:[EAGLViewController new] animated:YES completion:nil];
}

- (void)testEmitter
{
    [self presentViewController:[EmitterViewController new] animated:YES completion:nil];
}

- (void)testReplicator
{
    [self presentViewController:[ReplicatorViewController new] animated:YES completion:nil];
}

- (void)testTransform
{
    [self presentViewController:[TransformViewController new] animated:YES completion:nil];
}

- (void)testSolid
{
    [self presentViewController:[SolidViewController new] animated:YES completion:nil];
}

- (void)testAlpha
{
    [self presentViewController:[AlphaViewController new] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
