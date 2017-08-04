//
//  Person.m
//  MessageTranspond
//
//  Created by 谢鹏翔 on 2017/8/3.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Car.h"

@implementation Person

#pragma mark - 动态添加方法
/**
 * 实现了resolveInstanceMethod这个方法为我的Person类动态增加了一个run方法的实现。
 *（什么是动态增加？其实就是在程序运行的时候给某类的某个方法增加实现。具体实现内容就为上面的void run 这个c函数。）
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
//    if (sel == @selector(run)) {
//        class_addMethod(self, sel, (IMP)run, "v@:");
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}

void run (id self, SEL _cmd)
{
    NSLog(@"%@ %s",self, sel_getName(_cmd));
}

#pragma mark - 消息传递
/**
 * forwardingTargetForSelector，这个方法返回你需要转发消息的对象
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    return [[Car alloc] init];
//}

#pragma mark - 方法签名
/**
 * 如果我们不实现forwardingTargetForSelector，系统就会调用方案三的两个方法methodSignatureForSelector和forwardInvocation
 * methodSignatureForSelector用来生成方法签名，这个签名就是给forwardInvocation中的参数NSInvocation调用的。
 * 错误unrecognized selector sent to instance原因，原来就是因为methodSignatureForSelector这个方法中，由于没有找到run对应的实现方法，所以返回了一个空的方法签名，最终导致程序报错崩溃
 */

/**
 * 关于生成签名的类型"v@:"解释一下。每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，_cmd代表这个方法的SEL
 * 签名类型就是用来描述这个方法的返回值、参数的，v代表返回值为void，@表示self，:表示_cmd。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    //判断要转发的SEL
    if ([sel isEqualToString:@"run"]) {
        //为你的转发方法手动生成签名
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    //新建需要转发消息的对象
    Car *car = [[Car alloc] init];
    if ([car respondsToSelector:selector]) {
        //唤醒这个方法
        [anInvocation invokeWithTarget:car];
    }
}

@end
