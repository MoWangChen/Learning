//
//  DealerProxy.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/4.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "DealerProxy.h"
#import <objc/runtime.h>

@interface DealerProxy ()
{
    BookProvider        *_bookProvider;
    ClothesProvider     *_clothesProvider;
    NSMutableDictionary *_methodsMap;
}
@end

@implementation DealerProxy

+ (instancetype)dealerProxy
{
    return [[self alloc] init];
}

- (instancetype)init
{
    _bookProvider = [[BookProvider alloc] init];
    _clothesProvider = [[ClothesProvider alloc] init];
    _methodsMap = [NSMutableDictionary dictionary];
    
    [self _registerMethodsWithTarget:_bookProvider];
    [self _registerMethodsWithTarget:_clothesProvider];
    
    return self;
}

#pragma mark - private method
- (void)_registerMethodsWithTarget:(id)target
{
    unsigned int numberOfMethods = 0;
    
    // 获取target方法列表
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    
    for (int i = 0; i < numberOfMethods; i++) {
        // 获取方法名,并存入字典
        Method temp_method = method_list[i];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    free(method_list);
}

#pragma mark - override
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    // 获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    
    // 字典中查找对应target
    id target = _methodsMap[methodName];
    
    // 检查target
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    }else {
        return [super methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // 获取当前选择子
    SEL selector = [invocation selector];
    
    // 获取选择子方法名
    NSString *methodName = NSStringFromSelector(selector);
    
    // 字典中查找target
    id target = _methodsMap[methodName];
    
    // 检查target
    if (target && [target respondsToSelector:selector]) {
        [invocation invokeWithTarget:target];
    }else {
        [super forwardInvocation:invocation];
    }
}


@end
