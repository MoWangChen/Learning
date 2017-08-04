//
//  ViewController.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "DealerProxy.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *person = [[Person alloc] init];
    [person run];
    
    DealerProxy *proxy = [DealerProxy dealerProxy];
    [proxy purchaseBookWithTitle:@"horizon"];
    [proxy purchaseClothesWithSize:@"small"];
}

@end
