//
//  DIProxy.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/8.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "DIProxy.h"

@interface DIProxy : NSProxy <DIProxy>

@end

@interface DIProxy ()

@property (nonatomic, strong) NSMutableDictionary *implementations;
- (id)init;

@end

@implementation DIProxy

id DIProxyCreate()
{
    return [[DIProxy alloc] init];
}

- (id)init
{
    self.implementations = [NSMutableDictionary dictionary];
    return self;
}

- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol
{
    NSParameterAssert(object && protocol);
    NSAssert([object conformsToProtocol:protocol], @"object %@ does not conform to protocol %@",object,protocol);
    self.implementations[NSStringFromProtocol(protocol)] = object;
}

#pragma mark - override
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    for (id object in self.implementations.allValues) {
        if ([object respondsToSelector:sel]) {
            return [object methodSignatureForSelector:sel];
        }
    }
    return [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    for (id object in self.implementations.allValues) {
        if ([object respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:object];
            return;
        }
    }
    [super forwardInvocation:invocation];
}

@end
