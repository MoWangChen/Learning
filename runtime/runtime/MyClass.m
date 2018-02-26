//
//  MyClass.m
//  runtime
//
//  Created by 谢鹏翔 on 2018/2/26.
//  Copyright © 2018年 365ime. All rights reserved.
//

#import "MyClass.h"

@interface MyClass ()
{
    NSInteger _instance1;
    NSString *_instance2;
}

@property (nonatomic, assign) NSUInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass

+ (void)classMethod1
{
    NSLog(@"call class method1");
}

- (void)method1
{
    NSLog(@"call method method1");
}

- (void)method2
{
    NSLog(@"call method method2");
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2
{
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end
