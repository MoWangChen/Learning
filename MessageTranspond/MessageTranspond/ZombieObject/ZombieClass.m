//
//  ZombieClass.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/23.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ZombieClass.h"
#import <objc/runtime.h>

@implementation ZombieClass

@end

void printClassInfo(id obj) {
    Class cls = object_getClass(obj);
    Class superCls = class_getSuperclass(cls);
    NSLog(@"=== %s : %s ===",class_getName(cls),class_getName(superCls));
}

void testRelease() {
    ZombieClass *obj = [[ZombieClass alloc] init];
    NSLog(@"Before release");
    printClassInfo(obj);
    
    [obj release];
    NSLog(@"After release");
    printClassInfo(obj);
}
